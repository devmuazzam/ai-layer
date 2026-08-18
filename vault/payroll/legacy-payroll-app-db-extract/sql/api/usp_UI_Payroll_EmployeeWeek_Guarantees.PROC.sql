

CREATE     PROCEDURE [api].[usp_UI_Payroll_EmployeeWeek_Guarantees]
    @EmpID varchar(50),
    @AnyDateInWeek date
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @PeriodStart date = app.fn_PayPeriodStart_SatFri(@AnyDateInWeek);
    DECLARE @PeriodEnd   date = DATEADD(DAY, 6, @PeriodStart);

    ;WITH Groups AS
    (
        SELECT
            g.GuaranteeGroupID,
            g.RunId,
            g.RuleCode,
            g.RuleName,
            g.ScopeBasis,
            g.GroupScope,
            g.EmpID,
            g.Employee_Name,

            COALESCE(g.GuaranteeDate, g.ShiftAnchorDate, g.CalendarDate) AS GuaranteeDisplayDate,
            g.ShiftAnchorDate,
            g.CalendarDate,
            g.GuaranteeDate,

            g.ActualQualifyingHours,
            g.MinimumHours,
            g.GapHours,
            g.PayComponent,
            g.MultiplierUsed,
            g.TriggeredFlag,
            g.SatisfiedFlag,
            g.WorkDateFrom,
            g.WorkDateTo,
            g.CalculatedAtUTC
        FROM api.v_UI_GuaranteeGroups g
        WHERE g.EmpID = @EmpID
          AND COALESCE(g.GuaranteeDate, g.ShiftAnchorDate, g.CalendarDate) >= @PeriodStart
          AND COALESCE(g.GuaranteeDate, g.ShiftAnchorDate, g.CalendarDate) <= @PeriodEnd
    ),
    AllocAgg AS
    (
        SELECT
            a.GuaranteeGroupID,
            COUNT_BIG(*) AS AllocationCount,
            SUM(a.AllocatedGapHours) AS AllocatedGapHoursTotal,
            SUM(a.AllocatedGapPay) AS AllocatedGapPayTotal
        FROM api.v_UI_GuaranteeAllocations a
        WHERE a.EmpID = @EmpID
          AND COALESCE(a.AllocatedDate, a.GuaranteeDate, CAST(a.WorkDate AS date), a.ShiftAnchorDate, a.CalendarDate) >= @PeriodStart
          AND COALESCE(a.AllocatedDate, a.GuaranteeDate, CAST(a.WorkDate AS date), a.ShiftAnchorDate, a.CalendarDate) <= @PeriodEnd
        GROUP BY a.GuaranteeGroupID
    )
    SELECT
        g.*,
        ISNULL(a.AllocationCount, 0) AS AllocationCount,
        CAST(ISNULL(a.AllocatedGapHoursTotal, 0.00) AS decimal(10,2)) AS AllocatedGapHoursTotal,
        CAST(ISNULL(a.AllocatedGapPayTotal, 0.00) AS decimal(12,2)) AS AllocatedGapPayTotal
    FROM Groups g
    LEFT JOIN AllocAgg a
        ON a.GuaranteeGroupID = g.GuaranteeGroupID
    ORDER BY
        g.GuaranteeDisplayDate,
        g.GuaranteeGroupID;

    SELECT
        a.GuaranteeAllocationID,
        a.GuaranteeGroupID,
        a.RunId,
        a.RuleCode,
        a.RuleName,
        a.ScopeBasis,
        a.GroupScope,
        a.EmpID,
        a.Employee_Name,

        COALESCE(a.AllocatedDate, a.GuaranteeDate, CAST(a.WorkDate AS date), a.ShiftAnchorDate, a.CalendarDate) AS AllocationDisplayDate,
        a.ShiftAnchorDate,
        a.CalendarDate,
        a.GuaranteeDate,

        -- Internal key. Useful for drilldown, but not the primary visible UI label.
        a.LaborPayrollID,

        -- Payroll Manager-facing identifiers.
        a.JobCode AS JobCodeOrWO,
        a.JobTicketID,
        CASE
            WHEN NULLIF(LTRIM(RTRIM(a.JobCode)), '') IS NOT NULL
                 AND a.JobTicketID IS NOT NULL
                THEN CONCAT(a.JobCode, ' / Ticket ', CONVERT(varchar(20), a.JobTicketID))
            WHEN NULLIF(LTRIM(RTRIM(a.JobCode)), '') IS NOT NULL
                THEN a.JobCode
            WHEN a.JobTicketID IS NOT NULL
                THEN CONCAT('Ticket ', CONVERT(varchar(20), a.JobTicketID))
            ELSE '(No job / ticket)'
        END AS AllocationDisplayLabel,

        a.JobCode,
        a.WorkDate,
        a.AllocatedDate,

        a.AllocatedGapHours,
        a.AllocatedGapPay,
        a.AllocationMethod,
        a.RateBaseUsed,
        a.RateShiftUsed,
        a.RateBoomUsed,
        a.MultiplierUsed,
        a.Explanation,
        a.CalculatedAtUTC
    FROM api.v_UI_GuaranteeAllocations a
    WHERE a.EmpID = @EmpID
      AND COALESCE(a.AllocatedDate, a.GuaranteeDate, CAST(a.WorkDate AS date), a.ShiftAnchorDate, a.CalendarDate) >= @PeriodStart
      AND COALESCE(a.AllocatedDate, a.GuaranteeDate, CAST(a.WorkDate AS date), a.ShiftAnchorDate, a.CalendarDate) <= @PeriodEnd
    ORDER BY
        AllocationDisplayDate,
        a.GuaranteeGroupID,
        a.JobCode,
        a.JobTicketID,
        a.LaborPayrollID;
END;
