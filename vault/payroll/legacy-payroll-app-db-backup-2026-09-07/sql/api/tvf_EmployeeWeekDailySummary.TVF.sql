      @EmpID          varchar(15)
    , @AnyDateInWeek  date
)
RETURNS TABLE
AS
RETURN
WITH wk AS
(
    SELECT
        PayWeekStart =
            DATEADD
            (
                DAY,
                -DATEDIFF(DAY, CONVERT(date,'19000106'), @AnyDateInWeek) % 7,
                @AnyDateInWeek
            )
),
week_days AS
(
    SELECT
        PayWeekStart   = wk.PayWeekStart,
        PayWeekEnd     = DATEADD(DAY, 6, wk.PayWeekStart),
        WorkDate       = DATEADD(DAY, v.DayOffset, wk.PayWeekStart),
        DayOfWeekIndex = v.DayOffset + 1,
        DayName        = v.DayName
    FROM wk
    CROSS JOIN
    (
        VALUES
            (0, 'Sat'),
            (1, 'Sun'),
            (2, 'Mon'),
            (3, 'Tue'),
            (4, 'Wed'),
            (5, 'Thu'),
            (6, 'Fri')
    ) v (DayOffset, DayName)
),
src AS
(
    SELECT
        WorkDate = CAST(d.WorkDate_Date AS date),
        d.LaborPayrollID,
        d.EmpID,
        d.Employee_Name,
        d.Act_Total_Hrs,
        d.Gap_Hrs_Total,
        d.Gap_Hrs_Boom,
        Pay_Total_Hrs = d.Bucket_Payable_Hrs,
          Hrs_ST = d.Bucket_Hrs_ST,
          Hrs_OT = d.Bucket_Hrs_OT,
          Hrs_DT = d.Bucket_Hrs_DT,
        d.Final_Gross_Pay,
        d.ErrorCount,
        d.WarningCount,
        d.TotalIssueCount,

        LaborGross_BeforeWTL =
            ISNULL(l.LaborGross_BeforeWTL, d.Final_Gross_Pay),

        WTLAdjustment =
            ISNULL(l.WTLAdjustment, 0),

        LaborGross_AfterWTL =
            ISNULL(l.LaborGross_AfterWTL, d.Final_Gross_Pay),

        SubsistenceAmount =
            ISNULL(l.SubsistenceAmount, 0),

        TotalPayableGross =
            ISNULL(l.TotalPayableGross, d.Final_Gross_Pay)
    FROM api.v_UI_Payroll_LaborEntry_WeekDetail_WithBuckets d
    LEFT JOIN api.v_UI_Payroll_LaborEntry_Ledger_Summary l
        ON l.LaborPayrollID = d.LaborPayrollID
    CROSS JOIN wk
    WHERE d.EmpID = @EmpID
      AND CAST(d.WorkDate_Date AS date) >= wk.PayWeekStart
      AND CAST(d.WorkDate_Date AS date) <= DATEADD(DAY, 6, wk.PayWeekStart)
),
daily AS
(
    SELECT
        WorkDate,
        EmpID = MAX(EmpID),
        Employee_Name = MAX(Employee_Name),
        EntryCount = COUNT_BIG(*),

        Act_Total_Hrs = SUM(CONVERT(decimal(19,4), ISNULL(Act_Total_Hrs, 0))),
        Gap_Hrs_Total = SUM(CONVERT(decimal(19,4), ISNULL(Gap_Hrs_Total, 0))),
        Gap_Hrs_Boom  = SUM(CONVERT(decimal(19,4), ISNULL(Gap_Hrs_Boom, 0))),
        Pay_Total_Hrs = SUM(CONVERT(decimal(19,4), ISNULL(Pay_Total_Hrs, 0))),
        Hrs_ST        = SUM(CONVERT(decimal(19,4), ISNULL(Hrs_ST, 0))),
        Hrs_OT        = SUM(CONVERT(decimal(19,4), ISNULL(Hrs_OT, 0))),
        Hrs_DT        = SUM(CONVERT(decimal(19,4), ISNULL(Hrs_DT, 0))),

        Final_Gross_Pay =
            SUM(CONVERT(decimal(19,4), ISNULL(Final_Gross_Pay, 0))),

        LaborGross_BeforeWTL =
            SUM(CONVERT(decimal(19,4), ISNULL(LaborGross_BeforeWTL, 0))),

        WTLAdjustment =
            SUM(CONVERT(decimal(19,4), ISNULL(WTLAdjustment, 0))),

        LaborGross_AfterWTL =
            SUM(CONVERT(decimal(19,4), ISNULL(LaborGross_AfterWTL, 0))),

        SubsistenceAmount =
            SUM(CONVERT(decimal(19,4), ISNULL(SubsistenceAmount, 0))),

        TotalPayableGross =
            SUM(CONVERT(decimal(19,4), ISNULL(TotalPayableGross, 0))),

        ErrorCount = SUM(ISNULL(ErrorCount, 0)),
        WarningCount = SUM(ISNULL(WarningCount, 0)),
        TotalIssueCount = SUM(ISNULL(TotalIssueCount, 0))
    FROM src
    GROUP BY
        WorkDate
)
SELECT
    wd.PayWeekStart,
    wd.PayWeekEnd,
    wd.WorkDate,
    wd.DayName,
    wd.DayOfWeekIndex,

    EmpID =
        ISNULL(d.EmpID, @EmpID),

    Employee_Name =
        d.Employee_Name,

    HasActivity =
        CAST(CASE WHEN ISNULL(d.EntryCount, 0) > 0 THEN 1 ELSE 0 END AS bit),

    EntryCount =
        CONVERT(int, ISNULL(d.EntryCount, 0)),

    Act_Total_Hrs =
        CONVERT(decimal(10,2), ISNULL(d.Act_Total_Hrs, 0)),

    Gap_Hrs_Total =
        CONVERT(decimal(10,2), ISNULL(d.Gap_Hrs_Total, 0)),

    Gap_Hrs_Boom =
        CONVERT(decimal(10,2), ISNULL(d.Gap_Hrs_Boom, 0)),

    Pay_Total_Hrs =
        CONVERT(decimal(10,2), ISNULL(d.Pay_Total_Hrs, 0)),

    Hrs_ST =
        CONVERT(decimal(10,2), ISNULL(d.Hrs_ST, 0)),

    Hrs_OT =
        CONVERT(decimal(10,2), ISNULL(d.Hrs_OT, 0)),

    Hrs_DT =
        CONVERT(decimal(10,2), ISNULL(d.Hrs_DT, 0)),

    Final_Gross_Pay =
        CONVERT(decimal(19,4), ISNULL(d.Final_Gross_Pay, 0)),

    LaborGross_BeforeWTL =
        CONVERT(decimal(19,4), ISNULL(d.LaborGross_BeforeWTL, 0)),

    WTLAdjustment =
        CONVERT(decimal(19,4), ISNULL(d.WTLAdjustment, 0)),

    LaborGross_AfterWTL =
        CONVERT(decimal(19,4), ISNULL(d.LaborGross_AfterWTL, 0)),

    SubsistenceAmount =
        CONVERT(decimal(19,4), ISNULL(d.SubsistenceAmount, 0)),

    PayableGrossWithSubsistence =
        CONVERT(decimal(19,4), ISNULL(d.TotalPayableGross, 0)),

    TotalPayableGross =
        CONVERT(decimal(19,4), ISNULL(d.TotalPayableGross, 0)),

    ErrorCount =
        CONVERT(int, ISNULL(d.ErrorCount, 0)),

    WarningCount =
        CONVERT(int, ISNULL(d.WarningCount, 0)),

    TotalIssueCount =
        CONVERT(int, ISNULL(d.TotalIssueCount, 0)),

    HasIssue =
        CAST(CASE WHEN ISNULL(d.TotalIssueCount, 0) > 0 THEN 1 ELSE 0 END AS bit),

    Status =
        CAST
        (
            CASE
                WHEN ISNULL(d.EntryCount, 0) = 0 THEN 'no-activity'
                WHEN ISNULL(d.ErrorCount, 0) > 0 THEN 'error'
                WHEN ISNULL(d.WarningCount, 0) > 0 THEN 'warning'
                ELSE 'clean'
            END
        AS varchar(20))
FROM week_days wd
LEFT JOIN daily d
    ON d.WorkDate = wd.WorkDate;

