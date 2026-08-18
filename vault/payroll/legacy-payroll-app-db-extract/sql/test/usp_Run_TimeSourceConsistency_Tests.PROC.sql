
/* ============================================================
   17 - Create Time Source Consistency Runner
   SAFE CHANGE: creates/updates test stored procedure only

   Usage:
     EXEC test.usp_Run_TimeSourceConsistency_Tests;
   ============================================================ */

CREATE   PROCEDURE test.usp_Run_TimeSourceConsistency_Tests
      @CaseCode varchar(80) = NULL
    , @IncludeInactive bit = 0
    , @Tol decimal(10,4) = 0.01
AS
BEGIN
    SET NOCOUNT ON;

    IF OBJECT_ID('tempdb..#Result') IS NOT NULL DROP TABLE #Result;

    ;WITH LaborTimeline AS
    (
        SELECT
            c.CaseID,
            c.CaseCode,
            c.LaborPayrollID,

            Labor_Start = MIN(t.Pay_Start_Rounded),
            Labor_End   = MAX(t.Pay_End_Rounded),

            Labor_Hrs =
                CONVERT(decimal(10,2),
                    CASE
                        WHEN MIN(t.Pay_Start_Rounded) IS NULL
                          OR MAX(t.Pay_End_Rounded) IS NULL
                          OR MAX(t.Pay_End_Rounded) <= MIN(t.Pay_Start_Rounded)
                        THEN NULL
                        ELSE DATEDIFF(MINUTE, MIN(t.Pay_Start_Rounded), MAX(t.Pay_End_Rounded)) / 60.0
                    END
                )
        FROM test.Case_TimeSourceConsistency c
        LEFT JOIN calc.v_Calc_Labor_Timeline t
            ON t.LaborPayrollID = c.LaborPayrollID
        WHERE
            (@CaseCode IS NULL OR c.CaseCode = @CaseCode)
            AND (@IncludeInactive = 1 OR c.IsActive = 1)
        GROUP BY
            c.CaseID,
            c.CaseCode,
            c.LaborPayrollID
    ),
    TicketRef AS
    (
        SELECT
            c.CaseID,
            Ticket_Shift_Start = tt.Shift_Window_Start,
            Ticket_Shift_End   = tt.Shift_Window_End,

            Ticket_Hrs =
                CONVERT(decimal(10,2),
                    CASE
                        WHEN tt.Shift_Window_Start IS NULL
                          OR tt.Shift_Window_End IS NULL
                          OR tt.Shift_Window_End <= tt.Shift_Window_Start
                        THEN NULL
                        ELSE DATEDIFF(MINUTE, tt.Shift_Window_Start, tt.Shift_Window_End) / 60.0
                    END
                )
        FROM test.Case_TimeSourceConsistency c
        JOIN fms.Payroll_Calculated pc
            ON pc.LaborPayrollID = c.LaborPayrollID
        LEFT JOIN calc.TicketTimeline tt
            ON tt.JobTicketID = pc.JobTicketID
        WHERE
            (@CaseCode IS NULL OR c.CaseCode = @CaseCode)
            AND (@IncludeInactive = 1 OR c.IsActive = 1)
    ),
    SliceAgg AS
    (
        SELECT
            c.CaseID,
            Slice_Start = MIN(s.Slice_Start),
            Slice_End   = MAX(s.Slice_End),
            Slice_Hrs   = CONVERT(decimal(10,2), SUM(s.Slice_Hours)),
            SliceCount  = COUNT_BIG(s.LaborPayrollID)
        FROM test.Case_TimeSourceConsistency c
        LEFT JOIN api.v_UI_Pricing_Slices_Advanced s
            ON s.LaborPayrollID = c.LaborPayrollID
        WHERE
            (@CaseCode IS NULL OR c.CaseCode = @CaseCode)
            AND (@IncludeInactive = 1 OR c.IsActive = 1)
        GROUP BY c.CaseID
    ),
    Base AS
    (
        SELECT
            c.CaseID,
            c.CaseCode,
            c.LaborPayrollID,
            c.ExpectedSource,
            c.Expected_Labor_Hrs,
            c.Expected_Ticket_Hrs,
            c.Expected_Act_Total_Hrs,
            c.Notes,

            pc.EmpID,
            pc.Employee_Name,
            WorkDate = CONVERT(date, pc.WorkDate),
            pc.JobTicketID,
            pc.JobCode,

            lt.Labor_Start,
            lt.Labor_End,
            lt.Labor_Hrs,

            tr.Ticket_Shift_Start,
            tr.Ticket_Shift_End,
            tr.Ticket_Hrs,

            sa.Slice_Start,
            sa.Slice_End,
            sa.Slice_Hrs,
            sa.SliceCount,

            pc.Act_Total_Hrs,
            pc.Hrs_ST,
            pc.Hrs_OT,
            pc.Hrs_DT
        FROM test.Case_TimeSourceConsistency c
        LEFT JOIN fms.Payroll_Calculated pc
            ON pc.LaborPayrollID = c.LaborPayrollID
        LEFT JOIN LaborTimeline lt
            ON lt.CaseID = c.CaseID
        LEFT JOIN TicketRef tr
            ON tr.CaseID = c.CaseID
        LEFT JOIN SliceAgg sa
            ON sa.CaseID = c.CaseID
        WHERE
            (@CaseCode IS NULL OR c.CaseCode = @CaseCode)
            AND (@IncludeInactive = 1 OR c.IsActive = 1)
    )
    SELECT
        CaseID,
        CaseCode,
        LaborPayrollID,
        EmpID,
        Employee_Name,
        WorkDate,
        JobTicketID,
        JobCode,

        Labor_Start,
        Labor_End,
        Expected_Labor_Hrs,
        Labor_Hrs,

        Ticket_Shift_Start,
        Ticket_Shift_End,
        Expected_Ticket_Hrs,
        Ticket_Hrs,

        Slice_Start,
        Slice_End,
        Slice_Hrs,
        SliceCount,

        Expected_Act_Total_Hrs,
        Act_Total_Hrs,
        Hrs_ST,
        Hrs_OT,
        Hrs_DT,

        PayrollUsesLaborTimeline =
            CONVERT(bit,
                CASE
                    WHEN Labor_Hrs IS NOT NULL
                     AND Act_Total_Hrs IS NOT NULL
                     AND ABS(Act_Total_Hrs - Labor_Hrs) <= @Tol
                    THEN 1 ELSE 0
                END
            ),

        PayrollUsesTicketShift =
            CONVERT(bit,
                CASE
                    WHEN Ticket_Hrs IS NOT NULL
                     AND Act_Total_Hrs IS NOT NULL
                     AND ABS(Act_Total_Hrs - Ticket_Hrs) <= @Tol
                    THEN 1 ELSE 0
                END
            ),

        SliceUsesLaborTimeline =
            CONVERT(bit,
                CASE
                    WHEN Slice_Hrs IS NOT NULL
                     AND Labor_Hrs IS NOT NULL
                     AND ABS(Slice_Hrs - Labor_Hrs) <= @Tol
                     AND Slice_Start = Labor_Start
                     AND Slice_End = Labor_End
                    THEN 1 ELSE 0
                END
            ),

        SliceUsesTicketShift =
            CONVERT(bit,
                CASE
                    WHEN Slice_Hrs IS NOT NULL
                     AND Ticket_Hrs IS NOT NULL
                     AND ABS(Slice_Hrs - Ticket_Hrs) <= @Tol
                     AND Slice_Start = Ticket_Shift_Start
                     AND Slice_End = Ticket_Shift_End
                    THEN 1 ELSE 0
                END
            ),

        Pass =
            CONVERT(bit,
                CASE
                    WHEN Labor_Hrs IS NOT NULL
                     AND Act_Total_Hrs IS NOT NULL
                     AND Slice_Hrs IS NOT NULL

                     -- Final payroll must match LaborPayroll/timeline.
                     AND ABS(Act_Total_Hrs - Labor_Hrs) <= @Tol

                     -- Slice path must also match LaborPayroll/timeline.
                     AND ABS(Slice_Hrs - Labor_Hrs) <= @Tol
                     AND Slice_Start = Labor_Start
                     AND Slice_End = Labor_End

                     -- Expected case values must match.
                     AND ABS(Labor_Hrs - Expected_Labor_Hrs) <= @Tol
                     AND ABS(Act_Total_Hrs - Expected_Act_Total_Hrs) <= @Tol

                     -- These cases are intentionally selected because ticket differs.
                     AND (
                            Expected_Ticket_Hrs IS NULL
                         OR ABS(ISNULL(Ticket_Hrs, -999) - Expected_Ticket_Hrs) <= @Tol
                         )

                     -- If Ticket differs, payroll/slice must not use it.
                     AND (
                            Ticket_Hrs IS NULL
                         OR ABS(Ticket_Hrs - Labor_Hrs) <= @Tol
                         OR (
                                ABS(Act_Total_Hrs - Ticket_Hrs) > @Tol
                            AND ABS(Slice_Hrs - Ticket_Hrs) > @Tol
                            )
                         )
                    THEN 1 ELSE 0
                END
            ),

        Finding =
            CASE
                WHEN Labor_Hrs IS NULL THEN 'FAIL: Missing LaborPayroll/timeline hours.'
                WHEN Act_Total_Hrs IS NULL THEN 'FAIL: Missing fms.Payroll_Calculated row.'
                WHEN Slice_Hrs IS NULL THEN 'FAIL: Missing API slice rows.'
                WHEN ABS(Act_Total_Hrs - Labor_Hrs) > @Tol THEN 'FAIL: Final payroll does not match LaborPayroll/timeline.'
                WHEN ABS(Slice_Hrs - Labor_Hrs) > @Tol OR Slice_Start <> Labor_Start OR Slice_End <> Labor_End THEN 'FAIL: Slice path does not match LaborPayroll/timeline.'
                WHEN Ticket_Hrs IS NOT NULL
                 AND ABS(Ticket_Hrs - Labor_Hrs) > @Tol
                 AND ABS(Act_Total_Hrs - Ticket_Hrs) <= @Tol THEN 'FAIL: Final payroll appears to use JobTicket shift hours.'
                WHEN Ticket_Hrs IS NOT NULL
                 AND ABS(Ticket_Hrs - Labor_Hrs) > @Tol
                 AND ABS(Slice_Hrs - Ticket_Hrs) <= @Tol THEN 'FAIL: Slice path appears to use JobTicket shift hours.'
                ELSE 'PASS: Final payroll and slice path use LaborPayroll/timeline shift hours.'
            END,

        Notes
    INTO #Result
    FROM Base;


    SELECT
        TotalCases = COUNT_BIG(*),
        PassedCases = SUM(CASE WHEN Pass = 1 THEN 1 ELSE 0 END),
        FailedCases = SUM(CASE WHEN Pass = 0 THEN 1 ELSE 0 END),
        OverallPass = CONVERT(bit, CASE WHEN MIN(CONVERT(int, Pass)) = 1 THEN 1 ELSE 0 END)
    FROM #Result;


    SELECT *
    FROM #Result
    ORDER BY
        Pass,
        CaseID;
END;
