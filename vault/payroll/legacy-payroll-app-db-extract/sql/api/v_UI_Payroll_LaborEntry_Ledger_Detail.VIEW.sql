
CREATE   VIEW api.v_UI_Payroll_LaborEntry_Ledger_Detail
AS
WITH DetailRows AS
(
    SELECT
        pc.LaborPayrollID,
        pc.EmpID,
        pc.Employee_Name,
        pc.WorkDate,
        pc.JobCode,
        pc.JobTicketID,

        ComponentGroup =
            CASE
                WHEN pc.ComponentCode LIKE 'WTL%' THEN 'WTL / Meal Period'
                WHEN pc.ComponentCode LIKE '%REST%' THEN 'Rest Period'
                WHEN pc.ComponentCode LIKE '%GUARANTEE%'
                  OR pc.ComponentCode LIKE '%GAP%' THEN 'Minimum / Guarantee'
                WHEN pc.ComponentCode LIKE '%SHIFT%' THEN 'Shift Differential'
                WHEN pc.ComponentCode LIKE '%SUBSISTENCE%' THEN 'Subsistence'
                WHEN pc.ComponentCode LIKE '%ROUNDING%' THEN 'Rounding'
                WHEN pc.ComponentCode LIKE '%BASE%'
                  OR pc.ComponentCode LIKE '%ACTUAL%' THEN 'Actual Pay'
                ELSE 'Other'
            END,

        ComponentDisplaySort =
            CASE
                WHEN pc.ComponentCode LIKE '%BASE%'
                  OR pc.ComponentCode LIKE '%ACTUAL%' THEN 10
                WHEN pc.ComponentCode LIKE '%GUARANTEE%'
                  OR pc.ComponentCode LIKE '%GAP%' THEN 20
                WHEN pc.ComponentCode LIKE '%REST%' THEN 30
                WHEN pc.ComponentCode LIKE '%SHIFT%' THEN 40
                WHEN pc.ComponentCode LIKE 'WTL%' THEN 50
                WHEN pc.ComponentCode LIKE '%SUBSISTENCE%' THEN 60
                WHEN pc.ComponentCode LIKE '%ROUNDING%' THEN 90
                ELSE 80
            END,

        ComponentDisplayLabel =
            CASE pc.ComponentCode
                WHEN 'ACTUAL_BASE_WORKED_PAY' THEN 'Actual base worked pay'
                WHEN 'ACTUAL_BOOM_WORKED_PAY' THEN 'Actual boom premium pay'
                WHEN 'WTL_MEAL_DEDUCT' THEN 'Meal period deduction'
                WHEN 'WTL_APPLICABLE_ADD' THEN 'Missed meal add'
                WHEN 'WTL_DT_FLOOR' THEN 'Missed meal DT floor add'
                WHEN 'PAY_COMPONENT_ROUNDING_ADJUSTMENT' THEN 'Rounding adjustment'
                ELSE REPLACE(REPLACE(pc.ComponentCode, '_', ' '), 'PAY ', 'Pay ')
            END,

        pc.ComponentCode,
        pc.ComponentHours,
        pc.ComponentAmount,

        ComponentEffect =
            CASE
                WHEN pc.ComponentAmount > 0 THEN 'Add'
                WHEN pc.ComponentAmount < 0 THEN 'Deduct'
                ELSE 'Neutral'
            END,

        IsWTLComponent =
            CASE WHEN pc.ComponentCode LIKE 'WTL%' THEN 1 ELSE 0 END,

        wtl.EntryExpectedMealCount,
        wtl.MealBucket,
        wtl.WTL_TokenState,
        wtl.WTL_TokenCount,
        wtl.WTL_Token_MissedMeals,
        wtl.Has_ConflictingWTLTokens,
        wtl.HasWTLIssue,
        wtl.WTL_ErrorCount,
        wtl.WTL_WarningCount,
        wtl.WTL_ReviewCount,
        wtl.WTL_IssueReasons
    FROM fms.Payroll_PayComponent pc
    LEFT JOIN api.v_UI_WTL_LaborEntry_Status wtl
        ON wtl.LaborPayrollID = pc.LaborPayrollID
)
SELECT
    ComponentLineNo =
        ROW_NUMBER() OVER
        (
            PARTITION BY LaborPayrollID
            ORDER BY
                ComponentDisplaySort,
                ComponentCode,
                ComponentAmount DESC,
                ComponentHours DESC
        ),
    *
FROM DetailRows;
