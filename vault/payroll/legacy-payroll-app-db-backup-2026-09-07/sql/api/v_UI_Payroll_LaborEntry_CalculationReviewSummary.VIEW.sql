    api.v_UI_Payroll_LaborEntry_CalculationReviewSummary
AS

WITH Deduped AS
(
    SELECT
        d.RunId,
        d.CalcID,
        d.LaborPayrollID,
        d.WorkDate,
        d.EmpID,
        d.Employee_Name,
        d.JobTicketID,
        d.JobCode,
        d.UnionCode,
        d.PayrollGroup,
        d.Bucket_Source,
        d.DedupeKey,

        NoteType =
            MAX(d.NoteType),

        NoteCode =
            MAX(d.NoteCode),

        DisplaySort =
            MIN(d.DisplaySort),

        PayrollMessage =
            MAX(d.PayrollMessage)

    FROM api.v_UI_Payroll_LaborEntry_CalculationReviewDetail d

    GROUP BY
        d.RunId,
        d.CalcID,
        d.LaborPayrollID,
        d.WorkDate,
        d.EmpID,
        d.Employee_Name,
        d.JobTicketID,
        d.JobCode,
        d.UnionCode,
        d.PayrollGroup,
        d.Bucket_Source,
        d.DedupeKey
),

ByType AS
(
    SELECT
        RunId,
        CalcID,
        LaborPayrollID,
        WorkDate,
        EmpID,
        Employee_Name,
        JobTicketID,
        JobCode,
        UnionCode,
        PayrollGroup,
        Bucket_Source,
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
                    DedupeKey
            )

    FROM Deduped

    GROUP BY
        RunId,
        CalcID,
        LaborPayrollID,
        WorkDate,
        EmpID,
        Employee_Name,
        JobTicketID,
        JobCode,
        UnionCode,
        PayrollGroup,
        Bucket_Source,
        NoteType
),

Pivoted AS
(
    SELECT
        RunId,
        CalcID,
        LaborPayrollID,
        WorkDate,
        EmpID,
        Employee_Name,
        JobTicketID,
        JobCode,
        UnionCode,
        PayrollGroup,
        Bucket_Source,

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
            MAX
            (
                CASE
                    WHEN NoteType = 'INFO'
                        THEN NoteText
                END
            ),

        PayrollReviewReasons =
            MAX
            (
                CASE
                    WHEN NoteType = 'REVIEW'
                        THEN NoteText
                END
            )

    FROM ByType

    GROUP BY
        RunId,
        CalcID,
        LaborPayrollID,
        WorkDate,
        EmpID,
        Employee_Name,
        JobTicketID,
        JobCode,
        UnionCode,
        PayrollGroup,
        Bucket_Source
)

SELECT
    RunId,
    CalcID,
    LaborPayrollID,
    WorkDate,
    EmpID,
    Employee_Name,
    JobTicketID,
    JobCode,
    UnionCode,
    PayrollGroup,
    Bucket_Source,

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
                    THEN PayrollReviewReasons
                         + N' | '
                         + CalculationInfoNotes

                WHEN PayrollReviewReasons IS NOT NULL
                    THEN PayrollReviewReasons

                ELSE CalculationInfoNotes
            END
        )

FROM Pivoted;

