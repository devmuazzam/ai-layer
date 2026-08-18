
CREATE   VIEW test.v_CrossMidnight_DayType_Actual
AS
WITH ActivePolicy AS
(
    SELECT TOP (1) PolicyCode
    FROM cfg.CrossMidnightDayTypePolicy
    WHERE IsActive = 1
    ORDER BY PolicyCode
),
CaseCalc AS
(
    SELECT
        c.CaseID,
        c.CaseName,
        c.AnchorDayType,
        c.PostMidnightDayType,
        c.Minutes_PreMidnight,
        c.Minutes_PostMidnight,
        TotalMinutes = c.Minutes_PreMidnight + c.Minutes_PostMidnight,

        -- Treat these as "High" vs Weekday for this harness
        AnchorIsHigh = CASE WHEN c.AnchorDayType IN ('Holiday','Sunday','SpecialSaturday','Saturday') THEN 1 ELSE 0 END,
        PostIsHigh   = CASE WHEN c.PostMidnightDayType IN ('Holiday','Sunday','SpecialSaturday','Saturday') THEN 1 ELSE 0 END,

        c.ExpectedHighMinutes_CalendarDay,
        c.ExpectedHighMinutes_AnchorFloor,
        c.Notes
    FROM test.Case_CrossMidnight_DayType c
)
SELECT
    ap.PolicyCode AS ActivePolicy,

    cc.CaseID,
    cc.CaseName,
    cc.AnchorDayType,
    cc.PostMidnightDayType,
    cc.Minutes_PreMidnight,
    cc.Minutes_PostMidnight,
    cc.TotalMinutes,

    -- CalendarDay: high minutes only for slices that fall on high day-type
    ActualHighMinutes_CalendarDay =
        CASE
            WHEN cc.AnchorIsHigh = 1 AND cc.PostIsHigh = 1 THEN cc.TotalMinutes
            WHEN cc.AnchorIsHigh = 1 AND cc.PostIsHigh = 0 THEN cc.Minutes_PreMidnight
            WHEN cc.AnchorIsHigh = 0 AND cc.PostIsHigh = 1 THEN cc.Minutes_PostMidnight
            ELSE 0
        END,

    -- AnchorFloor: if anchor day is high => all minutes high, else same as CalendarDay
    ActualHighMinutes_AnchorFloor =
        CASE
            WHEN cc.AnchorIsHigh = 1 THEN cc.TotalMinutes
            WHEN cc.PostIsHigh = 1 THEN cc.Minutes_PostMidnight
            ELSE 0
        END,

    cc.ExpectedHighMinutes_CalendarDay,
    cc.ExpectedHighMinutes_AnchorFloor,
    cc.Notes
FROM CaseCalc cc
CROSS JOIN ActivePolicy ap;
