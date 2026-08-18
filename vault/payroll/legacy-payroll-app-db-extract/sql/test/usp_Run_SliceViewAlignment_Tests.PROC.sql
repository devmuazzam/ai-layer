
/* 65B - Patch slice-view alignment test for clean rest semantics */

CREATE   PROCEDURE test.usp_Run_SliceViewAlignment_Tests
    @Tol decimal(10,4) = 0.01
AS
BEGIN
    SET NOCOUNT ON;

    ;WITH SliceAgg AS
    (
        SELECT
            s.LaborPayrollID,
            SliceHours = SUM(s.Slice_Hours),
            SlicePay_Total = SUM(s.Slice_Pay),
            Min_Day_Type = MIN(s.Day_Type),
            Max_Day_Type = MAX(s.Day_Type),
            Min_Multiplier = MIN(s.Final_Multiplier),
            Max_Multiplier = MAX(s.Final_Multiplier)
        FROM api.v_UI_Pricing_Slices_Advanced s
        GROUP BY
            s.LaborPayrollID
    ),
    Base AS
    (
        SELECT
            sc.ScenarioID,
            sc.ScenarioCode,
            sc.ScenarioGroup,
            sc.ScenarioName,
            sc.LaborPayrollID,

            pc.WorkDate,
            pc.EmpID,
            pc.Employee_Name,
            pc.JobTicketID,

            pc.Act_Total_Hrs,
            pc.Pay_Actual_Gross,
            pc.Pay_Gap_Add,
            pc.Pay_Rest_Add,
            pc.Final_Gross_Pay,

            pc.Rest_IsForced,

            s.SliceHours,
            s.SlicePay_Total,
            s.Min_Day_Type,
            s.Max_Day_Type,
            s.Min_Multiplier,
            s.Max_Multiplier,

            Expected_SlicePay =
                CONVERT(decimal(19,4), ISNULL(pc.Pay_Actual_Gross,0))
        FROM test.Case_CorePayrollScenario sc
        JOIN fms.Payroll_Calculated pc
            ON pc.LaborPayrollID = sc.LaborPayrollID
        LEFT JOIN SliceAgg s
            ON s.LaborPayrollID = sc.LaborPayrollID
        WHERE sc.IsActive = 1
          AND sc.ScenarioCode <> 'HOURS_ONLY_SHIFT_ASSUMED'
    )
    SELECT
        ScenarioID,
        ScenarioCode,
        ScenarioGroup,
        ScenarioName,
        LaborPayrollID,
        WorkDate,
        EmpID,
        Employee_Name,
        JobTicketID,

        Act_Total_Hrs,
        SliceHours,
        Pay_Actual_Gross,
        Pay_Rest_Add,
        Expected_SlicePay,
        SlicePay_Total,

        Min_Day_Type,
        Max_Day_Type,
        Min_Multiplier,
        Max_Multiplier,

        Pass_Hours =
            CONVERT(bit,
                CASE
                    WHEN SliceHours IS NOT NULL
                     AND ABS(SliceHours - Act_Total_Hrs) <= @Tol
                    THEN 1 ELSE 0
                END
            ),

        Pass_Pay =
            CONVERT(bit,
                CASE
                    WHEN SlicePay_Total IS NOT NULL
                     AND ABS(SlicePay_Total - Expected_SlicePay) <= @Tol
                    THEN 1 ELSE 0
                END
            ),

        Pass =
            CONVERT(bit,
                CASE
                    WHEN SliceHours IS NOT NULL
                     AND SlicePay_Total IS NOT NULL
                     AND ABS(SliceHours - Act_Total_Hrs) <= @Tol
                     AND ABS(SlicePay_Total - Expected_SlicePay) <= @Tol
                    THEN 1 ELSE 0
                END
            ),

        Finding =
            CASE
                WHEN SliceHours IS NULL THEN 'FAIL: Missing slice rows.'
                WHEN ABS(SliceHours - Act_Total_Hrs) > @Tol THEN 'FAIL: Slice hours do not match Act_Total_Hrs.'
                WHEN ABS(SlicePay_Total - Expected_SlicePay) > @Tol THEN 'FAIL: Slice pay does not match Pay_Actual_Gross under clean rest semantics.'
                ELSE 'PASS'
            END
    FROM Base
    ORDER BY
        ScenarioGroup,
        ScenarioCode;
END;
