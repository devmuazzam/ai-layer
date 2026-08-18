

/*============================================================
B) Notes READ views (history + IsLatest flag)
   - These filter out soft-deleted rows
============================================================*/

CREATE   VIEW api.v_PayrollNotes_PayPeriod
AS
SELECT
    n.NoteID,
    n.PayPeriodID,
    p.PeriodStartDate,
    p.PeriodEndDate,
    n.NoteText,
    n.CreatedAtUTC,
    n.CreatedBy,
    n.IsDeleted,
    n.DeletedAtUTC,
    n.DeletedBy,
    IsLatest = CONVERT(bit,
        CASE WHEN ROW_NUMBER() OVER (
            PARTITION BY n.PayPeriodID
            ORDER BY n.CreatedAtUTC DESC, n.NoteID DESC
        ) = 1 THEN 1 ELSE 0 END
    )
FROM app.PayrollNote_PayPeriod n
JOIN app.PayPeriod p
    ON p.PayPeriodID = n.PayPeriodID
WHERE n.IsDeleted = 0;
