
/* ============================================================
   35C - Create Job Ticket Status API Surface + Regression Test

   SAFE CHANGE:
     - Creates/updates app.v_JobTicket_Status_Enriched
     - Creates/updates api.v_UI_LaborEntry_JobTicketStatus
     - Creates/updates test.usp_Run_JobTicketStatus_Tests

   Purpose:
     Expose stable Job Ticket Status fields for Labor Entry UI
     without changing payroll calculation math.

   Confirmed by discovery:
     - src.FMS_JOB_TICKET_Raw.JobTicketStatus joins to
       src.FMS_TICKET_STATUS_Raw.TicketStatusCode.
     - Payroll-linked tickets use LEM TicketType.
     - LEM T status has one ambiguous pre-start state:
       Downloaded vs Not Started. Prefer Not Started for UI.
   ============================================================ */


CREATE   VIEW app.v_JobTicket_Status_Enriched AS
WITH TicketBase AS
(
    SELECT
        jt.JobTicketID,
        jt.JobCode,
        jt.TicketDate,
        TicketDate_Date = CAST(jt.TicketDate AS date),

        RawJobTicket_TicketType = jt.TicketType,
        StatusLookupTicketTypeUsed = CONVERT(varchar(10), 'LEM'),

        JobTicketStatusCode = jt.JobTicketStatus,

        Viewed = CONVERT(bit, ISNULL(jt.Viewed, 0)),
        Downloaded = CONVERT(bit, ISNULL(jt.Downloaded, 0)),

        Has_TimeStart =
            CONVERT(bit, CASE WHEN jt.TimeStart IS NULL THEN 0 ELSE 1 END),
        Has_TimeEnd =
            CONVERT(bit, CASE WHEN jt.TimeEnd IS NULL THEN 0 ELSE 1 END),

        jt.TimeStart,
        jt.TimeEnd,
        jt.StartWorkTime,
        jt.EndWorkTime,

        jt.Approved,
        jt.ApprovedDate,
        jt.Invoiced,
        jt.MarkedInvoice,
        jt.ETicketStatus,

        jt.CreatedDate,
        jt.ModifiedDate,
        jt._SourceExtractedAtUTC,
        jt._LoadedAtUTC
    FROM src.FMS_JOB_TICKET_Raw jt
),
CandidateStatus AS
(
    SELECT
        tb.*,
        StatusLookupDescription = s.Description,
        StatusLookupComments = s.Comments,

        MatchRank =
            CASE
                /* FMS LEM Y has two descriptions:
                   Arrived Yard and Ended.
                   TimeEnd-present should display Ended. */
                WHEN s.TimeEnd = 1
                     AND tb.Has_TimeEnd = 1
                    THEN 100

                /* FMS LEM T can become Started when TimeStart exists. */
                WHEN s.TimeStart = 1
                     AND tb.Has_TimeStart = 1
                    THEN 90

                /* FMS LEM T pre-start states are flag-driven. */
                WHEN tb.JobTicketStatusCode = 'T'
                     AND s.TimeStart = 0
                     AND s.TimeEnd = 0
                     AND s.Viewed = tb.Viewed
                     AND s.Download = tb.Downloaded
                    THEN 80

                /* FMS LEM Y with no TimeEnd should display Arrived Yard. */
                WHEN tb.JobTicketStatusCode = 'Y'
                     AND tb.Has_TimeEnd = 0
                     AND s.TimeEnd = 0
                    THEN 70

                /* Normal movement/signature/cancel/complete states. */
                WHEN ISNULL(s.Comments, '') LIKE 'Just go with Status and Type%'
                    THEN 60

                ELSE 0
            END,

        TieBreakRank =
            CASE
                /* Known ambiguity:
                   T + viewed + downloaded + no start/end has
                   both Downloaded and Not Started.
                   Prefer Not Started for business/UI display. */
                WHEN s.Description = 'Not Started' THEN 40
                WHEN s.Description = 'Downloaded'  THEN 30
                WHEN s.Description = 'Viewed'      THEN 20
                WHEN s.Description = 'Sent'        THEN 10
                ELSE 0
            END
    FROM TicketBase tb
    LEFT JOIN src.FMS_TICKET_STATUS_Raw s
        ON s.TicketStatusCode = tb.JobTicketStatusCode
       AND s.TicketType = 'LEM'
),
Chosen AS
(
    SELECT
        *,
        rn = ROW_NUMBER() OVER
        (
            PARTITION BY JobTicketID
            ORDER BY
                MatchRank DESC,
                TieBreakRank DESC,
                StatusLookupDescription
        )
    FROM CandidateStatus
),
FinalStatus AS
(
    SELECT
        *,
        JobTicketStatusDescription =
            CASE
                WHEN JobTicketStatusCode IS NULL THEN 'No Status'
                WHEN StatusLookupDescription IS NULL THEN 'Unknown Status'
                ELSE StatusLookupDescription
            END
    FROM Chosen
    WHERE rn = 1
)
SELECT
    JobTicketID,
    JobCode,
    TicketDate,
    TicketDate_Date,

    RawJobTicket_TicketType,
    StatusLookupTicketTypeUsed,

    JobTicketStatusCode,
    JobTicketStatusDescription,

    JobTicketStatusCategory =
        CASE
            WHEN JobTicketStatusCode IS NULL
                THEN 'No Status'
            WHEN JobTicketStatusDescription = 'Unknown Status'
                THEN 'Unknown'
            WHEN JobTicketStatusDescription IN ('Sent', 'Viewed', 'Downloaded', 'Not Started')
                THEN 'Not Started'
            WHEN JobTicketStatusDescription IN
                 (
                     'Started',
                     'Left Yard',
                     'Arrived Job',
                     '1st Signature',
                     '2nd Signature',
                     'Left Job',
                     'Arrived Yard'
                 )
                THEN 'In Progress'
            WHEN JobTicketStatusDescription = 'Ended'
                THEN 'Ended'
            WHEN JobTicketStatusDescription = 'Completed'
                THEN 'Completed'
            WHEN JobTicketStatusDescription = 'Cancelled'
                THEN 'Cancelled'
            ELSE 'Other'
        END,

    Is_Status_Known =
        CONVERT
        (
            bit,
            CASE
                WHEN JobTicketStatusCode IS NULL THEN 0
                WHEN StatusLookupDescription IS NULL THEN 0
                ELSE 1
            END
        ),

    Is_Ticket_Started =
        CONVERT
        (
            bit,
            CASE
                WHEN Has_TimeStart = 1 THEN 1
                WHEN JobTicketStatusDescription IN
                     (
                         'Started',
                         'Left Yard',
                         'Arrived Job',
                         '1st Signature',
                         '2nd Signature',
                         'Left Job',
                         'Arrived Yard',
                         'Ended',
                         'Completed'
                     )
                    THEN 1
                ELSE 0
            END
        ),

    Is_Ticket_Ended =
        CONVERT
        (
            bit,
            CASE
                WHEN Has_TimeEnd = 1 THEN 1
                WHEN JobTicketStatusDescription IN ('Ended', 'Completed')
                    THEN 1
                ELSE 0
            END
        ),

    Is_Ticket_Completed =
        CONVERT
        (
            bit,
            CASE
                WHEN JobTicketStatusDescription = 'Completed' THEN 1
                ELSE 0
            END
        ),

    Is_Ticket_Cancelled =
        CONVERT
        (
            bit,
            CASE
                WHEN JobTicketStatusDescription = 'Cancelled'
                     OR JobTicketStatusCode = 'X'
                    THEN 1
                ELSE 0
            END
        ),

    Viewed,
    Downloaded,
    Has_TimeStart,
    Has_TimeEnd,

    TimeStart,
    TimeEnd,
    StartWorkTime,
    EndWorkTime,

    Approved,
    ApprovedDate,
    Invoiced,
    MarkedInvoice,
    ETicketStatus,

    MatchRank,
    TieBreakRank,
    StatusLookupDescription,
    StatusLookupComments,

    CreatedDate,
    ModifiedDate,
    _SourceExtractedAtUTC,
    _LoadedAtUTC
FROM FinalStatus;
