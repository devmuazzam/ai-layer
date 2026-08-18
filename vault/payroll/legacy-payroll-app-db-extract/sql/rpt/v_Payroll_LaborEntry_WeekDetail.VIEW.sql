
/*==============================================================
Create internal wide detail view
- 1 row per LaborPayrollID
- starts from app.v_Base_LaborPayroll so all labor entries remain
- joins calculated/audit/ticket/latest-issues
==============================================================*/
CREATE   VIEW rpt.v_Payroll_LaborEntry_WeekDetail
AS
WITH ex_raw AS
(
    SELECT DISTINCT
        e.LaborPayrollID,
        e.RunId,
        e.CalcRunAt,
        e.Severity,
        e.Reason,
        e.TicketExpectation,
        e.TicketExpectation_Notes
    FROM api.v_Payroll_Exceptions_LatestPricingRun e
),
ex AS
(
    SELECT
        LaborPayrollID,
        LatestPricingRunId   = MAX(RunId),
        LatestPricingRunAt   = MAX(CalcRunAt),
        ErrorCount           = SUM(CASE WHEN Severity = 'Error'   THEN 1 ELSE 0 END),
        WarningCount         = SUM(CASE WHEN Severity = 'Warning' THEN 1 ELSE 0 END),
        TotalIssueCount      = COUNT(*),
        ErrorReasons         = STRING_AGG(CASE WHEN Severity = 'Error'   THEN Reason END, ' | '),
        WarningReasons       = STRING_AGG(CASE WHEN Severity = 'Warning' THEN Reason END, ' | '),
        AllIssueReasons      = STRING_AGG(CONCAT(Severity, ': ', Reason), ' | '),
        TicketExpectation    = MAX(TicketExpectation),
        TicketExpectation_Notes = MAX(TicketExpectation_Notes)
    FROM ex_raw
    GROUP BY LaborPayrollID
)
SELECT
    /* --- week fields --- */
    wd.WorkDate_Date,
    wk.PayWeekStart,
    PayWeekEnd = CASE WHEN wk.PayWeekStart IS NULL THEN NULL ELSE DATEADD(DAY, 6, wk.PayWeekStart) END,

    /* --- row identity / calc presence --- */
    bl.LaborPayrollID,
    pc.CalcID,
    Has_Calculated_Row = CONVERT(bit, CASE WHEN pc.LaborPayrollID IS NOT NULL THEN 1 ELSE 0 END),
    Calculation_Status = CASE WHEN pc.LaborPayrollID IS NOT NULL THEN 'Calculated' ELSE 'NotCalculated' END,
    pc.CalculatedAt,

    /* --- labor entry identity --- */
    bl.JobTicketID,
    Has_JobTicket = CONVERT(bit, CASE WHEN bl.JobTicketID IS NOT NULL THEN 1 ELSE 0 END),
    bl.JobCode,
    bl.WoCode,
    bl.JobLineItemID,
    bl.WoDetailID,
    bl.JobEmpID,

    /* --- employee / classification --- */
    bl.EmpID,
    bl.Employee_Name,
    bl.UnionCode,
    bl.CraftCode,
    bl.CraftDescription,
    bl.CraftPayRate,
    bl.CraftModifierCode,
    bl.CraftModifierDescription,
    bl.CraftModifierPayRateAdjustment,
    bl.UnionApprenticePercent,
    bl.ClassCode,
    bl.ClassDescription,
    bl.LaborType,
    bl.UseCertifiedPayroll,

    /* --- unit / activity --- */
    bl.UnitCode,
    bl.UnitName,
    bl.UnitDescription,
    bl.UnitScheduleType,
    bl.ActivityCode,
    bl.ActivityDescription,

    /* --- source labor row --- */
    bl.WorkDate            AS WorkDate_Labor,
    bl.TimeStart_Labor,
    bl.TimeEnd_Labor,
    bl.ProcessedDate,
    bl.HoursWorked_Raw,
    bl.Source_Rate_Raw,
    bl.Source_Amount_Raw,
    bl.Perdiem,
    bl.Shift_Code_Raw,

    /* --- labor row flags/statuses --- */
    bl.Processed,
    bl.Is_Processed,
    bl.Approval,
    bl.Approval_Status,
    bl.ApprovalBy,
    bl.ApprovalDate,
    bl.Billable,
    bl.Is_Billable,
    bl.WorkThruLunch,
    bl.WorkedThruLunch,
    bl.AtomLabor,
    bl.Is_AtomLabor,
    bl.Is_AtomLabor_Label,
    bl.StdJobTicketHours,
    bl.Is_StandardHours,
    bl.NotifyQtyChg,
    bl.Status_QtyChange,
    bl.NotifyRateChg,
    bl.Status_RateChange,
    bl.NotifyCommentsChg,
    bl.Status_CommentsChange,
    bl.NotifyCraftChg,
    bl.Status_CraftChange,
    bl.NotifyCraftModifierChg,
    bl.Status_CraftModChange,
    bl.NotifyShiftInfoChg,
    bl.Status_ShiftInfoChange,
    bl.NotifyNewRow,
    bl.Status_NewRow,
    bl.WorkerCompCode,
    bl.BurdenCode,

    /* --- ticket raw times --- */
    jt.TkTm01,
    jt.TkTm02,
    jt.TkTm03,
    jt.TkTm04,
    jt.TkTm05,
    jt.TkTm06,
    jt.TkTm07,
    jt.TkTm08,
    jt.TkTm09,
    jt.TkTm10,

    /* --- ticket reference times used for comparison --- */
    Ticket_ShiftStart_Ref = COALESCE(jt.TkTm01, jt.TkTm02),
    Ticket_ShiftEnd_Ref   = COALESCE(jt.TkTm10, jt.TkTm09),
    Ticket_BoomStart_Ref  = COALESCE(jt.TkTm04, jt.TkTm03),
    Ticket_BoomEnd_Ref    = COALESCE(jt.TkTm07, jt.TkTm08),

    Ticket_ShiftStart_Source =
        CASE
            WHEN jt.TkTm01 IS NOT NULL THEN 'TkTm01'
            WHEN jt.TkTm02 IS NOT NULL THEN 'TkTm02'
            ELSE NULL
        END,
    Ticket_ShiftEnd_Source =
        CASE
            WHEN jt.TkTm10 IS NOT NULL THEN 'TkTm10'
            WHEN jt.TkTm09 IS NOT NULL THEN 'TkTm09'
            ELSE NULL
        END,
    Ticket_BoomStart_Source =
        CASE
            WHEN jt.TkTm04 IS NOT NULL THEN 'TkTm04'
            WHEN jt.TkTm03 IS NOT NULL THEN 'TkTm03'
            ELSE NULL
        END,
    Ticket_BoomEnd_Source =
        CASE
            WHEN jt.TkTm07 IS NOT NULL THEN 'TkTm07'
            WHEN jt.TkTm08 IS NOT NULL THEN 'TkTm08'
            ELSE NULL
        END,

    /* --- helpful comparison metrics --- */
    Labor_Hrs_From_TimeBounds =
        CASE
            WHEN bl.TimeStart_Labor IS NOT NULL AND bl.TimeEnd_Labor IS NOT NULL
            THEN CONVERT(decimal(10,2), DATEDIFF(MINUTE, bl.TimeStart_Labor, bl.TimeEnd_Labor) / 60.0)
            ELSE NULL
        END,

    Ticket_Shift_Hrs_From_Refs =
        CASE
            WHEN COALESCE(jt.TkTm01, jt.TkTm02) IS NOT NULL
             AND COALESCE(jt.TkTm10, jt.TkTm09) IS NOT NULL
            THEN CONVERT(decimal(10,2), DATEDIFF(MINUTE, COALESCE(jt.TkTm01, jt.TkTm02), COALESCE(jt.TkTm10, jt.TkTm09)) / 60.0)
            ELSE NULL
        END,

    Ticket_Boom_Hrs_From_Refs =
        CASE
            WHEN COALESCE(jt.TkTm04, jt.TkTm03) IS NOT NULL
             AND COALESCE(jt.TkTm07, jt.TkTm08) IS NOT NULL
            THEN CONVERT(decimal(10,2), DATEDIFF(MINUTE, COALESCE(jt.TkTm04, jt.TkTm03), COALESCE(jt.TkTm07, jt.TkTm08)) / 60.0)
            ELSE NULL
        END,

    Diff_Minutes_LaborStart_vs_TicketStartRef =
        CASE
            WHEN bl.TimeStart_Labor IS NOT NULL AND COALESCE(jt.TkTm01, jt.TkTm02) IS NOT NULL
            THEN DATEDIFF(MINUTE, COALESCE(jt.TkTm01, jt.TkTm02), bl.TimeStart_Labor)
            ELSE NULL
        END,

    Diff_Minutes_LaborEnd_vs_TicketEndRef =
        CASE
            WHEN bl.TimeEnd_Labor IS NOT NULL AND COALESCE(jt.TkTm10, jt.TkTm09) IS NOT NULL
            THEN DATEDIFF(MINUTE, COALESCE(jt.TkTm10, jt.TkTm09), bl.TimeEnd_Labor)
            ELSE NULL
        END,

    /* --- calculated outputs --- */
    pc.TicketDate         AS TicketDate_Calc,
    pc.WorkDate           AS WorkDate_Calc,
    pc.Act_Total_Hrs,
    pc.Act_Boom_Hrs,
    pc.Gap_Hrs_Total,
    pc.Gap_Hrs_Boom,
    pc.Pay_Total_Hrs,
    pc.Hrs_ST,
    pc.Hrs_OT,
    pc.Hrs_DT,
    pc.Pay_Actual_Gross,
    pc.Pay_Gap_Add,
    pc.Final_Gross_Pay,
    pc.Audit_Min_Rule,
    pc.Audit_Gap_Mult,
    pc.Pay_Rest_Add,
    pc.Rest_IsForced,
    pc.Rest_ChainId,
    pc.Rest_Gap_Hrs_FromPrevChain,
    pc.Rest_IsOverlap,
    pc.Rest_Premium_Hrs,
    pc.Rest_Policy,

    /* --- audit / explain columns --- */
    aud.GapMult_Config,
    aud.DayMult_Calendar,
    aud.HolidayName,
    aud.RateUsed_Est,
    aud.GapMult_Effective,

    /* --- source vs calculated deltas --- */
    Diff_Hours_ActTotal_vs_HoursWorkedRaw =
        CASE
            WHEN pc.Act_Total_Hrs IS NOT NULL AND bl.HoursWorked_Raw IS NOT NULL
            THEN CONVERT(decimal(10,2), pc.Act_Total_Hrs - CONVERT(decimal(10,2), bl.HoursWorked_Raw))
            ELSE NULL
        END,

    Diff_Rate_RateUsedEst_vs_SourceRate =
        CASE
            WHEN aud.RateUsed_Est IS NOT NULL AND bl.Source_Rate_Raw IS NOT NULL
            THEN CONVERT(decimal(12,4), aud.RateUsed_Est - CONVERT(decimal(12,4), bl.Source_Rate_Raw))
            ELSE NULL
        END,

    Diff_Gross_Final_vs_SourceAmount =
        CASE
            WHEN pc.Final_Gross_Pay IS NOT NULL AND bl.Source_Amount_Raw IS NOT NULL
            THEN CONVERT(decimal(14,2), pc.Final_Gross_Pay - CONVERT(decimal(14,2), bl.Source_Amount_Raw))
            ELSE NULL
        END,

    /* --- latest pricing-run issues aggregated to 1 row --- */
    ex.LatestPricingRunId,
    ex.LatestPricingRunAt,
    HasError    = CONVERT(bit, CASE WHEN ISNULL(ex.ErrorCount,   0) > 0 THEN 1 ELSE 0 END),
    HasWarning  = CONVERT(bit, CASE WHEN ISNULL(ex.WarningCount, 0) > 0 THEN 1 ELSE 0 END),
    HasIssue    = CONVERT(bit, CASE WHEN ISNULL(ex.TotalIssueCount, 0) > 0 THEN 1 ELSE 0 END),
    ErrorCount   = ISNULL(ex.ErrorCount, 0),
    WarningCount = ISNULL(ex.WarningCount, 0),
    TotalIssueCount = ISNULL(ex.TotalIssueCount, 0),
    ex.ErrorReasons,
    ex.WarningReasons,
    ex.AllIssueReasons,
    ex.TicketExpectation,
    ex.TicketExpectation_Notes

FROM app.v_Base_LaborPayroll bl
LEFT JOIN fms.Payroll_Calculated pc
    ON pc.LaborPayrollID = bl.LaborPayrollID
LEFT JOIN calc.v_Calc_Pricing_Master_Audit aud
    ON aud.LaborPayrollID = bl.LaborPayrollID
LEFT JOIN calc.v_JobTicket_Times jt
    ON jt.JobTicketID = bl.JobTicketID
LEFT JOIN ex
    ON ex.LaborPayrollID = bl.LaborPayrollID
OUTER APPLY
(
    SELECT WorkDate_Date = CAST(COALESCE(bl.WorkDate, pc.WorkDate, aud.WorkDate) AS date)
) wd
OUTER APPLY
(
    SELECT PayWeekStart =
        CASE
            WHEN wd.WorkDate_Date IS NULL THEN NULL
            ELSE DATEADD(DAY, -DATEDIFF(DAY, CONVERT(date, '19000106'), wd.WorkDate_Date) % 7, wd.WorkDate_Date)
        END
) wk;
