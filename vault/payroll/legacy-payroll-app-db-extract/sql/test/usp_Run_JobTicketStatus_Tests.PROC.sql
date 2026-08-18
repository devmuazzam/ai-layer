

CREATE   PROCEDURE test.usp_Run_JobTicketStatus_Tests
    @ShowDetail bit = 1
AS
BEGIN
    SET NOCOUNT ON;

    IF OBJECT_ID('app.v_JobTicket_Status_Enriched', 'V') IS NULL
        THROW 51000, 'Missing app.v_JobTicket_Status_Enriched. Re-run the view portion of 35C.', 1;

    IF OBJECT_ID('api.v_UI_LaborEntry_JobTicketStatus', 'V') IS NULL
        THROW 51001, 'Missing api.v_UI_LaborEntry_JobTicketStatus. Re-run the view portion of 35C.', 1;


    IF OBJECT_ID('tempdb..#CheckResults') IS NOT NULL
        DROP TABLE #CheckResults;

    CREATE TABLE #CheckResults
    (
        CheckID      int IDENTITY(1,1) NOT NULL,
        CheckName    varchar(200) NOT NULL,
        TotalRows    bigint NOT NULL,
        FailedRows   bigint NOT NULL,
        Pass         bit NOT NULL,
        Finding      varchar(4000) NOT NULL
    );


    /* --------------------------------------------------------
       Check 1: app status view has one row per JobTicketID
       -------------------------------------------------------- */
    ;WITH D AS
    (
        SELECT
            JobTicketID,
            RowsPerJobTicketID = COUNT_BIG(*)
        FROM app.v_JobTicket_Status_Enriched
        GROUP BY JobTicketID
    ),
    A AS
    (
        SELECT
            TotalRows = COUNT_BIG(*),
            FailedRows = ISNULL(SUM(CASE WHEN RowsPerJobTicketID <> 1 THEN 1 ELSE 0 END), 0)
        FROM D
    )
    INSERT #CheckResults
    (
        CheckName,
        TotalRows,
        FailedRows,
        Pass,
        Finding
    )
    SELECT
        'app.v_JobTicket_Status_Enriched has one row per JobTicketID',
        TotalRows,
        FailedRows,
        CONVERT(bit, CASE WHEN FailedRows = 0 THEN 1 ELSE 0 END),
        CASE
            WHEN FailedRows = 0
                THEN 'PASS: one row per JobTicketID.'
            ELSE 'FAIL: duplicate JobTicketID rows exist in app.v_JobTicket_Status_Enriched.'
        END
    FROM A;


    /* --------------------------------------------------------
       Check 2: UI view has one row per LaborPayrollID
       -------------------------------------------------------- */
    ;WITH D AS
    (
        SELECT
            LaborPayrollID,
            RowsPerLaborPayrollID = COUNT_BIG(*)
        FROM api.v_UI_LaborEntry_JobTicketStatus
        GROUP BY LaborPayrollID
    ),
    A AS
    (
        SELECT
            TotalRows = COUNT_BIG(*),
            FailedRows = ISNULL(SUM(CASE WHEN RowsPerLaborPayrollID <> 1 THEN 1 ELSE 0 END), 0)
        FROM D
    )
    INSERT #CheckResults
    (
        CheckName,
        TotalRows,
        FailedRows,
        Pass,
        Finding
    )
    SELECT
        'api.v_UI_LaborEntry_JobTicketStatus has one row per LaborPayrollID',
        TotalRows,
        FailedRows,
        CONVERT(bit, CASE WHEN FailedRows = 0 THEN 1 ELSE 0 END),
        CASE
            WHEN FailedRows = 0
                THEN 'PASS: one row per LaborPayrollID.'
            ELSE 'FAIL: duplicate LaborPayrollID rows exist in api.v_UI_LaborEntry_JobTicketStatus.'
        END
    FROM A;


    /* --------------------------------------------------------
       Check 3: all core baseline scenarios appear exactly once
       -------------------------------------------------------- */
    ;WITH D AS
    (
        SELECT
            s.ScenarioID,
            s.ScenarioCode,
            s.LaborPayrollID,
            RowsInUIView = COUNT(v.LaborPayrollID)
        FROM test.Case_CorePayrollScenario s
        LEFT JOIN api.v_UI_LaborEntry_JobTicketStatus v
            ON v.LaborPayrollID = s.LaborPayrollID
        GROUP BY
            s.ScenarioID,
            s.ScenarioCode,
            s.LaborPayrollID
    ),
    A AS
    (
        SELECT
            TotalRows = COUNT_BIG(*),
            FailedRows = ISNULL(SUM(CASE WHEN RowsInUIView <> 1 THEN 1 ELSE 0 END), 0)
        FROM D
    )
    INSERT #CheckResults
    (
        CheckName,
        TotalRows,
        FailedRows,
        Pass,
        Finding
    )
    SELECT
        'Core baseline scenarios appear exactly once in Job Ticket Status UI view',
        TotalRows,
        FailedRows,
        CONVERT(bit, CASE WHEN FailedRows = 0 THEN 1 ELSE 0 END),
        CASE
            WHEN FailedRows = 0
                THEN 'PASS: all baseline scenarios appear exactly once.'
            ELSE 'FAIL: one or more baseline scenarios are missing or duplicated.'
        END
    FROM A;


    /* --------------------------------------------------------
       Check 4: ticketed baseline rows have known display status
       -------------------------------------------------------- */
    ;WITH D AS
    (
        SELECT
            s.ScenarioID,
            s.ScenarioCode,
            v.LaborPayrollID,
            v.JobTicketID,
            v.JobTicketStatusDescription,
            v.JobTicketStatusDisplay,
            v.Is_Status_Known
        FROM test.Case_CorePayrollScenario s
        INNER JOIN api.v_UI_LaborEntry_JobTicketStatus v
            ON v.LaborPayrollID = s.LaborPayrollID
        WHERE v.JobTicketID IS NOT NULL
    ),
    A AS
    (
        SELECT
            TotalRows = COUNT_BIG(*),
            FailedRows =
                ISNULL
                (
                    SUM
                    (
                        CASE
                            WHEN ISNULL(Is_Status_Known, 0) <> 1
                              OR ISNULL(JobTicketStatusDescription, '') IN ('', 'Unknown Status', 'No Status', 'No Job Ticket')
                                THEN 1
                            ELSE 0
                        END
                    ),
                    0
                )
        FROM D
    )
    INSERT #CheckResults
    (
        CheckName,
        TotalRows,
        FailedRows,
        Pass,
        Finding
    )
    SELECT
        'Ticketed baseline scenarios have known Job Ticket Status',
        TotalRows,
        FailedRows,
        CONVERT(bit, CASE WHEN TotalRows > 0 AND FailedRows = 0 THEN 1 ELSE 0 END),
        CASE
            WHEN TotalRows > 0 AND FailedRows = 0
                THEN 'PASS: all ticketed baseline scenarios have known status.'
            WHEN TotalRows = 0
                THEN 'FAIL: no ticketed baseline scenarios were found.'
            ELSE 'FAIL: one or more ticketed baseline scenarios have missing/unknown status.'
        END
    FROM A;


    /* --------------------------------------------------------
       Check 5: baseline expectation findings remain OK
       -------------------------------------------------------- */
    ;WITH D AS
    (
        SELECT
            s.ScenarioID,
            s.ScenarioCode,
            v.LaborPayrollID,
            v.JobTicketID,
            v.TicketExpectation,
            v.TicketExpectationFinding
        FROM test.Case_CorePayrollScenario s
        INNER JOIN api.v_UI_LaborEntry_JobTicketStatus v
            ON v.LaborPayrollID = s.LaborPayrollID
    ),
    A AS
    (
        SELECT
            TotalRows = COUNT_BIG(*),
            FailedRows = ISNULL(SUM(CASE WHEN TicketExpectationFinding <> 'OK' THEN 1 ELSE 0 END), 0)
        FROM D
    )
    INSERT #CheckResults
    (
        CheckName,
        TotalRows,
        FailedRows,
        Pass,
        Finding
    )
    SELECT
        'Core baseline scenarios have expected ticket finding OK',
        TotalRows,
        FailedRows,
        CONVERT(bit, CASE WHEN TotalRows > 0 AND FailedRows = 0 THEN 1 ELSE 0 END),
        CASE
            WHEN TotalRows > 0 AND FailedRows = 0
                THEN 'PASS: baseline ticket expectation findings are OK.'
            WHEN TotalRows = 0
                THEN 'FAIL: no baseline scenarios were found.'
            ELSE 'FAIL: one or more baseline scenarios have ticket expectation findings.'
        END
    FROM A;


    /* --------------------------------------------------------
       Check 6: Expected + no ticket is classified correctly
       Validates Expected-vs-Required correction.
       -------------------------------------------------------- */
    ;WITH D AS
    (
        SELECT
            LaborPayrollID,
            TicketExpectation,
            Has_JobTicket,
            Is_MissingExpectedJobTicket,
            TicketExpectationFinding
        FROM api.v_UI_LaborEntry_JobTicketStatus
        WHERE TicketExpectation IN ('Expected', 'Required')
          AND Has_JobTicket = 0
    ),
    A AS
    (
        SELECT
            TotalRows = COUNT_BIG(*),
            FailedRows =
                ISNULL
                (
                    SUM
                    (
                        CASE
                            WHEN Is_MissingExpectedJobTicket <> 1
                              OR TicketExpectationFinding <> 'Missing expected Job Ticket'
                                THEN 1
                            ELSE 0
                        END
                    ),
                    0
                )
        FROM D
    )
    INSERT #CheckResults
    (
        CheckName,
        TotalRows,
        FailedRows,
        Pass,
        Finding
    )
    SELECT
        'Expected labor rows without ticket are classified as missing expected Job Ticket',
        TotalRows,
        FailedRows,
        CONVERT(bit, CASE WHEN FailedRows = 0 THEN 1 ELSE 0 END),
        CASE
            WHEN FailedRows = 0 AND TotalRows > 0
                THEN 'PASS: Expected + no ticket rows are classified correctly.'
            WHEN FailedRows = 0 AND TotalRows = 0
                THEN 'PASS: no current Expected + no ticket rows exist; classification has no failing rows.'
            ELSE 'FAIL: Expected + no ticket classification is incorrect.'
        END
    FROM A;


    /* --------------------------------------------------------
       Check 7: recent payroll-linked ticketed rows have known status
       -------------------------------------------------------- */
    ;WITH D AS
    (
        SELECT
            LaborPayrollID,
            WorkDate_Date,
            JobTicketID,
            JobTicketStatusCode,
            JobTicketStatusDescription,
            Is_Status_Known
        FROM api.v_UI_LaborEntry_JobTicketStatus
        WHERE WorkDate_Date >= DATEADD(DAY, -45, CAST(GETDATE() AS date))
          AND JobTicketID IS NOT NULL
    ),
    A AS
    (
        SELECT
            TotalRows = COUNT_BIG(*),
            FailedRows =
                ISNULL
                (
                    SUM
                    (
                        CASE
                            WHEN ISNULL(Is_Status_Known, 0) <> 1
                              OR ISNULL(JobTicketStatusDescription, '') IN ('', 'Unknown Status', 'No Status', 'No Job Ticket')
                                THEN 1
                            ELSE 0
                        END
                    ),
                    0
                )
        FROM D
    )
    INSERT #CheckResults
    (
        CheckName,
        TotalRows,
        FailedRows,
        Pass,
        Finding
    )
    SELECT
        'Recent ticketed labor rows have known Job Ticket Status',
        TotalRows,
        FailedRows,
        CONVERT(bit, CASE WHEN TotalRows > 0 AND FailedRows = 0 THEN 1 ELSE 0 END),
        CASE
            WHEN TotalRows > 0 AND FailedRows = 0
                THEN 'PASS: recent ticketed labor rows have known status.'
            WHEN TotalRows = 0
                THEN 'FAIL: no recent ticketed labor rows were found.'
            ELSE 'FAIL: one or more recent ticketed labor rows have missing/unknown status.'
        END
    FROM A;


    /* --------------------------------------------------------
       Check 8: non-ticketed baseline rows display No Job Ticket
       -------------------------------------------------------- */
    ;WITH D AS
    (
        SELECT
            s.ScenarioID,
            s.ScenarioCode,
            v.LaborPayrollID,
            v.JobTicketID,
            v.JobTicketStatusDescription,
            v.JobTicketStatusCategory,
            v.JobTicketStatusDisplay
        FROM test.Case_CorePayrollScenario s
        INNER JOIN api.v_UI_LaborEntry_JobTicketStatus v
            ON v.LaborPayrollID = s.LaborPayrollID
        WHERE v.JobTicketID IS NULL
    ),
    A AS
    (
        SELECT
            TotalRows = COUNT_BIG(*),
            FailedRows =
                ISNULL
                (
                    SUM
                    (
                        CASE
                            WHEN JobTicketStatusDescription <> 'No Job Ticket'
                              OR JobTicketStatusCategory <> 'No Job Ticket'
                              OR JobTicketStatusDisplay <> 'No Job Ticket'
                                THEN 1
                            ELSE 0
                        END
                    ),
                    0
                )
        FROM D
    )
    INSERT #CheckResults
    (
        CheckName,
        TotalRows,
        FailedRows,
        Pass,
        Finding
    )
    SELECT
        'Non-ticketed baseline scenarios display No Job Ticket',
        TotalRows,
        FailedRows,
        CONVERT(bit, CASE WHEN TotalRows > 0 AND FailedRows = 0 THEN 1 ELSE 0 END),
        CASE
            WHEN TotalRows > 0 AND FailedRows = 0
                THEN 'PASS: non-ticketed baseline scenarios display No Job Ticket.'
            WHEN TotalRows = 0
                THEN 'FAIL: no non-ticketed baseline scenarios were found.'
            ELSE 'FAIL: one or more non-ticketed baseline rows do not display No Job Ticket.'
        END
    FROM A;


    /* --------------------------------------------------------
       Summary
       -------------------------------------------------------- */
    SELECT
        TotalChecks = COUNT_BIG(*),
        PassedChecks = SUM(CASE WHEN Pass = 1 THEN 1 ELSE 0 END),
        FailedChecks = SUM(CASE WHEN Pass = 0 THEN 1 ELSE 0 END),
        OverallPass =
            CONVERT(bit, CASE WHEN SUM(CASE WHEN Pass = 0 THEN 1 ELSE 0 END) = 0 THEN 1 ELSE 0 END)
    FROM #CheckResults;


    IF @ShowDetail = 1
    BEGIN
        SELECT
            CheckID,
            CheckName,
            TotalRows,
            FailedRows,
            Pass,
            Finding
        FROM #CheckResults
        ORDER BY CheckID;


        SELECT
            s.ScenarioID,
            s.ScenarioCode,
            s.ScenarioGroup,
            s.ScenarioName,
            v.LaborPayrollID,
            v.WorkDate_Date,
            v.EmpID,
            v.Employee_Name,
            v.JobTicketID,
            v.JobCode,
            v.LaborType,
            v.Is_AtomLabor,
            v.TicketExpectation,
            v.Has_JobTicket,
            v.TicketExpectationFinding,
            v.TicketExpectationSeverity,
            v.RawJobTicket_TicketType,
            v.StatusLookupTicketTypeUsed,
            v.JobTicketStatusCode,
            v.JobTicketStatusDescription,
            v.JobTicketStatusCategory,
            v.JobTicketStatusDisplay,
            v.Is_Status_Known,
            v.Is_Ticket_Started,
            v.Is_Ticket_Ended,
            v.Is_Ticket_Completed,
            v.Is_Ticket_Cancelled,
            v.Viewed,
            v.Downloaded,
            v.Has_TimeStart,
            v.Has_TimeEnd,
            v.TimeStart,
            v.TimeEnd,
            v.MatchRank,
            v.TieBreakRank
        FROM test.Case_CorePayrollScenario s
        INNER JOIN api.v_UI_LaborEntry_JobTicketStatus v
            ON v.LaborPayrollID = s.LaborPayrollID
        ORDER BY s.ScenarioID;
    END
END;
