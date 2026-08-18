
/* Drop/recreate is optional—use CREATE OR ALTER if you're on SQL 2016 SP1+ */
CREATE   VIEW api.v_Payroll_Calculated
AS
SELECT *
FROM fms.Payroll_Calculated;
