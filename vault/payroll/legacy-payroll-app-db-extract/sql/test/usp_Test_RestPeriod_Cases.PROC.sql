
CREATE   PROCEDURE test.usp_Test_RestPeriod_Cases
AS
BEGIN
    SET NOCOUNT ON;

    IF OBJECT_ID('tempdb..#P') IS NOT NULL DROP TABLE #P;

    SELECT
        c.CaseID,
        c.EmpID,
        c.Prev_LaborPayrollID,
        c.Curr_LaborPayrollID,
        c.Expected_GapMinutes,
        Prev_End   = p.Pay_End_Rounded,
        Curr_Start = n.Pay_Start_Rounded,
        GapMinutes = DATEDIFF(MINUTE, p.Pay_End_Rounded, n.Pay_Start_Rounded)
    INTO #P
    FROM test.Case_RestPeriod c
    JOIN calc.v_Calc_Labor_Timeline p
      ON p.LaborPayrollID = c.Prev_LaborPayrollID
    JOIN calc.v_Calc_Labor_Timeline n
      ON n.LaborPayrollID = c.Curr_LaborPayrollID;

    -- Show results
    SELECT *
    FROM #P
    ORDER BY CaseID;

    -- Hard failures
    IF EXISTS (SELECT 1 FROM #P WHERE Prev_End IS NULL OR Curr_Start IS NULL)
        THROW 51051, 'RestPeriod case validation failed: Prev_End or Curr_Start is NULL for one or more cases.', 1;

    IF EXISTS (
        SELECT 1
        FROM #P
        WHERE Expected_GapMinutes IS NOT NULL
          AND GapMinutes <> Expected_GapMinutes
    )
        THROW 51050, 'RestPeriod case validation failed: GapMinutes != Expected_GapMinutes for one or more cases.', 1;

    PRINT 'RestPeriod cases validated successfully.';
END
