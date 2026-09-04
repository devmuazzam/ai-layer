CREATE   PROCEDURE [etl].[usp_Refresh_FMS_EMPLOYEES_Full]
    @RowsLoaded bigint = 0 OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    SET DEADLOCK_PRIORITY LOW;

    DECLARE
        @BatchStart      datetime2(0) = SYSUTCDATETIME(),
        @LockResult      int,
        @RemoteQuery     nvarchar(max),
        @ExecQuery       nvarchar(max),
        @StagedRows      bigint = 0;

    SET @RowsLoaded = 0;

    EXEC @LockResult = sp_getapplock
          @Resource    = N'[etl].[usp_Refresh_FMS_EMPLOYEES_Full]',
          @LockMode    = N'Exclusive',
          @LockOwner   = N'Session',
          @LockTimeout = 0;

    IF @LockResult < 0
        THROW 50001, 'Could not acquire applock (another run is active).', 1;

    BEGIN TRY
        IF OBJECT_ID('tempdb..#SourceData') IS NOT NULL DROP TABLE #SourceData;

        -- Create #SourceData with stg shape, then remove metadata columns
        SELECT TOP (0) *
        INTO #SourceData
        FROM [stg].[FMS_EMPLOYEES_Raw];

        IF COL_LENGTH('tempdb..#SourceData', '_SourceExtractedAtUTC') IS NOT NULL
            ALTER TABLE #SourceData DROP COLUMN _SourceExtractedAtUTC;
        IF COL_LENGTH('tempdb..#SourceData', '_LoadedAtUTC') IS NOT NULL
            ALTER TABLE #SourceData DROP COLUMN _LoadedAtUTC;

        DECLARE @DataCols nvarchar(max) = N'[EmpID], [LName], [FName], [MName], [Address1], [Address2], [City], [StateCode], [Zip], [Ssn], [CertPay], [Phone], [Mobile], [Pager], [CompanyCode], [YardCode], [Email], [PayCycle], [PayType], [UnionCode], [CraftCode], [PayRate], [BillingRate], [PayRateOT], [PayRateDB], [BillRateOT], [BillRateDB], [StartDate], [RehireDate], [TermDate], [Status], [TermReason], [InOffice], [Supervisor], [EmpTypeId], [BurdenCode], [WorkerCompCode], [ClassCode], [ClassID], [GLAcctCode], [BirthDate], [Gender], [Ethnic], [Apprentice], [UnionOpt1], [UnionOpt2], [UnionOpt3], [UnionOpt4], [UnionOpt5], [UnionOpt6], [UnionOpt7], [Comments], [AcctUpdated], [AcctIntCode], [StateTax], [CityTax], [JobTitleCode], [MaritalStatus], [GroupNumb], [DeptCode], [SutaState], [UnionOverScale], [UnionOverScaleDB], [UnionOverScaleOT], [UnionApprenticePerc], [MailBoxNo], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [OTEligible], [OTHours], [DTEligible], [DTHours], [SatOTAlltimeHW], [SatOTAllTimeHours], [SunOTAlltimeHW], [SunOTAllTimeHours], [SunDTAlltimeHW], [SunDTAllTimeHours], [PerDiem], [PerDiemCraftCode], [PerDiemMinHours], [PerDiemEveryHr], [Meals], [MealsCraftCode], [MealsMinHours], [trgFMS_EMPLOYEES], [RecFAAEmail], [ECName], [ECAddress], [ECCity], [ECStateCode], [ECZip], [ECWorkPhone], [ECCellPhone], [ECHomePhone], [ECEmail], [EC2Name], [EC2Address], [EC2City], [EC2StateCode], [EC2Zip], [EC2WorkPhone], [EC2CellPhone], [EC2HomePhone], [EC2Email], [PayrollExportedDate], [RoundLimit], [ApprenticeRegNo], [TelematicsGUID], [MinimumRate], [OTWeekHours], [DTWeekHours], [SplitMultipleDays], [EldUserName], [CraftModifierCode], [ITIID], [ITIModifiedDate], [ITICreatedDate], [ITICreatedBy], [ITIModifiedBy], [SendEmpITI], [DLNumber], [DLStateCode], [PayrollNo], [STPriority]';

        -- OPENQUERY pass-through (explicit columns, no SELECT *)
        SET @RemoteQuery = N'SELECT ' + @DataCols + N' FROM [NexGenFMS].[dbo].[FMS_EMPLOYEES]';
        SET @RemoteQuery = REPLACE(@RemoteQuery, '''', ''''''); -- escape single quotes for OPENQUERY literal

        SET @ExecQuery =
            N'INSERT INTO #SourceData (' + @DataCols + N')
              SELECT ' + @DataCols + N'
              FROM OPENQUERY([FCC_NexGen], ''' + @RemoteQuery + N''');';

        EXEC sp_executesql @ExecQuery;

        SET @StagedRows = @@ROWCOUNT;

        BEGIN TRANSACTION;

            TRUNCATE TABLE [stg].[FMS_EMPLOYEES_Raw];

            

            -- FIXED: table hint placement (after table name, before column list)
            INSERT INTO [stg].[FMS_EMPLOYEES_Raw] WITH (TABLOCK)
                ([EmpID], [LName], [FName], [MName], [Address1], [Address2], [City], [StateCode], [Zip], [Ssn], [CertPay], [Phone], [Mobile], [Pager], [CompanyCode], [YardCode], [Email], [PayCycle], [PayType], [UnionCode], [CraftCode], [PayRate], [BillingRate], [PayRateOT], [PayRateDB], [BillRateOT], [BillRateDB], [StartDate], [RehireDate], [TermDate], [Status], [TermReason], [InOffice], [Supervisor], [EmpTypeId], [BurdenCode], [WorkerCompCode], [ClassCode], [ClassID], [GLAcctCode], [BirthDate], [Gender], [Ethnic], [Apprentice], [UnionOpt1], [UnionOpt2], [UnionOpt3], [UnionOpt4], [UnionOpt5], [UnionOpt6], [UnionOpt7], [Comments], [AcctUpdated], [AcctIntCode], [StateTax], [CityTax], [JobTitleCode], [MaritalStatus], [GroupNumb], [DeptCode], [SutaState], [UnionOverScale], [UnionOverScaleDB], [UnionOverScaleOT], [UnionApprenticePerc], [MailBoxNo], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [OTEligible], [OTHours], [DTEligible], [DTHours], [SatOTAlltimeHW], [SatOTAllTimeHours], [SunOTAlltimeHW], [SunOTAllTimeHours], [SunDTAlltimeHW], [SunDTAllTimeHours], [PerDiem], [PerDiemCraftCode], [PerDiemMinHours], [PerDiemEveryHr], [Meals], [MealsCraftCode], [MealsMinHours], [trgFMS_EMPLOYEES], [RecFAAEmail], [ECName], [ECAddress], [ECCity], [ECStateCode], [ECZip], [ECWorkPhone], [ECCellPhone], [ECHomePhone], [ECEmail], [EC2Name], [EC2Address], [EC2City], [EC2StateCode], [EC2Zip], [EC2WorkPhone], [EC2CellPhone], [EC2HomePhone], [EC2Email], [PayrollExportedDate], [RoundLimit], [ApprenticeRegNo], [TelematicsGUID], [MinimumRate], [OTWeekHours], [DTWeekHours], [SplitMultipleDays], [EldUserName], [CraftModifierCode], [ITIID], [ITIModifiedDate], [ITICreatedDate], [ITICreatedBy], [ITIModifiedBy], [SendEmpITI], [DLNumber], [DLStateCode], [PayrollNo], [STPriority], [_SourceExtractedAtUTC], [_LoadedAtUTC])
            SELECT
                [EmpID], [LName], [FName], [MName], [Address1], [Address2], [City], [StateCode], [Zip], [Ssn], [CertPay], [Phone], [Mobile], [Pager], [CompanyCode], [YardCode], [Email], [PayCycle], [PayType], [UnionCode], [CraftCode], [PayRate], [BillingRate], [PayRateOT], [PayRateDB], [BillRateOT], [BillRateDB], [StartDate], [RehireDate], [TermDate], [Status], [TermReason], [InOffice], [Supervisor], [EmpTypeId], [BurdenCode], [WorkerCompCode], [ClassCode], [ClassID], [GLAcctCode], [BirthDate], [Gender], [Ethnic], [Apprentice], [UnionOpt1], [UnionOpt2], [UnionOpt3], [UnionOpt4], [UnionOpt5], [UnionOpt6], [UnionOpt7], [Comments], [AcctUpdated], [AcctIntCode], [StateTax], [CityTax], [JobTitleCode], [MaritalStatus], [GroupNumb], [DeptCode], [SutaState], [UnionOverScale], [UnionOverScaleDB], [UnionOverScaleOT], [UnionApprenticePerc], [MailBoxNo], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [OTEligible], [OTHours], [DTEligible], [DTHours], [SatOTAlltimeHW], [SatOTAllTimeHours], [SunOTAlltimeHW], [SunOTAllTimeHours], [SunDTAlltimeHW], [SunDTAllTimeHours], [PerDiem], [PerDiemCraftCode], [PerDiemMinHours], [PerDiemEveryHr], [Meals], [MealsCraftCode], [MealsMinHours], [trgFMS_EMPLOYEES], [RecFAAEmail], [ECName], [ECAddress], [ECCity], [ECStateCode], [ECZip], [ECWorkPhone], [ECCellPhone], [ECHomePhone], [ECEmail], [EC2Name], [EC2Address], [EC2City], [EC2StateCode], [EC2Zip], [EC2WorkPhone], [EC2CellPhone], [EC2HomePhone], [EC2Email], [PayrollExportedDate], [RoundLimit], [ApprenticeRegNo], [TelematicsGUID], [MinimumRate], [OTWeekHours], [DTWeekHours], [SplitMultipleDays], [EldUserName], [CraftModifierCode], [ITIID], [ITIModifiedDate], [ITICreatedDate], [ITICreatedBy], [ITIModifiedBy], [SendEmpITI], [DLNumber], [DLStateCode], [PayrollNo], [STPriority], @BatchStart, SYSUTCDATETIME()
            FROM #SourceData;

            SET @RowsLoaded = @@ROWCOUNT;

            

        COMMIT TRANSACTION;

        -- Best-effort RunLogDetail update (keeps your pattern)
        DECLARE @RunId bigint = (SELECT TOP (1) RunId FROM etl.RunLog ORDER BY RunId DESC);
        IF @RunId IS NOT NULL
        BEGIN
            UPDATE etl.RunLogDetail
               SET RowsAffected = @RowsLoaded
             WHERE RunId = @RunId
               AND ObjectName = N'FMS_EMPLOYEES';
        END

        EXEC sp_releaseapplock @Resource = N'[etl].[usp_Refresh_FMS_EMPLOYEES_Full]', @LockOwner = N'Session';
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK TRANSACTION;

        EXEC sp_releaseapplock @Resource = N'[etl].[usp_Refresh_FMS_EMPLOYEES_Full]', @LockOwner = N'Session';

        DECLARE
            @ErrLine int = ERROR_LINE(),
            @ErrMsg  nvarchar(4000) = ERROR_MESSAGE(),
            @ThrowMsg nvarchar(2048);

        SET @ThrowMsg = LEFT(CONCAT(N'[etl].[usp_Refresh_FMS_EMPLOYEES_Full] failed (line ', @ErrLine, N'): ', @ErrMsg), 2048);
        THROW 51000, @ThrowMsg, 1;
    END CATCH
END;
