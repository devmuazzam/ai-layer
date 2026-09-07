      @FromDate date
    , @ToDate   date
    , @EmpID    varchar(50) = NULL
)
RETURNS TABLE
AS
RETURN
WITH Base AS
(
    SELECT
        p.*,
        WorkDateDate = CAST(p.WorkDate AS date),
        rn = ROW_NUMBER() OVER
             (PARTITION BY p.LaborPayrollID ORDER BY p.CalculatedAt DESC, p.CalcID DESC)
    FROM fms.Payroll_Calculated p
    WHERE p.WorkDate >= @FromDate
      AND p.WorkDate <  DATEADD(day, 1, @ToDate)
      AND (@EmpID IS NULL OR p.EmpID = @EmpID)
)
SELECT
    b.EmpID,
    Employee_Name = MAX(b.Employee_Name),
    WorkDate      = b.WorkDateDate,

    -- Hours
    Act_Total_Hrs = SUM(ISNULL(b.Act_Total_Hrs,0)),
    Gap_Hrs_Total = SUM(ISNULL(b.Gap_Hrs_Total,0)),
    Gap_Hrs_Boom  = SUM(ISNULL(b.Gap_Hrs_Boom,0)),
    Pay_Total_Hrs = SUM(ISNULL(hb.Payable_Hrs, ISNULL(b.Pay_Total_Hrs,0))),

    Hrs_ST        = SUM(ISNULL(hb.Hrs_ST, ISNULL(b.Hrs_ST,0))),
    Hrs_OT        = SUM(ISNULL(hb.Hrs_OT, ISNULL(b.Hrs_OT,0))),
    Hrs_DT        = SUM(ISNULL(hb.Hrs_DT, ISNULL(b.Hrs_DT,0))),

    -- Original / compatibility dollars
    Pay_Actual_Gross = SUM(ISNULL(b.Pay_Actual_Gross,0)),
    Pay_Gap_Add      = SUM(ISNULL(b.Pay_Gap_Add,0)),
    Pay_Rest_Add     = SUM(ISNULL(b.Pay_Rest_Add,0)),
    Final_Gross_Pay  = SUM(ISNULL(b.Final_Gross_Pay,0)),

    -- Ledger-aware dollars
    LaborGross_BeforeWTL =
        SUM(ISNULL(l.LaborGross_BeforeWTL, ISNULL(b.Final_Gross_Pay,0))),

    WTLAdjustment =
        SUM(ISNULL(l.WTLAdjustment, 0)),

    LaborGross_AfterWTL =
        SUM(ISNULL(l.LaborGross_AfterWTL, ISNULL(b.Final_Gross_Pay,0))),

    SubsistenceAmount =
        SUM(ISNULL(l.SubsistenceAmount, 0)),

    PayableGrossWithSubsistence =
        SUM(ISNULL(
            l.TotalPayableGross,
            ISNULL(b.Final_Gross_Pay,0) + ISNULL(b.Pay_Rest_Add,0)
        )),

    TotalPayableGross =
        SUM(ISNULL(
            l.TotalPayableGross,
            ISNULL(b.Final_Gross_Pay,0) + ISNULL(b.Pay_Rest_Add,0)
        )),

    -- Holiday / Special Saturday context
    HolidayName      = h.HolidayName,
    DayMultiplier    = h.PayRateMultiplier,
    IsWorkRestricted = h.IsWorkRestricted,
    RuleApplied      = h.RuleApplied,

    -- Flags for UI
    MissingJobFlag =
        MAX(CASE
                WHEN b.JobTicketID IS NULL
                AND NULLIF(LTRIM(RTRIM(CONVERT(varchar(100), b.JobCode))), '') IS NULL
                AND NULLIF(LTRIM(RTRIM(CONVERT(varchar(100), bl.WoCode))),  '') IS NULL
                THEN 1
                ELSE 0
            END),

    GapPayMissingFlag =
        MAX(CASE WHEN ISNULL(b.Gap_Hrs_Total,0) > 0 AND ISNULL(b.Pay_Gap_Add,0) = 0 THEN 1 ELSE 0 END),

    RateBaseMissingFlag =
        MAX(CASE WHEN ISNULL(rh.HasZeroRateBase,0) = 1 THEN 1 ELSE 0 END),

    GapPayMissingRows =
        SUM(CASE WHEN ISNULL(b.Gap_Hrs_Total,0) > 0 AND ISNULL(b.Pay_Gap_Add,0) = 0 THEN 1 ELSE 0 END)
FROM Base b
  LEFT JOIN api.v_UI_Payroll_LaborEntry_HourBuckets hb
      ON hb.LaborPayrollID = b.LaborPayrollID
LEFT JOIN api.v_UI_Payroll_LaborEntry_Ledger_Summary l
    ON l.LaborPayrollID = b.LaborPayrollID
LEFT JOIN dim.LU12_Holiday h
    ON h.[Date] = b.WorkDateDate
LEFT JOIN api.v_Pricing_LaborPayroll_RateHealth rh
    ON rh.LaborPayrollID = b.LaborPayrollID
LEFT JOIN app.v_Base_LaborPayroll bl
    ON bl.LaborPayrollID = b.LaborPayrollID
WHERE b.rn = 1
GROUP BY
    b.EmpID,
    b.WorkDateDate,
    h.HolidayName,
    h.PayRateMultiplier,
    h.IsWorkRestricted,
    h.RuleApplied;

