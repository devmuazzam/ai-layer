CREATE   VIEW rpt.v_UI_RestPeriod_Overlap_LatestRun
AS
SELECT *
FROM rpt.v_UI_Payroll_Issues_Enriched_LatestRun
WHERE Reason LIKE 'RestPeriod_Overlap%';
