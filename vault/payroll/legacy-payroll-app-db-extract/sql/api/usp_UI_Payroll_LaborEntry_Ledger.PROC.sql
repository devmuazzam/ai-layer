
CREATE   PROCEDURE api.usp_UI_Payroll_LaborEntry_Ledger
    @LaborPayrollID int
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @LatestWTLCalcRunAt datetime;

    SELECT
        @LatestWTLCalcRunAt = MAX(e.CalcRunAt)
    FROM fms.Payroll_CalcException e
    WHERE e.Reason LIKE 'WTL%';

    /* ============================================================
       Result set 1: one-row ledger summary for selected labor entry
       Uses corrected ledger-aware summary view.
       ============================================================ */

    SELECT
        s.LaborPayrollID,
        s.EmpID,
        s.Employee_Name,
        s.WorkDate,
        s.JobCode,
        s.JobTicketID,

        s.Act_Total_Hrs,
        s.Hrs_ST,
        s.Hrs_OT,
        s.Hrs_DT,
        s.Pay_Actual_Gross,
        s.Pay_Gap_Add,
        s.Pay_Rest_Add,

        s.PayrollCalculated_FinalGross,

        s.ComponentRowCount,

        s.LedgerTotalAmount,
        s.ExpectedLedgerTotalAmount,
        s.LedgerTieOutDifference,
        s.LedgerTieOutStatus,

        s.LaborGross_BeforeWTL,
        s.WTLAdjustment,
        s.LaborGross_AfterWTL,
        s.SubsistenceAllowance,
        s.PayableOnlyAmount,
        s.TotalPayableGross,
        s.LaborGrossTieOutDifference,

        s.ActualPayAmount,
        s.GuaranteeAmount,
        s.RestPeriodAmount,
        s.ShiftDifferentialAmount,

        s.WTLAmount,
        s.WTLMealDeductAmount,
        s.WTLAddAmount,

        s.SubsistenceAmount,
        s.RoundingAmount,
        s.OtherAmount,

        s.EntryExpectedMealCount,
        s.MealBucket,
        s.WTL_TokenState,
        s.WTL_TokenCount,
        s.WTL_Token_MissedMeals,
        s.Has_ConflictingWTLTokens,
        s.HasWTLIssue,
        s.WTL_ErrorCount,
        s.WTL_WarningCount,
        s.WTL_ReviewCount,
        s.WTL_IssueReasons
    FROM api.v_UI_Payroll_LaborEntry_Ledger_Summary s
    WHERE s.LaborPayrollID = @LaborPayrollID;


    /* ============================================================
       Result set 2: detailed ledger rows for selected labor entry
       ============================================================ */

    ;WITH WTLExceptionAgg AS
    (
        SELECT
            LaborPayrollID,

            WTL_ErrorCount =
                SUM(CASE WHEN Reason LIKE 'WTL error:%' THEN 1 ELSE 0 END),

            WTL_WarningCount =
                SUM(CASE WHEN Reason LIKE 'WTL warning:%' THEN 1 ELSE 0 END),

            WTL_ReviewCount =
                SUM(CASE WHEN Reason LIKE 'WTL review:%' THEN 1 ELSE 0 END),

            WTL_IssueReasons =
                STRING_AGG(
                    CONCAT(
                        CASE
                            WHEN Reason LIKE 'WTL error:%' THEN 'Error'
                            WHEN Reason LIKE 'WTL warning:%' THEN 'Warning'
                            WHEN Reason LIKE 'WTL review:%' THEN 'Review'
                            ELSE 'Unclassified'
                        END,
                        ': ',
                        Reason
                    ),
                    ' | '
                )
        FROM fms.Payroll_CalcException
        WHERE LaborPayrollID = @LaborPayrollID
          AND Reason LIKE 'WTL%'
          AND CalcRunAt = @LatestWTLCalcRunAt
        GROUP BY
            LaborPayrollID
    ),
    DetailRows AS
    (
        SELECT
            ppc.LaborPayrollID,

            ComponentGroup =
                CASE
                    WHEN ppc.ComponentCode LIKE 'WTL%' THEN 'WTL / Meal Period'
                    WHEN ppc.ComponentCode LIKE '%REST%' THEN 'Rest Period'
                    WHEN ppc.ComponentCode LIKE '%GUARANTEE%'
                      OR ppc.ComponentCode LIKE '%GAP%' THEN 'Minimum / Guarantee'
                    WHEN ppc.ComponentCode LIKE '%SHIFT%' THEN 'Shift Differential'
                    WHEN ppc.ComponentCode LIKE '%SUBSISTENCE%' THEN 'Subsistence'
                    WHEN ppc.ComponentCode LIKE '%ROUNDING%' THEN 'Rounding'
                    WHEN ppc.ComponentCode LIKE '%BASE%'
                      OR ppc.ComponentCode LIKE '%ACTUAL%' THEN 'Actual Pay'
                    ELSE 'Other'
                END,

            ComponentDisplaySort =
                CASE
                    WHEN ppc.ComponentCode LIKE '%BASE%'
                      OR ppc.ComponentCode LIKE '%ACTUAL%' THEN 10
                    WHEN ppc.ComponentCode LIKE '%GUARANTEE%'
                      OR ppc.ComponentCode LIKE '%GAP%' THEN 20
                    WHEN ppc.ComponentCode LIKE '%REST%' THEN 30
                    WHEN ppc.ComponentCode LIKE '%SHIFT%' THEN 40
                    WHEN ppc.ComponentCode LIKE 'WTL%' THEN 50
                    WHEN ppc.ComponentCode LIKE '%SUBSISTENCE%' THEN 60
                    WHEN ppc.ComponentCode LIKE '%ROUNDING%' THEN 90
                    ELSE 80
                END,

            ComponentDisplayLabel =
                CASE ppc.ComponentCode
                    WHEN 'ACTUAL_BASE_WORKED_PAY' THEN 'Actual base worked pay'
                    WHEN 'ACTUAL_BOOM_WORKED_PAY' THEN 'Actual boom premium pay'
                    WHEN 'WTL_MEAL_DEDUCT' THEN 'Meal period deduction'
                    WHEN 'WTL_APPLICABLE_ADD' THEN 'Missed meal add'
                    WHEN 'WTL_DT_FLOOR' THEN 'Missed meal DT floor add'
                    WHEN 'PAY_COMPONENT_ROUNDING_ADJUSTMENT' THEN 'Rounding adjustment'
                    ELSE REPLACE(REPLACE(ppc.ComponentCode, '_', ' '), 'PAY ', 'Pay ')
                END,

            ppc.ComponentCode,
            ppc.ComponentHours,
            ppc.ComponentAmount,

            ComponentEffect =
                CASE
                    WHEN ppc.ComponentAmount > 0 THEN 'Add'
                    WHEN ppc.ComponentAmount < 0 THEN 'Deduct'
                    ELSE 'Neutral'
                END,

            IsWTLComponent =
                CASE WHEN ppc.ComponentCode LIKE 'WTL%' THEN 1 ELSE 0 END,

            WTL_TokenState =
                CASE
                    WHEN ISNULL(t.Has_ConflictingWTLTokens, 0) = 1 THEN 'Conflicting tokens'
                    WHEN ISNULL(t.WTL_TokenCount, 0) = 0 THEN 'Missing token'
                    WHEN t.Has_WTL_0 = 1 THEN 'WTL_0'
                    WHEN t.Has_WTL_1 = 1 THEN 'WTL_1'
                    WHEN t.Has_WTL_2 = 1 THEN 'WTL_2'
                    WHEN t.Has_WTL_3 = 1 THEN 'WTL_3'
                    WHEN t.Has_WTL_4 = 1 THEN 'WTL_4'
                    ELSE 'Other token state'
                END,

            WTL_TokenCount = ISNULL(t.WTL_TokenCount, 0),
            WTL_Token_MissedMeals = t.WTL_Token_MissedMeals,
            Has_ConflictingWTLTokens = ISNULL(t.Has_ConflictingWTLTokens, 0),

            HasWTLIssue =
                CASE WHEN wx.LaborPayrollID IS NULL THEN 0 ELSE 1 END,

            WTL_ErrorCount = ISNULL(wx.WTL_ErrorCount, 0),
            WTL_WarningCount = ISNULL(wx.WTL_WarningCount, 0),
            WTL_ReviewCount = ISNULL(wx.WTL_ReviewCount, 0),
            WTL_IssueReasons = wx.WTL_IssueReasons
        FROM fms.Payroll_PayComponent ppc
        LEFT JOIN app.v_LaborPayroll_CommentTokens t
            ON t.LaborPayrollID = ppc.LaborPayrollID
        LEFT JOIN WTLExceptionAgg wx
            ON wx.LaborPayrollID = ppc.LaborPayrollID
        WHERE ppc.LaborPayrollID = @LaborPayrollID
    )
    SELECT
        ComponentLineNo =
            ROW_NUMBER() OVER
            (
                ORDER BY
                    ComponentDisplaySort,
                    ComponentCode,
                    ComponentAmount DESC,
                    ComponentHours DESC
            ),
        LaborPayrollID,
        ComponentDisplaySort,
        ComponentGroup,
        ComponentDisplayLabel,
        ComponentCode,
        ComponentHours,
        ComponentAmount,
        ComponentEffect,
        IsWTLComponent,
        WTL_TokenState,
        WTL_TokenCount,
        WTL_Token_MissedMeals,
        Has_ConflictingWTLTokens,
        HasWTLIssue,
        WTL_ErrorCount,
        WTL_WarningCount,
        WTL_ReviewCount,
        WTL_IssueReasons
    FROM DetailRows
    ORDER BY
        ComponentDisplaySort,
        ComponentCode,
        ComponentAmount DESC,
        ComponentHours DESC;
END;
