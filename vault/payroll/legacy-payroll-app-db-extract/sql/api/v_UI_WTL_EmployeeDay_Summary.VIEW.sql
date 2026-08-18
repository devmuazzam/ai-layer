

CREATE   VIEW api.v_UI_WTL_EmployeeDay_Summary
AS
SELECT
    EmpID,
    Employee_Name,
    WorkDate,

    LaborEntryCount = COUNT(*),
    TotalActualHours = SUM(Act_Total_Hrs),

    WTL_TokenedEntryCount =
        SUM(CASE WHEN WTL_TokenCount > 0 THEN 1 ELSE 0 END),
    WTL_MissingTokenCount =
        SUM(CASE WHEN WTL_TokenState = 'Missing token' THEN 1 ELSE 0 END),
    WTL_ConflictingTokenCount =
        SUM(CASE WHEN Has_ConflictingWTLTokens = 1 THEN 1 ELSE 0 END),

    WTL_ComponentEntryCount =
        SUM(CASE WHEN HasWTLComponent = 1 THEN 1 ELSE 0 END),
    WTL_ComponentRows =
        SUM(WTL_ComponentRows),
    WTL_ComponentHours =
        SUM(WTL_ComponentHours),
    WTL_ComponentAmount =
        SUM(WTL_ComponentAmount),
    WTL_DeductAmount =
        SUM(WTL_DeductAmount),
    WTL_AddAmount =
        SUM(WTL_AddAmount),

    WTL_IssueEntryCount =
        SUM(CASE WHEN HasWTLIssue = 1 THEN 1 ELSE 0 END),
    WTL_ErrorCount =
        SUM(WTL_ErrorCount),
    WTL_WarningCount =
        SUM(WTL_WarningCount),
    WTL_ReviewCount =
        SUM(WTL_ReviewCount),

    HasWTLError =
        CASE WHEN SUM(WTL_ErrorCount) > 0 THEN 1 ELSE 0 END,
    HasWTLWarning =
        CASE WHEN SUM(WTL_WarningCount) > 0 THEN 1 ELSE 0 END,
    HasWTLReview =
        CASE WHEN SUM(WTL_ReviewCount) > 0 THEN 1 ELSE 0 END
FROM api.v_UI_WTL_LaborEntry_Status
GROUP BY
    EmpID,
    Employee_Name,
    WorkDate;
