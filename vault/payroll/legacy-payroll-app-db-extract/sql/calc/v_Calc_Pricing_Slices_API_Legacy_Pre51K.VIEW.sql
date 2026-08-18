

CREATE     VIEW [calc].[v_Calc_Pricing_Slices_API_Legacy_Pre51K]
AS
WITH
E1(N) AS
(
    SELECT 1
    FROM (VALUES (1),(1),(1),(1),(1),(1),(1),(1),(1),(1)) dt(n)
),
E2(N) AS
(
    SELECT 1 FROM E1 a CROSS JOIN E1 b
),
E3(N) AS
(
    SELECT 1 FROM E2 a CROSS JOIN E1 b
),
Tally(N) AS
(
    SELECT ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) - 1
    FROM E3
),

RawRange AS
(
    SELECT
        P.LaborPayrollID,
        P.JobTicketID,
        P.JobCode,
        P.EmpID,
        P.Employee_Name,

        TicketDate = COALESCE(T.TicketDate, CAST(P.WorkDate AS date)),
        P.WorkDate,

        L.Shift_Start,
        L.Shift_End,

        Boom_Start = T.Boom_Window_Start,
        Boom_End   = T.Boom_Window_End,

        /* PATCH:
           Previous logic:
               COALESCE(P.CraftPayRate, 0.00)

           New resolved-rate priority:
               1) CraftPayRate
               2) Source_Rate_Raw
               3) Source_Amount_Raw / HoursWorked_Raw
               4) 0.00

           Source_Rate_Raw is accepted without warning.
           Implied amount/hour fallback is included for future-proofing.
        */
        Rate_Base =
            COALESCE
            (
                NULLIF(CONVERT(decimal(12,3), ISNULL(P.CraftPayRate, 0.000)), 0.000),
                NULLIF(CONVERT(decimal(12,3), ISNULL(P.Source_Rate_Raw, 0.000)), 0.000),
                CASE
                    WHEN ISNULL(P.Source_Amount_Raw, 0.000) > 0.000
                     AND ISNULL(P.HoursWorked_Raw, 0.000) > 0.000
                    THEN CONVERT(decimal(12,3), P.Source_Amount_Raw / NULLIF(P.HoursWorked_Raw, 0.000))
                    ELSE NULL
                END,
                CONVERT(decimal(12,3), 0.000)
            ),

        ISNULL(S.Premium_Hourly_Add, 0.00) AS Rate_Shift,
        ISNULL(P.CraftModifierPayRateAdjustment, 0.00) AS Rate_Boom,

        ISNULL(H.HolidayName, 'Standard') AS Holiday_Name,
        DATENAME(weekday, CAST(P.WorkDate AS date)) AS Week_Day,

        ISNULL(M.Standard_Start_Time, '06:00:00') AS Cfg_Start_Time,
        ISNULL(M.Standard_End_Time,   '17:00:00') AS Cfg_End_Time,

        ISNULL(M.OT_Multiplier, 1.50) AS Mul_OT,
        ISNULL(M.DT_Multiplier, 2.00) AS Mul_DT,
        ISNULL(M.Saturday_Multiplier, 1.50) AS Mul_Sat,
        ISNULL(M.Sunday_Multiplier,   2.00) AS Mul_Sun,
        ISNULL(M.Holiday_Multiplier,  3.00) AS Mul_Hol,

        ISNULL(M.Standard_Hours_Daily, 8.0) AS Limit_Reg,
        ISNULL(M.DoubleTime_Threshold_Daily, 12.0) AS Limit_OT,

        CASE
            WHEN MONTH(CAST(P.WorkDate AS date)) IN (6, 12)
             AND DATENAME(weekday, CAST(P.WorkDate AS date)) = 'Saturday'
             AND DAY(CAST(P.WorkDate AS date)) <= 7
            THEN 1 ELSE 0
        END AS Is_Special_Saturday
    FROM app.v_Base_LaborPayroll P
    CROSS APPLY
    (
        SELECT
            Shift_Start = MIN(LT.Pay_Start_Rounded),
            Shift_End   = MAX(LT.Pay_End_Rounded)
        FROM calc.v_Calc_Labor_Timeline LT
        WHERE LT.LaborPayrollID = P.LaborPayrollID
    ) L
    LEFT JOIN calc.v_Calc_Ticket_Timeline_Fast T
        ON P.JobTicketID = T.JobTicketID
    LEFT JOIN app.v_LaborPayroll_CommentTokens CT
        ON CT.LaborPayrollID = P.LaborPayrollID
    LEFT JOIN cfg.Union_Shift_Rules S
        ON S.UnionCode = 'L12'
       AND S.ShiftCode =
            CASE
                WHEN ISNULL(CT.Has_ConflictingShiftTokens, 0) = 1 THEN 1
                ELSE ISNULL(CT.PayrollShiftCode_FromComments, 1)
            END
    LEFT JOIN cfg.Union_Master_Rules M
        ON M.UnionCode = 'L12'
    LEFT JOIN dim.LU12_Holiday H
        ON H.[Date] = CAST(P.WorkDate AS date)
),

Slices AS
(
    SELECT
        R.*,

        SliceIndex = T.N,
        Slice_Start = DATEADD(minute, 30 * T.N,       R.Shift_Start),
        Slice_End   = DATEADD(minute, 30 * (T.N + 1), R.Shift_Start),
        Slice_Hours = CAST(0.5 AS decimal(9,2)),

        Is_Boom_Active =
            CASE
                WHEN R.Boom_Start IS NOT NULL
                 AND R.Boom_End   IS NOT NULL
                 AND DATEADD(minute, 30 * T.N,       R.Shift_Start) >= R.Boom_Start
                 AND DATEADD(minute, 30 * (T.N + 1), R.Shift_Start) <= R.Boom_End
                THEN 1 ELSE 0
            END,

        Is_Outside_Window =
            CASE
                WHEN CAST(DATEADD(minute, 30 * T.N, R.Shift_Start) AS time(0)) <  R.Cfg_Start_Time
                  OR CAST(DATEADD(minute, 30 * T.N, R.Shift_Start) AS time(0)) >= R.Cfg_End_Time
                THEN 1 ELSE 0
            END,

        Is_PrevDay_ST_Reentry_Block =
            CASE
                WHEN R.Is_Special_Saturday = 0
                 AND R.Holiday_Name = 'Standard'
                 AND R.Week_Day NOT IN ('Saturday', 'Sunday')
                 AND CAST(R.Shift_Start AS date) < CAST(DATEADD(minute, 30 * T.N, R.Shift_Start) AS date)
                 AND CAST(DATEADD(minute, 30 * T.N, R.Shift_Start) AS time(0)) >= R.Cfg_Start_Time
                 AND CAST(DATEADD(minute, 30 * T.N, R.Shift_Start) AS time(0)) <  R.Cfg_End_Time
                THEN 1 ELSE 0
            END,

        Accumulation_Status =
            CASE
                WHEN ((T.N + 1) * 0.5) > R.Limit_OT
                    THEN 'DT_Daily'

                WHEN
                    R.Is_Special_Saturday = 0
                    AND R.Holiday_Name = 'Standard'
                    AND R.Week_Day NOT IN ('Saturday', 'Sunday')
                    AND
                    (
                        (
                            CAST(R.Shift_Start AS date) = CAST(DATEADD(minute, 30 * T.N, R.Shift_Start) AS date)
                            AND CAST(R.Shift_Start AS time(0)) < R.Cfg_Start_Time
                            AND DATEADD(minute, 30 * (T.N + 1), R.Shift_Start) >
                                DATEADD
                                (
                                    SECOND,
                                    DATEDIFF(SECOND, CAST('00:00:00' AS time(0)), R.Cfg_Start_Time),
                                    CAST(CAST(R.Shift_Start AS date) AS datetime2(0))
                                )
                            AND
                            (
                                DATEDIFF
                                (
                                    MINUTE,
                                    DATEADD
                                    (
                                        SECOND,
                                        DATEDIFF(SECOND, CAST('00:00:00' AS time(0)), R.Cfg_Start_Time),
                                        CAST(CAST(R.Shift_Start AS date) AS datetime2(0))
                                    ),
                                    DATEADD(minute, 30 * (T.N + 1), R.Shift_Start)
                                ) / 60.0
                            ) > R.Limit_Reg
                        )
                        OR
                        (
                            CAST(R.Shift_Start AS date) = CAST(DATEADD(minute, 30 * T.N, R.Shift_Start) AS date)
                            AND CAST(R.Shift_Start AS time(0)) >= R.Cfg_Start_Time
                            AND CAST(R.Shift_Start AS time(0)) <  R.Cfg_End_Time
                            AND ((T.N + 1) * 0.5) > R.Limit_Reg
                        )
                    )
                    THEN 'OT_Daily'

                ELSE 'Reg_Daily'
            END,

        Day_Type =
            CASE
                WHEN R.Is_Special_Saturday = 1    THEN 'SPECIAL_SAT'
                WHEN R.Holiday_Name <> 'Standard' THEN 'HOLIDAY'
                WHEN R.Week_Day = 'Sunday'        THEN 'SUNDAY'
                WHEN R.Week_Day = 'Saturday'      THEN 'SATURDAY'
                ELSE 'WEEKDAY'
            END
    FROM RawRange R
    INNER JOIN Tally T
        ON DATEADD(minute, 30 * T.N, R.Shift_Start) < R.Shift_End
),

Rated AS
(
    SELECT
        S.*,

        Final_Multiplier =
            CASE
                WHEN S.Day_Type = 'HOLIDAY'                           THEN S.Mul_Hol
                WHEN S.Day_Type = 'SUNDAY'                            THEN S.Mul_Sun
                WHEN S.Day_Type = 'SPECIAL_SAT'                       THEN S.Mul_DT
                WHEN S.Accumulation_Status = 'DT_Daily'               THEN S.Mul_DT
                WHEN S.Is_Outside_Window = 1 AND S.Day_Type='WEEKDAY' THEN S.Mul_OT
                WHEN S.Is_PrevDay_ST_Reentry_Block = 1                THEN S.Mul_OT
                WHEN S.Accumulation_Status = 'OT_Daily'               THEN S.Mul_OT
                WHEN S.Day_Type = 'SATURDAY'                          THEN S.Mul_Sat
                ELSE 1.0
            END,

        Rate_Boom_Applied =
            CASE
                WHEN S.Is_Boom_Active = 1 THEN COALESCE(S.Rate_Boom, 0.00)
                ELSE 0.00
            END,

        Hourly_Rate_Raw =
            (
                COALESCE(S.Rate_Base,  0.00)
              + COALESCE(S.Rate_Shift, 0.00)
              + CASE WHEN S.Is_Boom_Active = 1 THEN COALESCE(S.Rate_Boom, 0.00) ELSE 0.00 END
            )
    FROM Slices S
)

SELECT
    LaborPayrollID,
    JobTicketID,
    JobCode,
    EmpID,
    Employee_Name,
    TicketDate,
    WorkDate,
    Shift_Start,
    Shift_End,
    Boom_Start,
    Boom_End,
    SliceIndex,
    Slice_Start,
    Slice_End,
    Slice_Hours,
    Holiday_Name,
    Week_Day,
    Day_Type,
    Accumulation_Status,
    Is_Boom_Active,
    Is_Outside_Window,
    Cfg_Start_Time,
    Cfg_End_Time,
    Limit_Reg,
    Limit_OT,
    Rate_Base,
    Rate_Shift,
    Rate_Boom,
    Rate_Boom_Applied,
    Mul_OT,
    Mul_DT,
    Mul_Sat,
    Mul_Sun,
    Mul_Hol,
    Final_Multiplier,
    Hourly_Rate_Raw,
    Effective_Rate = CAST(Hourly_Rate_Raw * Final_Multiplier AS decimal(12,4)),
    Slice_Pay      = CAST(0.5 * Hourly_Rate_Raw * Final_Multiplier AS decimal(12,4))
FROM Rated;
