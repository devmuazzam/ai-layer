
CREATE   VIEW calc.v_Calc_Pricing_Detailed_API
AS
SELECT
    S.LaborPayrollID,
    S.JobTicketID,
    S.JobCode,
    S.EmpID,
    S.Employee_Name,
    S.TicketDate,
    S.WorkDate,

    Total_Hours =
        CAST(SUM(CAST(S.Slice_Hours AS decimal(9,2))) AS numeric(38,1)),

    Boom_Hours =
        CAST(SUM(CASE WHEN S.Is_Boom_Active = 1 THEN CAST(S.Slice_Hours AS decimal(9,2)) ELSE 0 END) AS numeric(38,1)),

    Est_Gross_Pay =
        CAST(SUM(CAST(S.Slice_Pay AS decimal(12,4))) AS decimal(12,2)),

    Hrs_ST =
        CAST(SUM(CASE WHEN S.Final_Multiplier = 1.00 THEN CAST(S.Slice_Hours AS decimal(9,2)) ELSE 0 END) AS numeric(38,1)),

    Hrs_OT =
        CAST(SUM(CASE WHEN S.Final_Multiplier = S.Mul_OT THEN CAST(S.Slice_Hours AS decimal(9,2)) ELSE 0 END) AS numeric(38,1)),

    Hrs_DT =
        CAST(SUM(CASE WHEN S.Final_Multiplier >= S.Mul_DT THEN CAST(S.Slice_Hours AS decimal(9,2)) ELSE 0 END) AS numeric(38,1))
FROM calc.v_Calc_Pricing_Slices_API S
GROUP BY
    S.LaborPayrollID,
    S.JobTicketID,
    S.JobCode,
    S.EmpID,
    S.Employee_Name,
    S.TicketDate,
    S.WorkDate;
