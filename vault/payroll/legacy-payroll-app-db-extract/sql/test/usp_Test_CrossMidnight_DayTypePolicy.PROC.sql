
CREATE   PROCEDURE test.usp_Test_CrossMidnight_DayTypePolicy
      @PolicyCode varchar(20) = NULL  -- 'CalendarDay' or 'AnchorFloor'; NULL = use active
AS
BEGIN
    SET NOCOUNT ON;

    IF @PolicyCode IS NULL
        SELECT TOP (1) @PolicyCode = PolicyCode
        FROM cfg.CrossMidnightDayTypePolicy
        WHERE IsActive = 1
        ORDER BY PolicyCode;

    IF @PolicyCode NOT IN ('CalendarDay','AnchorFloor')
        THROW 51001, 'PolicyCode must be CalendarDay or AnchorFloor.', 1;

    IF OBJECT_ID('tempdb..#A') IS NOT NULL DROP TABLE #A;

    SELECT
        CaseID,
        CaseName,
        ActivePolicy = @PolicyCode,
        AnchorDayType,
        PostMidnightDayType,
        Minutes_PreMidnight,
        Minutes_PostMidnight,
        ExpectedHighMinutes =
            CASE WHEN @PolicyCode = 'AnchorFloor'
                 THEN ExpectedHighMinutes_AnchorFloor
                 ELSE ExpectedHighMinutes_CalendarDay
            END,
        ActualHighMinutes =
            CASE WHEN @PolicyCode = 'AnchorFloor'
                 THEN ActualHighMinutes_AnchorFloor
                 ELSE ActualHighMinutes_CalendarDay
            END,
        Pass = CONVERT(bit, CASE
                 WHEN (CASE WHEN @PolicyCode = 'AnchorFloor' THEN ExpectedHighMinutes_AnchorFloor ELSE ExpectedHighMinutes_CalendarDay END)
                    = (CASE WHEN @PolicyCode = 'AnchorFloor' THEN ActualHighMinutes_AnchorFloor ELSE ActualHighMinutes_CalendarDay END)
                 THEN 1 ELSE 0 END),
        Notes
    INTO #A
    FROM test.v_CrossMidnight_DayType_Actual;

    SELECT * FROM #A ORDER BY CaseID;

    IF EXISTS (SELECT 1 FROM #A WHERE Pass = 0)
        THROW 51000, 'CrossMidnightDayTypePolicy test failed (Expected != Actual).', 1;
END
