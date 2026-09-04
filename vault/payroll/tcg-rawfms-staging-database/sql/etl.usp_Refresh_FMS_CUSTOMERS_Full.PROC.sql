CREATE   PROCEDURE [etl].[usp_Refresh_FMS_CUSTOMERS_Full]
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
          @Resource    = N'[etl].[usp_Refresh_FMS_CUSTOMERS_Full]',
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
        FROM [stg].[FMS_CUSTOMERS_Raw];

        IF COL_LENGTH('tempdb..#SourceData', '_SourceExtractedAtUTC') IS NOT NULL
            ALTER TABLE #SourceData DROP COLUMN _SourceExtractedAtUTC;
        IF COL_LENGTH('tempdb..#SourceData', '_LoadedAtUTC') IS NOT NULL
            ALTER TABLE #SourceData DROP COLUMN _LoadedAtUTC;

        DECLARE @DataCols nvarchar(max) = N'[CustCode], [Name1], [Name2], [Address1], [Address2], [City], [StateCode], [Zip], [Country], [Email], [WebSite], [Phone], [Fax], [BillContact1], [BillPhone1], [BillContact2], [BillPhone2], [ClassID], [SpersonCode], [LastNameFirst], [PartsDisc], [PORequire], [IndustryCode], [Taxable], [SalesTaxCode], [Insurance], [Expires], [ContractNumb], [StatementType], [TermID], [Status], [Comments], [GroupNumb], [AcctUpdated], [FinChgPercent], [AcctIntCode], [CreditLimit], [PriceList], [PriceExpires], [Notes], [BillingTaxable], [CurrentBalance], [LeaseAgreement], [LeaseExpire], [LeaseNo], [Legal1], [Legal2], [Legal3], [Legal4], [Legal5], [Legal6], [Legal7], [Legal8], [Legal9], [Legal10], [Legal11], [Legal12], [LegalDate1], [LegalDate2], [LegalDate3], [LegalDate4], [LegalDate5], [LegalDate6], [LegalDate7], [LegalDate8], [LegalDate9], [LegalDate10], [LegalDate11], [LegalDate12], [TaxExempt], [ListMarkUp], [MarkUpPerc], [EmailDocOK], [CustTypeCode], [BlanketInsuranceAmt], [PerOccurrenceAmt], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [trgFMS_CUSTOMERS], [FederalTaxID], [TmwCityStateID], [BillContact1ID], [BillContact2ID], [POBeforeTicket], [COI], [USDOT], [ApplyEnvironmentalLevy], [SubContractor], [BPay], [AvalaraSent], [EntityUseCode], [ProspectCode], [ProspectStatus], [CountryCode], [InterCompanyAcct], [DBAName], [HRTempID], [ParentCustCode], [PricingMatrixCode]';

        -- OPENQUERY pass-through (explicit columns, no SELECT *)
        SET @RemoteQuery = N'SELECT ' + @DataCols + N' FROM [NexGenFMS].[dbo].[FMS_CUSTOMERS]';
        SET @RemoteQuery = REPLACE(@RemoteQuery, '''', ''''''); -- escape single quotes for OPENQUERY literal

        SET @ExecQuery =
            N'INSERT INTO #SourceData (' + @DataCols + N')
              SELECT ' + @DataCols + N'
              FROM OPENQUERY([FCC_NexGen], ''' + @RemoteQuery + N''');';

        EXEC sp_executesql @ExecQuery;

        SET @StagedRows = @@ROWCOUNT;

        BEGIN TRANSACTION;

            TRUNCATE TABLE [stg].[FMS_CUSTOMERS_Raw];

            

            -- FIXED: table hint placement (after table name, before column list)
            INSERT INTO [stg].[FMS_CUSTOMERS_Raw] WITH (TABLOCK)
                ([CustCode], [Name1], [Name2], [Address1], [Address2], [City], [StateCode], [Zip], [Country], [Email], [WebSite], [Phone], [Fax], [BillContact1], [BillPhone1], [BillContact2], [BillPhone2], [ClassID], [SpersonCode], [LastNameFirst], [PartsDisc], [PORequire], [IndustryCode], [Taxable], [SalesTaxCode], [Insurance], [Expires], [ContractNumb], [StatementType], [TermID], [Status], [Comments], [GroupNumb], [AcctUpdated], [FinChgPercent], [AcctIntCode], [CreditLimit], [PriceList], [PriceExpires], [Notes], [BillingTaxable], [CurrentBalance], [LeaseAgreement], [LeaseExpire], [LeaseNo], [Legal1], [Legal2], [Legal3], [Legal4], [Legal5], [Legal6], [Legal7], [Legal8], [Legal9], [Legal10], [Legal11], [Legal12], [LegalDate1], [LegalDate2], [LegalDate3], [LegalDate4], [LegalDate5], [LegalDate6], [LegalDate7], [LegalDate8], [LegalDate9], [LegalDate10], [LegalDate11], [LegalDate12], [TaxExempt], [ListMarkUp], [MarkUpPerc], [EmailDocOK], [CustTypeCode], [BlanketInsuranceAmt], [PerOccurrenceAmt], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [trgFMS_CUSTOMERS], [FederalTaxID], [TmwCityStateID], [BillContact1ID], [BillContact2ID], [POBeforeTicket], [COI], [USDOT], [ApplyEnvironmentalLevy], [SubContractor], [BPay], [AvalaraSent], [EntityUseCode], [ProspectCode], [ProspectStatus], [CountryCode], [InterCompanyAcct], [DBAName], [HRTempID], [ParentCustCode], [PricingMatrixCode], [_SourceExtractedAtUTC], [_LoadedAtUTC])
            SELECT
                [CustCode], [Name1], [Name2], [Address1], [Address2], [City], [StateCode], [Zip], [Country], [Email], [WebSite], [Phone], [Fax], [BillContact1], [BillPhone1], [BillContact2], [BillPhone2], [ClassID], [SpersonCode], [LastNameFirst], [PartsDisc], [PORequire], [IndustryCode], [Taxable], [SalesTaxCode], [Insurance], [Expires], [ContractNumb], [StatementType], [TermID], [Status], [Comments], [GroupNumb], [AcctUpdated], [FinChgPercent], [AcctIntCode], [CreditLimit], [PriceList], [PriceExpires], [Notes], [BillingTaxable], [CurrentBalance], [LeaseAgreement], [LeaseExpire], [LeaseNo], [Legal1], [Legal2], [Legal3], [Legal4], [Legal5], [Legal6], [Legal7], [Legal8], [Legal9], [Legal10], [Legal11], [Legal12], [LegalDate1], [LegalDate2], [LegalDate3], [LegalDate4], [LegalDate5], [LegalDate6], [LegalDate7], [LegalDate8], [LegalDate9], [LegalDate10], [LegalDate11], [LegalDate12], [TaxExempt], [ListMarkUp], [MarkUpPerc], [EmailDocOK], [CustTypeCode], [BlanketInsuranceAmt], [PerOccurrenceAmt], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [trgFMS_CUSTOMERS], [FederalTaxID], [TmwCityStateID], [BillContact1ID], [BillContact2ID], [POBeforeTicket], [COI], [USDOT], [ApplyEnvironmentalLevy], [SubContractor], [BPay], [AvalaraSent], [EntityUseCode], [ProspectCode], [ProspectStatus], [CountryCode], [InterCompanyAcct], [DBAName], [HRTempID], [ParentCustCode], [PricingMatrixCode], @BatchStart, SYSUTCDATETIME()
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
               AND ObjectName = N'FMS_CUSTOMERS';
        END

        EXEC sp_releaseapplock @Resource = N'[etl].[usp_Refresh_FMS_CUSTOMERS_Full]', @LockOwner = N'Session';
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK TRANSACTION;

        EXEC sp_releaseapplock @Resource = N'[etl].[usp_Refresh_FMS_CUSTOMERS_Full]', @LockOwner = N'Session';

        DECLARE
            @ErrLine int = ERROR_LINE(),
            @ErrMsg  nvarchar(4000) = ERROR_MESSAGE(),
            @ThrowMsg nvarchar(2048);

        SET @ThrowMsg = LEFT(CONCAT(N'[etl].[usp_Refresh_FMS_CUSTOMERS_Full] failed (line ', @ErrLine, N'): ', @ErrMsg), 2048);
        THROW 51000, @ThrowMsg, 1;
    END CATCH
END;
