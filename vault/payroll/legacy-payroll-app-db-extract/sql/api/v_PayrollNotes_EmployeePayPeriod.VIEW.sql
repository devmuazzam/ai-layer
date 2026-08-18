
CREATE   VIEW api.v_PayrollNotes_EmployeePayPeriod
AS
SELECT
    n.NoteID,
    n.PayPeriodID,
    p.PeriodStartDate,
    p.PeriodEndDate,
    n.EmpID,
    n.NoteText,
    n.CreatedAtUTC,
    n.CreatedBy,
    n.IsDeleted,
    n.DeletedAtUTC,
    n.DeletedBy,
    IsLatest = CONVERT(bit,
        CASE WHEN ROW_NUMBER() OVER (
            PARTITION BY n.PayPeriodID, n.EmpID
            ORDER BY n.CreatedAtUTC DESC, n.NoteID DESC
        ) = 1 THEN 1 ELSE 0 END
    )
FROM app.PayrollNote_EmployeePayPeriod n
JOIN app.PayPeriod p
    ON p.PayPeriodID = n.PayPeriodID
WHERE n.IsDeleted = 0;
