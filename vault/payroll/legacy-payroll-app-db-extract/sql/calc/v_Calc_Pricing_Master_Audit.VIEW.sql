
CREATE   VIEW calc.v_Calc_Pricing_Master_Audit
AS
SELECT
    pc.LaborPayrollID,
    pc.JobTicketID,
    pc.JobCode,
    pc.EmpID,
    pc.Employee_Name,
    pc.TicketDate,
    pc.WorkDate,
    pc.Act_Total_Hrs,
    pc.Gap_Hrs_Total,
    pc.Pay_Total_Hrs,
    pc.Act_Boom_Hrs,
    pc.Gap_Hrs_Boom,
    pc.Hrs_ST,
    pc.Hrs_OT,
    pc.Hrs_DT,
    pc.Pay_Actual_Gross,
    pc.Pay_Gap_Add,
    pc.Final_Gross_Pay,
    pc.Audit_Min_Rule,

    -- Keep existing column meaning but expose with clearer name too
    GapMult_Config = pc.Audit_Gap_Mult,
    pc.Audit_Gap_Mult,

    -- Calendar/day-type multiplier: Holiday table, else Sunday=2.00, else 1.00
    DayMult_Calendar =
        COALESCE(h.PayRateMultiplier,
                 CASE WHEN (DATEDIFF(DAY,'19000107', CAST(pc.WorkDate AS date)) % 7) = 0 THEN CAST(2.00 AS decimal(6,2))
                      ELSE CAST(1.00 AS decimal(6,2))
                 END),

    h.HolidayName,

    -- Estimate "rate used" for actual gross under the day multiplier
    RateUsed_Est =
        CASE
            WHEN ISNULL(pc.Act_Total_Hrs,0) > 0
             AND COALESCE(h.PayRateMultiplier,
                 CASE WHEN (DATEDIFF(DAY,'19000107', CAST(pc.WorkDate AS date)) % 7) = 0 THEN 2.00 ELSE 1.00 END
             ) > 0
                THEN CAST(
                    pc.Pay_Actual_Gross /
                    ( pc.Act_Total_Hrs *
                      COALESCE(h.PayRateMultiplier,
                        CASE WHEN (DATEDIFF(DAY,'19000107', CAST(pc.WorkDate AS date)) % 7) = 0 THEN 2.00 ELSE 1.00 END
                      )
                    )
                AS decimal(10,4))
            ELSE NULL
        END,

    -- Effective gap multiplier inferred from pay components
    GapMult_Effective =
        CASE
            WHEN ISNULL(pc.Gap_Hrs_Total,0) > 0
             AND ISNULL(pc.Act_Total_Hrs,0) > 0
             AND ISNULL(pc.Pay_Actual_Gross,0) > 0
             AND COALESCE(h.PayRateMultiplier,
                 CASE WHEN (DATEDIFF(DAY,'19000107', CAST(pc.WorkDate AS date)) % 7) = 0 THEN 2.00 ELSE 1.00 END
             ) > 0
                THEN CAST(
                    pc.Pay_Gap_Add /
                    ( pc.Gap_Hrs_Total *
                      ( pc.Pay_Actual_Gross /
                        ( pc.Act_Total_Hrs *
                          COALESCE(h.PayRateMultiplier,
                            CASE WHEN (DATEDIFF(DAY,'19000107', CAST(pc.WorkDate AS date)) % 7) = 0 THEN 2.00 ELSE 1.00 END
                          )
                        )
                      )
                    )
                AS decimal(10,4))
            ELSE NULL
        END
FROM fms.Payroll_Calculated pc
LEFT JOIN dim.LU12_Holiday h
  ON h.[Date] = CAST(pc.WorkDate AS date);
