

/* ============================================================
   29 - Patch baseline scenario runner for long strings
   SAFE CHANGE: alters test procedure only

   Fix:
     Prevents "String or binary data would be truncated" caused by
     fixed-width test output/check text.
   ============================================================ */

CREATE         PROCEDURE [test].[usp_Run_CorePayrollScenario_Baseline]
      @ScenarioCode varchar(80) = NULL
    , @LaborPayrollID int = NULL
    , @IncludeInactive bit = 0
    , @ShowDetail bit = 0
    , @Tol decimal(10,4) = 0.01
AS
BEGIN
    SET NOCOUNT ON;

    IF OBJECT_ID('tempdb..#Scenario') IS NOT NULL DROP TABLE #Scenario;
    IF OBJECT_ID('tempdb..#Checks') IS NOT NULL DROP TABLE #Checks;

    SELECT *
    INTO #Scenario
    FROM test.Case_CorePayrollScenario sc
    WHERE
        (@ScenarioCode IS NULL OR sc.ScenarioCode = @ScenarioCode)
        AND (@LaborPayrollID IS NULL OR sc.LaborPayrollID = @LaborPayrollID)
        AND (@IncludeInactive = 1 OR sc.IsActive = 1);

    CREATE TABLE #Checks
    (
        ScenarioID int NOT NULL,
        ScenarioCode varchar(80) NOT NULL,
        ScenarioGroup varchar(80) NULL,
        ScenarioName nvarchar(300) NULL,
        LaborPayrollID int NULL,
        CheckName nvarchar(300) NOT NULL,
        ExpectedValue nvarchar(max) NULL,
        ActualValue nvarchar(max) NULL,
        Difference decimal(19,4) NULL,
        PassFlag bit NOT NULL,
        DetailNote nvarchar(max) NULL
    );

    /* Existence check */
    INSERT INTO #Checks
    (
        ScenarioID, ScenarioCode, ScenarioGroup, ScenarioName, LaborPayrollID,
        CheckName, ExpectedValue, ActualValue, Difference, PassFlag, DetailNote
    )
    SELECT
        sc.ScenarioID,
        sc.ScenarioCode,
        sc.ScenarioGroup,
        sc.ScenarioName,
        sc.LaborPayrollID,
        CheckName = N'Exists in fms.Payroll_Calculated',
        ExpectedValue = N'1',
        ActualValue = CONVERT(nvarchar(max), CASE WHEN pc.LaborPayrollID IS NOT NULL THEN 1 ELSE 0 END),
        Difference = NULL,
        PassFlag = CONVERT(bit, CASE WHEN pc.LaborPayrollID IS NOT NULL THEN 1 ELSE 0 END),
        DetailNote = NULL
    FROM #Scenario sc
    LEFT JOIN fms.Payroll_Calculated pc
        ON pc.LaborPayrollID = sc.LaborPayrollID;

    /* Numeric expected-value checks */
    INSERT INTO #Checks
    (
        ScenarioID, ScenarioCode, ScenarioGroup, ScenarioName, LaborPayrollID,
        CheckName, ExpectedValue, ActualValue, Difference, PassFlag, DetailNote
    )
    SELECT
        sc.ScenarioID,
        sc.ScenarioCode,
        sc.ScenarioGroup,
        sc.ScenarioName,
        sc.LaborPayrollID,
        v.CheckName,
        ExpectedValue = CONVERT(nvarchar(max), v.ExpectedNum),
        ActualValue = CONVERT(nvarchar(max), v.ActualNum),
        Difference =
            CASE
                WHEN v.ExpectedNum IS NULL OR v.ActualNum IS NULL THEN NULL
                ELSE CONVERT(decimal(19,4), v.ActualNum - v.ExpectedNum)
            END,
        PassFlag =
            CONVERT(bit,
                CASE
                    WHEN v.ExpectedNum IS NULL THEN 1
                    WHEN v.ActualNum IS NOT NULL
                     AND ABS(v.ActualNum - v.ExpectedNum) <= @Tol THEN 1
                    ELSE 0
                END
            ),
        DetailNote = NULL
    FROM #Scenario sc
    LEFT JOIN fms.Payroll_Calculated pc
        ON pc.LaborPayrollID = sc.LaborPayrollID
    CROSS APPLY
    (
        VALUES
            (N'Act_Total_Hrs',      CONVERT(decimal(19,4), sc.Expected_Act_Total_Hrs),      CONVERT(decimal(19,4), pc.Act_Total_Hrs)),
            (N'Act_Boom_Hrs',       CONVERT(decimal(19,4), sc.Expected_Act_Boom_Hrs),       CONVERT(decimal(19,4), pc.Act_Boom_Hrs)),
            (N'Gap_Hrs_Total',      CONVERT(decimal(19,4), sc.Expected_Gap_Hrs_Total),      CONVERT(decimal(19,4), pc.Gap_Hrs_Total)),
            (N'Gap_Hrs_Boom',       CONVERT(decimal(19,4), sc.Expected_Gap_Hrs_Boom),       CONVERT(decimal(19,4), pc.Gap_Hrs_Boom)),
            (N'Pay_Total_Hrs',      CONVERT(decimal(19,4), sc.Expected_Pay_Total_Hrs),      CONVERT(decimal(19,4), pc.Pay_Total_Hrs)),
            (N'Hrs_ST',             CONVERT(decimal(19,4), sc.Expected_Hrs_ST),             CONVERT(decimal(19,4), pc.Hrs_ST)),
            (N'Hrs_OT',             CONVERT(decimal(19,4), sc.Expected_Hrs_OT),             CONVERT(decimal(19,4), pc.Hrs_OT)),
            (N'Hrs_DT',             CONVERT(decimal(19,4), sc.Expected_Hrs_DT),             CONVERT(decimal(19,4), pc.Hrs_DT)),
            (N'Audit_Min_Rule',     CONVERT(decimal(19,4), sc.Expected_Audit_Min_Rule),     CONVERT(decimal(19,4), pc.Audit_Min_Rule)),
            (N'Audit_Gap_Mult',     CONVERT(decimal(19,4), sc.Expected_Audit_Gap_Mult),     CONVERT(decimal(19,4), pc.Audit_Gap_Mult)),
            (N'Rest_IsForced',      CONVERT(decimal(19,4), sc.Expected_Rest_IsForced),      CONVERT(decimal(19,4), pc.Rest_IsForced)),
            (N'Rest_IsOverlap',     CONVERT(decimal(19,4), sc.Expected_Rest_IsOverlap),     CONVERT(decimal(19,4), pc.Rest_IsOverlap)),
            (N'Rest_Premium_Hrs',   CONVERT(decimal(19,4), sc.Expected_Rest_Premium_Hrs),   CONVERT(decimal(19,4), pc.Rest_Premium_Hrs))
    ) v(CheckName, ExpectedNum, ActualNum)
    WHERE v.ExpectedNum IS NOT NULL;

    /* Guaranteed-hours allocation compatibility checks */
    ;WITH GuaranteeAgg AS
    (
        SELECT
            a.LaborPayrollID,

            Guarantee_Gap_Hrs_Total =
                CAST(SUM(CASE WHEN a.RuleCode <> 'LONG_BOOM_MIN_4' THEN a.AllocatedGapHours ELSE 0 END) AS decimal(19,4)),

            Guarantee_Gap_Hrs_Boom =
                CAST(SUM(CASE WHEN a.RuleCode = 'LONG_BOOM_MIN_4' THEN a.AllocatedGapHours ELSE 0 END) AS decimal(19,4)),

            Guarantee_Pay_Gap_Add =
                CAST(SUM(a.AllocatedGapPay) AS decimal(19,4)),

            Guarantee_AllocationCount =
                COUNT_BIG(*)
        FROM api.v_UI_GuaranteeAllocations a
        GROUP BY
            a.LaborPayrollID
    )
    INSERT INTO #Checks
    (
        ScenarioID, ScenarioCode, ScenarioGroup, ScenarioName, LaborPayrollID,
        CheckName, ExpectedValue, ActualValue, Difference, PassFlag, DetailNote
    )
    SELECT
        sc.ScenarioID,
        sc.ScenarioCode,
        sc.ScenarioGroup,
        sc.ScenarioName,
        sc.LaborPayrollID,
        v.CheckName,
        ExpectedValue = CONVERT(nvarchar(max), v.ExpectedNum),
        ActualValue = CONVERT(nvarchar(max), v.ActualNum),
        Difference =
            CASE
                WHEN v.ExpectedNum IS NULL OR v.ActualNum IS NULL THEN NULL
                ELSE CONVERT(decimal(19,4), v.ActualNum - v.ExpectedNum)
            END,
        PassFlag =
            CONVERT(bit,
                CASE
                    WHEN v.ExpectedNum IS NULL AND v.ActualNum IS NULL THEN 1
                    WHEN v.ExpectedNum IS NOT NULL
                     AND v.ActualNum IS NOT NULL
                     AND ABS(v.ActualNum - v.ExpectedNum) <= @Tol THEN 1
                    ELSE 0
                END
            ),
        DetailNote =
            N'Compatibility check: fms.Payroll_Calculated guarantee fields must equal api.v_UI_GuaranteeAllocations rollup.'
    FROM #Scenario sc
    LEFT JOIN fms.Payroll_Calculated pc
        ON pc.LaborPayrollID = sc.LaborPayrollID
    LEFT JOIN GuaranteeAgg ga
        ON ga.LaborPayrollID = sc.LaborPayrollID
    CROSS APPLY
    (
        VALUES
            (
                N'GuaranteeCompat_Gap_Hrs_Total',
                CONVERT(decimal(19,4), ISNULL(ga.Guarantee_Gap_Hrs_Total, 0)),
                CONVERT(decimal(19,4), ISNULL(pc.Gap_Hrs_Total, 0))
            ),
            (
                N'GuaranteeCompat_Gap_Hrs_Boom',
                CONVERT(decimal(19,4), ISNULL(ga.Guarantee_Gap_Hrs_Boom, 0)),
                CONVERT(decimal(19,4), ISNULL(pc.Gap_Hrs_Boom, 0))
            ),
            (
                N'GuaranteeCompat_Pay_Gap_Add',
                CONVERT(decimal(19,4), ISNULL(ga.Guarantee_Pay_Gap_Add, 0)),
                CONVERT(decimal(19,4), ISNULL(pc.Pay_Gap_Add, 0))
            )
    ) v(CheckName, ExpectedNum, ActualNum);


    
    /* Clean rest-period semantics check */
    INSERT INTO #Checks
    (
        ScenarioID, ScenarioCode, ScenarioGroup, ScenarioName, LaborPayrollID,
        CheckName, ExpectedValue, ActualValue, Difference, PassFlag, DetailNote
    )
    SELECT
        sc.ScenarioID,
        sc.ScenarioCode,
        sc.ScenarioGroup,
        sc.ScenarioName,
        sc.LaborPayrollID,
        CheckName = N'Final_Gross_Pay clean payable gross semantics',
        ExpectedValue = N'Final_Gross_Pay = Pay_Actual_Gross + Pay_Gap_Add + Pay_Rest_Add',
        ActualValue =
            CONCAT
            (
                N'Final=', CONVERT(nvarchar(50), pc.Final_Gross_Pay),
                N'; Actual+Gap+Rest=',
                CONVERT
                (
                    nvarchar(50),
                    CONVERT
                    (
                        decimal(19,4),
                          ISNULL(pc.Pay_Actual_Gross,0)
                        + ISNULL(pc.Pay_Gap_Add,0)
                        + ISNULL(pc.Pay_Rest_Add,0)
                    )
                )
            ),
        Difference =
            CONVERT
            (
                decimal(19,4),
                  ISNULL(pc.Final_Gross_Pay,0)
                - (
                      ISNULL(pc.Pay_Actual_Gross,0)
                    + ISNULL(pc.Pay_Gap_Add,0)
                    + ISNULL(pc.Pay_Rest_Add,0)
                  )
            ),
        PassFlag =
            CONVERT
            (
                bit,
                CASE
                    WHEN pc.LaborPayrollID IS NOT NULL
                     AND ABS
                         (
                             ISNULL(pc.Final_Gross_Pay,0)
                           - (
                                 ISNULL(pc.Pay_Actual_Gross,0)
                               + ISNULL(pc.Pay_Gap_Add,0)
                               + ISNULL(pc.Pay_Rest_Add,0)
                             )
                         ) <= @Tol
                    THEN 1 ELSE 0
                END
            ),
        DetailNote =
            N'Clean rest-period semantics: Pay_Actual_Gross excludes rest premium; Pay_Rest_Add stores rest premium; Final_Gross_Pay is total payable gross.'
    FROM #Scenario sc
    LEFT JOIN fms.Payroll_Calculated pc
        ON pc.LaborPayrollID = sc.LaborPayrollID;

    /* Expected exception/warning check */
    INSERT INTO #Checks
    (
        ScenarioID, ScenarioCode, ScenarioGroup, ScenarioName, LaborPayrollID,
        CheckName, ExpectedValue, ActualValue, Difference, PassFlag, DetailNote
    )
    SELECT
        sc.ScenarioID,
        sc.ScenarioCode,
        sc.ScenarioGroup,
        sc.ScenarioName,
        sc.LaborPayrollID,
        CheckName = N'Expected exception reason',
        ExpectedValue = CONVERT(nvarchar(max), sc.Expected_ExceptionReasonLike),
        ActualValue =
            CASE
                WHEN sc.Expected_ExceptionReasonLike IS NULL THEN NULL
                ELSE
                    (
                        SELECT TOP (1) CONVERT(nvarchar(max), e.Reason)
                        FROM fms.Payroll_CalcException e
                        WHERE e.LaborPayrollID = sc.LaborPayrollID
                          AND e.Reason LIKE sc.Expected_ExceptionReasonLike
                        ORDER BY e.CalcRunAt DESC, e.RunId DESC
                    )
            END,
        Difference = NULL,
        PassFlag =
            CONVERT(bit,
                CASE
                    WHEN sc.Expected_ExceptionReasonLike IS NULL THEN 1
                    WHEN EXISTS
                    (
                        SELECT 1
                        FROM fms.Payroll_CalcException e
                        WHERE e.LaborPayrollID = sc.LaborPayrollID
                          AND e.Reason LIKE sc.Expected_ExceptionReasonLike
                    ) THEN 1
                    ELSE 0
                END
            ),
        DetailNote =
            CASE
                WHEN sc.Expected_ExceptionReasonLike IS NULL
                    THEN N'Only checked when Expected_ExceptionReasonLike is populated.'
                ELSE NULL
            END
    FROM #Scenario sc;

    ;WITH ScenarioResults AS
    (
        SELECT
            sc.ScenarioID,
            sc.ScenarioCode,
            sc.ScenarioGroup,
            sc.ScenarioName,
            sc.LaborPayrollID,
            sc.IsKnownIssue,
            sc.KnownIssueNote,
            ScenarioPass =
                CONVERT(bit,
                    CASE
                        WHEN NOT EXISTS
                        (
                            SELECT 1
                            FROM #Checks c
                            WHERE c.ScenarioID = sc.ScenarioID
                              AND c.PassFlag = 0
                        )
                        THEN 1 ELSE 0
                    END
                ),
            FailedCheckCount =
                (
                    SELECT COUNT_BIG(*)
                    FROM #Checks c
                    WHERE c.ScenarioID = sc.ScenarioID
                      AND c.PassFlag = 0
                ),
            FailedChecks =
                NULLIF(
                    STUFF(
                        (
                            SELECT N'; ' + c.CheckName
                            FROM #Checks c
                            WHERE c.ScenarioID = sc.ScenarioID
                              AND c.PassFlag = 0
                            ORDER BY c.CheckName
                            FOR XML PATH(''), TYPE
                        ).value('.', 'nvarchar(max)'),
                        1, 2, N''
                    ),
                    N''
                )
        FROM #Scenario sc
    )
    SELECT
        TotalScenarios = COUNT_BIG(*),
        PassedScenarios = SUM(CASE WHEN ScenarioPass = 1 THEN 1 ELSE 0 END),
        FailedScenarios = SUM(CASE WHEN ScenarioPass = 0 THEN 1 ELSE 0 END),
        KnownIssueScenarios = SUM(CASE WHEN IsKnownIssue = 1 THEN 1 ELSE 0 END),
        OverallPass =
            CONVERT(bit,
                CASE
                    WHEN COUNT_BIG(*) > 0
                     AND SUM(CASE WHEN ScenarioPass = 0 THEN 1 ELSE 0 END) = 0
                    THEN 1 ELSE 0
                END
            )
    FROM ScenarioResults;

    ;WITH ScenarioResults AS
    (
        SELECT
            sc.ScenarioID,
            sc.ScenarioCode,
            sc.ScenarioGroup,
            sc.ScenarioName,
            sc.LaborPayrollID,
            sc.IsKnownIssue,
            sc.KnownIssueNote,
            ScenarioPass =
                CONVERT(bit,
                    CASE
                        WHEN NOT EXISTS
                        (
                            SELECT 1
                            FROM #Checks c
                            WHERE c.ScenarioID = sc.ScenarioID
                              AND c.PassFlag = 0
                        )
                        THEN 1 ELSE 0
                    END
                ),
            FailedCheckCount =
                (
                    SELECT COUNT_BIG(*)
                    FROM #Checks c
                    WHERE c.ScenarioID = sc.ScenarioID
                      AND c.PassFlag = 0
                ),
            FailedChecks =
                NULLIF(
                    STUFF(
                        (
                            SELECT N'; ' + c.CheckName
                            FROM #Checks c
                            WHERE c.ScenarioID = sc.ScenarioID
                              AND c.PassFlag = 0
                            ORDER BY c.CheckName
                            FOR XML PATH(''), TYPE
                        ).value('.', 'nvarchar(max)'),
                        1, 2, N''
                    ),
                    N''
                )
        FROM #Scenario sc
    )
    SELECT *
    FROM ScenarioResults
    ORDER BY
        ScenarioGroup,
        ScenarioCode;

    IF @ShowDetail = 1
    BEGIN
        SELECT *
        FROM #Checks
        ORDER BY
            ScenarioID,
            CheckName;
    END
END;
