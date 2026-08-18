
CREATE   VIEW api.v_LaborPayroll_BreakReview
AS
SELECT
    b.LaborPayrollID,
    b.WorkDate,
    b.EmpID,
    b.Employee_Name,
    b.JobCode,
    b.JobTicketID,

    b.WorkThruLunch,
    b.WorkedThruLunch,

    LaborComments_Raw = p.Comments,

    LaborComments =
        CASE
            WHEN p.Comments IS NULL THEN NULL
            WHEN LEFT(LTRIM(p.Comments), 5) = '{\rtf' THEN app.fn_StripRTF(p.Comments)
            ELSE p.Comments
        END,

    HasComments =
        CONVERT(bit, CASE WHEN p.Comments IS NOT NULL AND LTRIM(RTRIM(p.Comments)) <> '' THEN 1 ELSE 0 END),

    CommentsTag =
        CASE
            WHEN p.Comments IS NULL OR LTRIM(RTRIM(p.Comments)) = '' THEN NULL
            WHEN p.Comments LIKE '%no 2nd%' OR p.Comments LIKE '%no second%' THEN 'Mentions: No 2nd lunch'
            WHEN p.Comments LIKE '%3rd%' OR p.Comments LIKE '%third%' THEN 'Mentions: 3rd lunch'
            WHEN p.Comments LIKE '%missed%' THEN 'Mentions: missed lunch'
            WHEN p.Comments LIKE '%lunch taken%' THEN 'Mentions: lunch taken'
            WHEN p.Comments LIKE '%no lunch%' THEN 'Mentions: no lunch'
            ELSE 'Mentions: other'
        END,

    o.Breaks_NotTaken_Count,
    BreakOverride_Notes = o.Notes,
    o.UpdatedAt,
    o.UpdatedBy,

    BreaksReviewNeeded =
        CONVERT(bit, CASE
            WHEN b.WorkedThruLunch = 'Yes' AND o.LaborPayrollID IS NULL THEN 1
            ELSE 0
        END),

    NeedsBreakReview_Reason =
        CASE
            WHEN b.WorkedThruLunch <> 'Yes' THEN NULL
            WHEN o.LaborPayrollID IS NOT NULL THEN NULL
            ELSE 'WTL=Yes and no override entered'
        END

FROM app.v_Base_LaborPayroll b
LEFT JOIN src.FMS_LABOR_PAYROLL_Raw p
    ON p.LaborPayrollID = b.LaborPayrollID
LEFT JOIN app.LaborBreakOverride o
    ON o.LaborPayrollID = b.LaborPayrollID;
