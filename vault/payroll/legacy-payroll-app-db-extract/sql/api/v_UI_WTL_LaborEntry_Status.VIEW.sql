

CREATE   VIEW api.v_UI_WTL_LaborEntry_Status
AS
WITH ComponentAgg AS
(
    SELECT
        LaborPayrollID,
        WTL_ComponentRows   = COUNT(*),
        WTL_ComponentCodes  = STRING_AGG(ComponentCode, ', '),
        WTL_ComponentHours  = SUM(ComponentHours),
        WTL_ComponentAmount = SUM(ComponentAmount),
        WTL_DeductAmount    = SUM(CASE WHEN ComponentCode = 'WTL_MEAL_DEDUCT'    THEN ComponentAmount ELSE 0 END),
        WTL_AddAmount       = SUM(CASE WHEN ComponentCode <> 'WTL_MEAL_DEDUCT'   THEN ComponentAmount ELSE 0 END)
    FROM fms.Payroll_PayComponent
    WHERE ComponentCode LIKE 'WTL%'
    GROUP BY LaborPayrollID
),
ExceptionAgg AS
(
    SELECT
        LaborPayrollID,
        WTL_IssueRows = COUNT(*),
        WTL_ErrorCount =
            SUM(CASE WHEN IssueLevel = 'Error' THEN 1 ELSE 0 END),
        WTL_WarningCount =
            SUM(CASE WHEN IssueLevel = 'Warning' THEN 1 ELSE 0 END),
        WTL_ReviewCount =
            SUM(CASE WHEN IssueLevel = 'Review' THEN 1 ELSE 0 END),
        WTL_IssueReasons =
            STRING_AGG(CONCAT(IssueLevel, ': ', Reason), ' | ')
    FROM api.v_UI_WTL_Exceptions_LatestRun
    GROUP BY LaborPayrollID
)
SELECT
    pc.LaborPayrollID,
    pc.EmpID,
    pc.Employee_Name,
    pc.WorkDate,
    pc.JobCode,
    pc.JobTicketID,

    pc.Act_Total_Hrs,
    pc.Hrs_ST,
    pc.Hrs_OT,
    pc.Hrs_DT,
    pc.Pay_Actual_Gross,
    pc.Pay_Gap_Add,
    pc.Pay_Rest_Add,
    pc.Final_Gross_Pay,

    EntryExpectedMealCount =
        CASE
            WHEN pc.Act_Total_Hrs BETWEEN 0.50 AND 5.00   THEN 0
            WHEN pc.Act_Total_Hrs BETWEEN 5.50 AND 10.50  THEN 1
            WHEN pc.Act_Total_Hrs BETWEEN 11.00 AND 16.00 THEN 2
            WHEN pc.Act_Total_Hrs BETWEEN 16.50 AND 21.50 THEN 3
            WHEN pc.Act_Total_Hrs BETWEEN 22.00 AND 27.00 THEN 4
            ELSE NULL
        END,

    MealBucket =
        CASE
            WHEN pc.Act_Total_Hrs BETWEEN 0.50 AND 5.00   THEN '0 meals expected: 0.5-5.0 hrs'
            WHEN pc.Act_Total_Hrs BETWEEN 5.50 AND 10.50  THEN '1 meal expected: 5.5-10.5 hrs'
            WHEN pc.Act_Total_Hrs BETWEEN 11.00 AND 16.00 THEN '2 meals expected: 11.0-16.0 hrs'
            WHEN pc.Act_Total_Hrs BETWEEN 16.50 AND 21.50 THEN '3 meals expected: 16.5-21.5 hrs'
            WHEN pc.Act_Total_Hrs BETWEEN 22.00 AND 27.00 THEN '4 meals expected: 22.0-27.0 hrs'
            ELSE 'Outside configured WTL threshold'
        END,

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
    Has_WTL_0 = ISNULL(t.Has_WTL_0, 0),
    Has_WTL_1 = ISNULL(t.Has_WTL_1, 0),
    Has_WTL_2 = ISNULL(t.Has_WTL_2, 0),
    Has_WTL_3 = ISNULL(t.Has_WTL_3, 0),
    Has_WTL_4 = ISNULL(t.Has_WTL_4, 0),
    Has_ConflictingWTLTokens = ISNULL(t.Has_ConflictingWTLTokens, 0),

    HasWTLComponent = CASE WHEN ca.LaborPayrollID IS NOT NULL THEN 1 ELSE 0 END,
    WTL_ComponentRows = ISNULL(ca.WTL_ComponentRows, 0),
    ca.WTL_ComponentCodes,
    WTL_ComponentHours = ISNULL(ca.WTL_ComponentHours, 0),
    WTL_ComponentAmount = ISNULL(ca.WTL_ComponentAmount, 0),
    WTL_DeductAmount = ISNULL(ca.WTL_DeductAmount, 0),
    WTL_AddAmount = ISNULL(ca.WTL_AddAmount, 0),

    HasWTLIssue = CASE WHEN ea.LaborPayrollID IS NOT NULL THEN 1 ELSE 0 END,
    WTL_IssueRows = ISNULL(ea.WTL_IssueRows, 0),
    WTL_ErrorCount = ISNULL(ea.WTL_ErrorCount, 0),
    WTL_WarningCount = ISNULL(ea.WTL_WarningCount, 0),
    WTL_ReviewCount = ISNULL(ea.WTL_ReviewCount, 0),
    ea.WTL_IssueReasons
FROM fms.Payroll_Calculated pc
LEFT JOIN app.v_LaborPayroll_CommentTokens t
    ON t.LaborPayrollID = pc.LaborPayrollID
LEFT JOIN ComponentAgg ca
    ON ca.LaborPayrollID = pc.LaborPayrollID
LEFT JOIN ExceptionAgg ea
    ON ea.LaborPayrollID = pc.LaborPayrollID;
