    api.v_UI_Payroll_EmployeeDay_CalculationReviewSummary
AS

/*==============================================================
  UX-REVIEW-2H
  EMPLOYEE / DAY CALCULATION + REVIEW SUMMARY

  Employee/day dedupe rule:
    Identical payroll-facing messages are displayed once per
    employee/day.

  This intentionally preserves:
    - different note codes;
    - different message wording;
    - different rest gaps, because the gap is part of the message;
    - labor-entry detail in the underlying detail view.

  NO PAYROLL CALCULATION LOGIC IS CHANGED.
==============================================================*/

WITH Keyed AS
(
    SELECT
        d.RunId,
        d.EmpID,
        d.Employee_Name,
        d.WorkDate,
        d.LaborPayrollID,
        d.NoteType,
        d.NoteCode,
        d.DisplaySort,
        d.PayrollMessage,
        d.TechnicalReason,

        EffectiveDedupeKey =
            CONVERT
            (
                nvarchar(2000),
                CONCAT
                (
                    d.NoteType,
                    N'|',
                    d.NoteCode,
                    N'|',
                    d.PayrollMessage
                )
            )

    FROM api.v_UI_Payroll_LaborEntry_CalculationReviewDetail d
),

Deduped AS
(
    SELECT
        RunId,
        EmpID,

        Employee_Name =
            MAX(Employee_Name),

        WorkDate,
        EffectiveDedupeKey,

        NoteType =
            MAX(NoteType),

        NoteCode =
            MAX(NoteCode),

        DisplaySort =
            MIN(DisplaySort),

        PayrollMessage =
            MAX(PayrollMessage)

    FROM Keyed

    GROUP BY
        RunId,
        EmpID,
        WorkDate,
        EffectiveDedupeKey
),

ByType AS
(
    SELECT
        RunId,
        EmpID,

        Employee_Name =
            MAX(Employee_Name),

        WorkDate,
        NoteType,

        NoteCount =
            COUNT_BIG(*),

        NoteText =
            STRING_AGG
            (
                CONVERT(nvarchar(max), PayrollMessage),
                N' | '
            )
            WITHIN GROUP
            (
                ORDER BY
                    DisplaySort,
                    NoteCode,
                    EffectiveDedupeKey
            )

    FROM Deduped

    GROUP BY
        RunId,
        EmpID,
        WorkDate,
        NoteType
),

Pivoted AS
(
    SELECT
        RunId,
        EmpID,

        Employee_Name =
            MAX(Employee_Name),

        WorkDate,

        InfoNoteCount =
            SUM
            (
                CASE
                    WHEN NoteType = 'INFO'
                        THEN NoteCount
                    ELSE CONVERT(bigint, 0)
                END
            ),

        ReviewNoteCount =
            SUM
            (
                CASE
                    WHEN NoteType = 'REVIEW'
                        THEN NoteCount
                    ELSE CONVERT(bigint, 0)
                END
            ),

        TotalNoteCount =
            SUM(NoteCount),

        CalculationInfoNotes =
            NULLIF
            (
                MAX
                (
                    CASE
                        WHEN NoteType = 'INFO'
                            THEN NoteText
                        ELSE CONVERT(nvarchar(max), N'')
                    END
                ),
                N''
            ),

        PayrollReviewReasons =
            NULLIF
            (
                MAX
                (
                    CASE
                        WHEN NoteType = 'REVIEW'
                            THEN NoteText
                        ELSE CONVERT(nvarchar(max), N'')
                    END
                ),
                N''
            )

    FROM ByType

    GROUP BY
        RunId,
        EmpID,
        WorkDate
)

SELECT
    RunId,
    EmpID,
    Employee_Name,
    WorkDate,

    InfoNoteCount,
    ReviewNoteCount,
    TotalNoteCount,

    HasCalculationInfo =
        CONVERT
        (
            bit,
            CASE
                WHEN InfoNoteCount > 0 THEN 1
                ELSE 0
            END
        ),

    HasPayrollReview =
        CONVERT
        (
            bit,
            CASE
                WHEN ReviewNoteCount > 0 THEN 1
                ELSE 0
            END
        ),

    CalculationInfoNotes,
    PayrollReviewReasons,

    PayrollCalculationReviewNotes =
        CONVERT
        (
            nvarchar(max),
            CASE

                WHEN PayrollReviewReasons IS NOT NULL
                 AND CalculationInfoNotes IS NOT NULL
                    THEN
                        PayrollReviewReasons
                        + N' | '
                        + CalculationInfoNotes

                WHEN PayrollReviewReasons IS NOT NULL
                    THEN PayrollReviewReasons

                ELSE CalculationInfoNotes

            END
        )

FROM Pivoted;

