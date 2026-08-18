

CREATE   VIEW api.v_UI_LaborEntry_JobTicketStatus AS
WITH LaborBase AS
(
    SELECT
        b.LaborPayrollID,
        b.WorkDate,
        WorkDate_Date = CAST(b.WorkDate AS date),

        b.EmpID,
        b.Employee_Name,

        b.JobTicketID,
        b.JobCode,

        b.LaborType,
        b.Is_AtomLabor,

        TicketExpectation = ISNULL(p.TicketExpectation, 'UNMAPPED'),

        Has_JobTicket =
            CONVERT
            (
                bit,
                CASE
                    WHEN b.JobTicketID IS NULL THEN 0
                    ELSE 1
                END
            )
    FROM app.v_Base_LaborPayroll b
    LEFT JOIN cfg.LaborType_TicketPolicy p
        ON p.LaborType = b.LaborType
       AND p.Is_AtomLabor = b.Is_AtomLabor
)
SELECT
    lb.LaborPayrollID,
    lb.WorkDate,
    lb.WorkDate_Date,

    lb.EmpID,
    lb.Employee_Name,

    lb.JobTicketID,
    lb.JobCode,

    lb.LaborType,
    lb.Is_AtomLabor,
    lb.TicketExpectation,
    lb.Has_JobTicket,

    Is_JobTicket_Expected =
        CONVERT
        (
            bit,
            CASE
                WHEN lb.TicketExpectation IN ('Expected', 'Required') THEN 1
                ELSE 0
            END
        ),

    Is_MissingExpectedJobTicket =
        CONVERT
        (
            bit,
            CASE
                WHEN lb.TicketExpectation IN ('Expected', 'Required')
                     AND lb.JobTicketID IS NULL
                    THEN 1
                ELSE 0
            END
        ),

    Is_UnexpectedJobTicketPresent =
        CONVERT
        (
            bit,
            CASE
                WHEN lb.TicketExpectation = 'NotExpected'
                     AND lb.JobTicketID IS NOT NULL
                    THEN 1
                ELSE 0
            END
        ),

    TicketExpectationFinding =
        CASE
            WHEN lb.TicketExpectation IN ('Expected', 'Required')
                 AND lb.JobTicketID IS NULL
                THEN 'Missing expected Job Ticket'

            WHEN lb.TicketExpectation = 'NotExpected'
                 AND lb.JobTicketID IS NOT NULL
                THEN 'Unexpected Job Ticket present'

            WHEN lb.TicketExpectation = 'UNMAPPED'
                THEN 'No LaborType/AtomLabor ticket policy mapping'

            ELSE 'OK'
        END,

    TicketExpectationSeverity =
        CASE
            WHEN lb.TicketExpectation IN ('Expected', 'Required')
                 AND lb.JobTicketID IS NULL
                THEN 'Review'

            WHEN lb.TicketExpectation = 'NotExpected'
                 AND lb.JobTicketID IS NOT NULL
                THEN 'Review'

            WHEN lb.TicketExpectation = 'UNMAPPED'
                THEN 'Review'

            ELSE 'OK'
        END,

    js.RawJobTicket_TicketType,
    js.StatusLookupTicketTypeUsed,

    JobTicketStatusCode = js.JobTicketStatusCode,

    JobTicketStatusDescription =
        CASE
            WHEN lb.JobTicketID IS NULL
                THEN 'No Job Ticket'
            WHEN js.JobTicketStatusDescription IS NULL
                THEN 'Unknown Status'
            ELSE js.JobTicketStatusDescription
        END,

    JobTicketStatusCategory =
        CASE
            WHEN lb.JobTicketID IS NULL
                THEN 'No Job Ticket'
            WHEN js.JobTicketStatusCategory IS NULL
                THEN 'Unknown'
            ELSE js.JobTicketStatusCategory
        END,

    JobTicketStatusDisplay =
        CASE
            WHEN lb.TicketExpectation IN ('Expected', 'Required')
                 AND lb.JobTicketID IS NULL
                THEN 'Missing expected Job Ticket'

            WHEN lb.JobTicketID IS NULL
                THEN 'No Job Ticket'

            WHEN js.JobTicketStatusDescription IS NULL
                THEN 'Unknown Status'

            ELSE js.JobTicketStatusDescription
        END,

    Is_Status_Known =
        CONVERT
        (
            bit,
            CASE
                WHEN lb.JobTicketID IS NULL THEN 1
                WHEN ISNULL(js.Is_Status_Known, 0) = 1 THEN 1
                ELSE 0
            END
        ),

    Is_Ticket_Started = ISNULL(js.Is_Ticket_Started, CONVERT(bit, 0)),
    Is_Ticket_Ended = ISNULL(js.Is_Ticket_Ended, CONVERT(bit, 0)),
    Is_Ticket_Completed = ISNULL(js.Is_Ticket_Completed, CONVERT(bit, 0)),
    Is_Ticket_Cancelled = ISNULL(js.Is_Ticket_Cancelled, CONVERT(bit, 0)),

    js.Viewed,
    js.Downloaded,
    js.Has_TimeStart,
    js.Has_TimeEnd,

    js.TimeStart,
    js.TimeEnd,
    js.StartWorkTime,
    js.EndWorkTime,

    js.Approved,
    js.ApprovedDate,
    js.Invoiced,
    js.MarkedInvoice,
    js.ETicketStatus,

    js.MatchRank,
    js.TieBreakRank
FROM LaborBase lb
LEFT JOIN app.v_JobTicket_Status_Enriched js
    ON js.JobTicketID = lb.JobTicketID;
