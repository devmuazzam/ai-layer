
CREATE VIEW rpt.v_UI_Payroll_Reconstruction_Audit
AS
WITH B AS
(
    SELECT
        b.LaborPayrollID,
        b.JobTicketID,
        b.JobCode,
        b.EmpID,
        b.Employee_Name,
        b.WorkDate,
        b.TimeStart_Labor,
        b.TimeEnd_Labor,
        b.HoursWorked_Raw
    FROM app.v_Base_LaborPayroll b
),
LA AS
(
    SELECT
        t.LaborPayrollID,
        LA_Start     = MIN(CONVERT(datetime2(0), t.Pay_Start_Rounded)),
        LA_End       = MAX(CONVERT(datetime2(0), t.Pay_End_Rounded)),
        LA_Total_Hrs = SUM(ISNULL(t.Duration_Total_Payable, 0.0))
    FROM calc.v_Calc_Labor_Timeline t
    WHERE ISNULL(t.Duration_Total_Payable, 0) > 0
      AND t.Pay_Start_Rounded < t.Pay_End_Rounded
    GROUP BY t.LaborPayrollID
),
TT AS
(
    SELECT
        b.LaborPayrollID,
        tt.Shift_Window_Start,
        tt.Shift_Window_End,
        TT_Shift_Hrs =
            CASE
                WHEN tt.Shift_Window_Start IS NOT NULL
                 AND tt.Shift_Window_End   IS NOT NULL
                 AND tt.Shift_Window_End > tt.Shift_Window_Start
                THEN CONVERT(decimal(10,2),
                     DATEDIFF(MINUTE, tt.Shift_Window_Start, tt.Shift_Window_End) / 60.0)
            END,
        TT_Boom_Start = tt.Boom_Window_Start,
        TT_Boom_End   = tt.Boom_Window_End,
        TT_Boom_Hrs =
            CASE
                WHEN tt.Boom_Window_Start IS NOT NULL
                 AND tt.Boom_Window_End   IS NOT NULL
                 AND tt.Boom_Window_End > tt.Boom_Window_Start
                THEN CONVERT(decimal(10,2),
                     DATEDIFF(MINUTE, tt.Boom_Window_Start, tt.Boom_Window_End) / 60.0)
            END,
        tt.Shift_Source_Start,
        tt.Shift_Source_End,
        tt.Boom_Source_Start,
        tt.Boom_Source_End,
        rn = ROW_NUMBER() OVER
             (
                PARTITION BY b.LaborPayrollID
                ORDER BY tt.TicketDate DESC, tt.JobTicketID DESC
             )
    FROM B b
    LEFT JOIN calc.TicketTimeline tt
      ON b.JobTicketID = tt.JobTicketID
),
PC AS
(
    SELECT
        pc.LaborPayrollID,
        pc.Act_Total_Hrs,
        pc.Act_Boom_Hrs,
        pc.Pay_Total_Hrs,
        pc.Hrs_ST,
        pc.Hrs_OT,
        pc.Hrs_DT,
        pc.Final_Gross_Pay,
        pc.CalculatedAt
    FROM fms.Payroll_Calculated pc
)
SELECT
    b.LaborPayrollID,
    b.JobTicketID,
    b.JobCode,
    b.EmpID,
    b.Employee_Name,
    b.WorkDate,

    b.TimeStart_Labor,
    b.TimeEnd_Labor,
    b.HoursWorked_Raw,

    la.LA_Start,
    la.LA_End,
    la.LA_Total_Hrs,

    tt.Shift_Window_Start AS TT_Shift_Start,
    tt.Shift_Window_End   AS TT_Shift_End,
    tt.TT_Shift_Hrs,
    tt.TT_Boom_Start,
    tt.TT_Boom_End,
    tt.TT_Boom_Hrs,
    tt.Shift_Source_Start,
    tt.Shift_Source_End,
    tt.Boom_Source_Start,
    tt.Boom_Source_End,

    pc.Act_Total_Hrs,
    pc.Act_Boom_Hrs,
    pc.Pay_Total_Hrs,
    pc.Hrs_ST,
    pc.Hrs_OT,
    pc.Hrs_DT,
    pc.Final_Gross_Pay,
    pc.CalculatedAt,

    Diff_LA_vs_TT_Start_Min =
        CASE
            WHEN la.LA_Start IS NOT NULL
             AND tt.Shift_Window_Start IS NOT NULL
            THEN DATEDIFF(MINUTE, la.LA_Start, tt.Shift_Window_Start)
        END,

    Diff_LA_vs_TT_End_Min =
        CASE
            WHEN la.LA_End IS NOT NULL
             AND tt.Shift_Window_End IS NOT NULL
            THEN DATEDIFF(MINUTE, la.LA_End, tt.Shift_Window_End)
        END,

    Diff_HoursWorked_vs_LA_Hrs =
        CASE
            WHEN b.HoursWorked_Raw IS NOT NULL
             AND la.LA_Total_Hrs IS NOT NULL
            THEN CONVERT(decimal(10,2), b.HoursWorked_Raw - la.LA_Total_Hrs)
        END,

    Diff_ActTotal_vs_LA_Hrs =
        CASE
            WHEN pc.Act_Total_Hrs IS NOT NULL
             AND la.LA_Total_Hrs IS NOT NULL
            THEN CONVERT(decimal(10,2), pc.Act_Total_Hrs - la.LA_Total_Hrs)
        END,

    Diff_ActTotal_vs_TT_Shift_Hrs =
        CASE
            WHEN pc.Act_Total_Hrs IS NOT NULL
             AND tt.TT_Shift_Hrs IS NOT NULL
            THEN CONVERT(decimal(10,2), pc.Act_Total_Hrs - tt.TT_Shift_Hrs)
        END,

    Flag_LA_TT_Shift_Mismatch =
        CASE
            WHEN ABS(ISNULL(DATEDIFF(MINUTE, la.LA_Start, tt.Shift_Window_Start), 0)) >= 30
              OR ABS(ISNULL(DATEDIFF(MINUTE, la.LA_End,   tt.Shift_Window_End),   0)) >= 30
            THEN 1 ELSE 0
        END,

    Flag_HoursWorked_vs_LA_Mismatch =
        CASE
            WHEN b.HoursWorked_Raw IS NOT NULL
             AND la.LA_Total_Hrs IS NOT NULL
             AND ABS(b.HoursWorked_Raw - la.LA_Total_Hrs) >= 1.0
            THEN 1 ELSE 0
        END,

    Flag_ActTotal_vs_LA_Mismatch =
        CASE
            WHEN pc.Act_Total_Hrs IS NOT NULL
             AND la.LA_Total_Hrs IS NOT NULL
             AND ABS(pc.Act_Total_Hrs - la.LA_Total_Hrs) >= 1.0
            THEN 1 ELSE 0
        END,

    Flag_ActTotal_vs_TT_Mismatch =
        CASE
            WHEN pc.Act_Total_Hrs IS NOT NULL
             AND tt.TT_Shift_Hrs IS NOT NULL
             AND ABS(pc.Act_Total_Hrs - tt.TT_Shift_Hrs) >= 1.0
            THEN 1 ELSE 0
        END,

    Flag_Possible_24Plus_Reconstruction_Issue =
        CASE
            WHEN ISNULL(b.HoursWorked_Raw, 0) >= 24
              OR (pc.Act_Total_Hrs IS NOT NULL AND la.LA_Total_Hrs IS NOT NULL
                  AND ABS(pc.Act_Total_Hrs - la.LA_Total_Hrs) >= 12)
              OR (b.HoursWorked_Raw IS NOT NULL AND la.LA_Total_Hrs IS NOT NULL
                  AND ABS(b.HoursWorked_Raw - la.LA_Total_Hrs) >= 12)
            THEN 1 ELSE 0
        END,

    Audit_Status =
        CASE
            WHEN
                (
                    ISNULL(b.HoursWorked_Raw, 0) >= 24
                    OR (pc.Act_Total_Hrs IS NOT NULL AND la.LA_Total_Hrs IS NOT NULL
                        AND ABS(pc.Act_Total_Hrs - la.LA_Total_Hrs) >= 12)
                    OR (b.HoursWorked_Raw IS NOT NULL AND la.LA_Total_Hrs IS NOT NULL
                        AND ABS(b.HoursWorked_Raw - la.LA_Total_Hrs) >= 12)
                )
                AND
                (
                    ABS(ISNULL(DATEDIFF(MINUTE, la.LA_Start, tt.Shift_Window_Start), 0)) >= 30
                    OR ABS(ISNULL(DATEDIFF(MINUTE, la.LA_End,   tt.Shift_Window_End),   0)) >= 30
                )
            THEN 'Shift Mismatch + Reconstruction Suspect'

            WHEN
                ISNULL(b.HoursWorked_Raw, 0) >= 24
                OR (pc.Act_Total_Hrs IS NOT NULL AND la.LA_Total_Hrs IS NOT NULL
                    AND ABS(pc.Act_Total_Hrs - la.LA_Total_Hrs) >= 12)
                OR (b.HoursWorked_Raw IS NOT NULL AND la.LA_Total_Hrs IS NOT NULL
                    AND ABS(b.HoursWorked_Raw - la.LA_Total_Hrs) >= 12)
            THEN 'Reconstruction Suspect'

            WHEN
                ABS(ISNULL(DATEDIFF(MINUTE, la.LA_Start, tt.Shift_Window_Start), 0)) >= 30
                OR ABS(ISNULL(DATEDIFF(MINUTE, la.LA_End,   tt.Shift_Window_End),   0)) >= 30
            THEN 'Shift Mismatch'

            ELSE 'OK'
        END,

    Needs_Manager_Review =
        CASE
            WHEN
                (
                    ABS(ISNULL(DATEDIFF(MINUTE, la.LA_Start, tt.Shift_Window_Start), 0)) >= 30
                    OR ABS(ISNULL(DATEDIFF(MINUTE, la.LA_End,   tt.Shift_Window_End),   0)) >= 30
                    OR (ISNULL(b.HoursWorked_Raw, 0) >= 24)
                    OR (pc.Act_Total_Hrs IS NOT NULL AND la.LA_Total_Hrs IS NOT NULL
                        AND ABS(pc.Act_Total_Hrs - la.LA_Total_Hrs) >= 12)
                    OR (b.HoursWorked_Raw IS NOT NULL AND la.LA_Total_Hrs IS NOT NULL
                        AND ABS(b.HoursWorked_Raw - la.LA_Total_Hrs) >= 12)
                )
            THEN 1 ELSE 0
        END
FROM B b
LEFT JOIN LA la
  ON b.LaborPayrollID = la.LaborPayrollID
LEFT JOIN TT tt
  ON b.LaborPayrollID = tt.LaborPayrollID
 AND tt.rn = 1
LEFT JOIN PC pc
  ON b.LaborPayrollID = pc.LaborPayrollID;
