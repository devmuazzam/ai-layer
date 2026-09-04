CREATE   PROCEDURE [etl].[usp_Refresh_FMS_UNITS_Full]
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
          @Resource    = N'[etl].[usp_Refresh_FMS_UNITS_Full]',
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
        FROM [stg].[FMS_UNITS_Raw];

        IF COL_LENGTH('tempdb..#SourceData', '_SourceExtractedAtUTC') IS NOT NULL
            ALTER TABLE #SourceData DROP COLUMN _SourceExtractedAtUTC;
        IF COL_LENGTH('tempdb..#SourceData', '_LoadedAtUTC') IS NOT NULL
            ALTER TABLE #SourceData DROP COLUMN _LoadedAtUTC;

        DECLARE @DataCols nvarchar(max) = N'[UnitCode], [UnitName], [DeptCode], [CompanyCode], [YardCode], [UnitSchedType], [UnitTypeID], [ModelYear], [Capacity], [VehicleMake], [VehicleModel], [UpEngMake], [UpEngModel], [LowEngMake], [LowEngModel], [TransModel], [TransMake], [Status], [InsuranceValue], [Insured], [HourUpper], [DateHrUpper], [HourLower], [DateHrLower], [MilesKM], [DateMilesKM], [License], [LicenseExpiry], [SerialNumber], [TiresType], [AxleType], [FuelName], [Gvm], [VehicleWidthFt], [VehicleWidthIn], [VehicleHeightFt], [VehicleHeightIn], [VehicleLengthFt], [VehicleLengthIn], [VehicleGageFt], [VehicleGageIn], [JibLengthFt], [JibLengthIn], [BoomLength], [Comments], [FuelCapacity], [MastHeight], [LiftHeight], [FreeLift], [ForkLength], [Carriage], [Tires], [ExtCapacity], [Accessories], [Attachment], [RentalRequirement], [DatePurchased], [PurchasePrice], [StartHrMiles], [NewUsed], [DateSold], [SalePrice], [DatePriced], [SoldInfo], [HourlyCost], [HourlyRate], [MonthlyTarget], [MonthlyPayment], [GlAcctTm], [GLAcctBare], [GLAcctOper], [GLAcctDelPickup], [GLAcctPermit], [MeasureCode], [YtdSalesTax], [SalesTaxLife], [PercentAmount], [SplitPercentage], [SplitAmount], [NeedsPickUp], [CheckOverlap], [SpersonCode], [WarrantyExpDate], [Category1], [Category2], [Category3], [BarCode], [SkytelID], [HoursAdjLower], [HoursAdjUpper], [DepreciationValue], [DepStartDate], [DepNextDate], [NoOfMonths], [ResidualValue], [InsureStartDate], [InsurancePeriod], [ResidualInsureAmt], [RedectionAmt], [TransportClass], [HireDate], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [trgFMS_UNITS], [AdditionalInfo1], [AdditionalInfo2], [AdditionalInfo3], [AdditionalInfo4], [AdditionalInfo5], [AdditionalInfo6], [AdditionalInfo7], [AdditionalInfo8], [AdditionalInfo9], [AdditionalInfo10], [AdditionalInfo11], [UpperGPS], [LowerGPS], [UpperGPSID], [LowerGPSID], [CurrentValue], [FuelPerc], [Field1], [Field2], [Field3], [Field4], [Field5], [SplInvComments], [MilesOrKm], [UpperEngSerialNo], [LowerEngSerialNo], [TransSerialNo], [CurrencyCode], [YardCodePL], [HasMeterHrsUp], [HasMeterHrsLo], [HasOdometerMiles], [OwnedOrRent], [StateCode], [RevenueAsOfDate], [Revenue], [LaborExpenses], [PartsExpenses], [VIN], [Chassis], [ManufacturerID], [ApplySMMTax], [Date1], [Date2], [EquipmentID], [AcceleratedTaxPaid], [HeavyMachinery], [TerpEligible], [EquipmentIDUpper], [ExpAcct]';

        -- OPENQUERY pass-through (explicit columns, no SELECT *)
        SET @RemoteQuery = N'SELECT ' + @DataCols + N' FROM [NexGenFMS].[dbo].[FMS_UNITS]';
        SET @RemoteQuery = REPLACE(@RemoteQuery, '''', ''''''); -- escape single quotes for OPENQUERY literal

        SET @ExecQuery =
            N'INSERT INTO #SourceData (' + @DataCols + N')
              SELECT ' + @DataCols + N'
              FROM OPENQUERY([FCC_NexGen], ''' + @RemoteQuery + N''');';

        EXEC sp_executesql @ExecQuery;

        SET @StagedRows = @@ROWCOUNT;

        BEGIN TRANSACTION;

            TRUNCATE TABLE [stg].[FMS_UNITS_Raw];

            

            -- FIXED: table hint placement (after table name, before column list)
            INSERT INTO [stg].[FMS_UNITS_Raw] WITH (TABLOCK)
                ([UnitCode], [UnitName], [DeptCode], [CompanyCode], [YardCode], [UnitSchedType], [UnitTypeID], [ModelYear], [Capacity], [VehicleMake], [VehicleModel], [UpEngMake], [UpEngModel], [LowEngMake], [LowEngModel], [TransModel], [TransMake], [Status], [InsuranceValue], [Insured], [HourUpper], [DateHrUpper], [HourLower], [DateHrLower], [MilesKM], [DateMilesKM], [License], [LicenseExpiry], [SerialNumber], [TiresType], [AxleType], [FuelName], [Gvm], [VehicleWidthFt], [VehicleWidthIn], [VehicleHeightFt], [VehicleHeightIn], [VehicleLengthFt], [VehicleLengthIn], [VehicleGageFt], [VehicleGageIn], [JibLengthFt], [JibLengthIn], [BoomLength], [Comments], [FuelCapacity], [MastHeight], [LiftHeight], [FreeLift], [ForkLength], [Carriage], [Tires], [ExtCapacity], [Accessories], [Attachment], [RentalRequirement], [DatePurchased], [PurchasePrice], [StartHrMiles], [NewUsed], [DateSold], [SalePrice], [DatePriced], [SoldInfo], [HourlyCost], [HourlyRate], [MonthlyTarget], [MonthlyPayment], [GlAcctTm], [GLAcctBare], [GLAcctOper], [GLAcctDelPickup], [GLAcctPermit], [MeasureCode], [YtdSalesTax], [SalesTaxLife], [PercentAmount], [SplitPercentage], [SplitAmount], [NeedsPickUp], [CheckOverlap], [SpersonCode], [WarrantyExpDate], [Category1], [Category2], [Category3], [BarCode], [SkytelID], [HoursAdjLower], [HoursAdjUpper], [DepreciationValue], [DepStartDate], [DepNextDate], [NoOfMonths], [ResidualValue], [InsureStartDate], [InsurancePeriod], [ResidualInsureAmt], [RedectionAmt], [TransportClass], [HireDate], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [trgFMS_UNITS], [AdditionalInfo1], [AdditionalInfo2], [AdditionalInfo3], [AdditionalInfo4], [AdditionalInfo5], [AdditionalInfo6], [AdditionalInfo7], [AdditionalInfo8], [AdditionalInfo9], [AdditionalInfo10], [AdditionalInfo11], [UpperGPS], [LowerGPS], [UpperGPSID], [LowerGPSID], [CurrentValue], [FuelPerc], [Field1], [Field2], [Field3], [Field4], [Field5], [SplInvComments], [MilesOrKm], [UpperEngSerialNo], [LowerEngSerialNo], [TransSerialNo], [CurrencyCode], [YardCodePL], [HasMeterHrsUp], [HasMeterHrsLo], [HasOdometerMiles], [OwnedOrRent], [StateCode], [RevenueAsOfDate], [Revenue], [LaborExpenses], [PartsExpenses], [VIN], [Chassis], [ManufacturerID], [ApplySMMTax], [Date1], [Date2], [EquipmentID], [AcceleratedTaxPaid], [HeavyMachinery], [TerpEligible], [EquipmentIDUpper], [ExpAcct], [_SourceExtractedAtUTC], [_LoadedAtUTC])
            SELECT
                [UnitCode], [UnitName], [DeptCode], [CompanyCode], [YardCode], [UnitSchedType], [UnitTypeID], [ModelYear], [Capacity], [VehicleMake], [VehicleModel], [UpEngMake], [UpEngModel], [LowEngMake], [LowEngModel], [TransModel], [TransMake], [Status], [InsuranceValue], [Insured], [HourUpper], [DateHrUpper], [HourLower], [DateHrLower], [MilesKM], [DateMilesKM], [License], [LicenseExpiry], [SerialNumber], [TiresType], [AxleType], [FuelName], [Gvm], [VehicleWidthFt], [VehicleWidthIn], [VehicleHeightFt], [VehicleHeightIn], [VehicleLengthFt], [VehicleLengthIn], [VehicleGageFt], [VehicleGageIn], [JibLengthFt], [JibLengthIn], [BoomLength], [Comments], [FuelCapacity], [MastHeight], [LiftHeight], [FreeLift], [ForkLength], [Carriage], [Tires], [ExtCapacity], [Accessories], [Attachment], [RentalRequirement], [DatePurchased], [PurchasePrice], [StartHrMiles], [NewUsed], [DateSold], [SalePrice], [DatePriced], [SoldInfo], [HourlyCost], [HourlyRate], [MonthlyTarget], [MonthlyPayment], [GlAcctTm], [GLAcctBare], [GLAcctOper], [GLAcctDelPickup], [GLAcctPermit], [MeasureCode], [YtdSalesTax], [SalesTaxLife], [PercentAmount], [SplitPercentage], [SplitAmount], [NeedsPickUp], [CheckOverlap], [SpersonCode], [WarrantyExpDate], [Category1], [Category2], [Category3], [BarCode], [SkytelID], [HoursAdjLower], [HoursAdjUpper], [DepreciationValue], [DepStartDate], [DepNextDate], [NoOfMonths], [ResidualValue], [InsureStartDate], [InsurancePeriod], [ResidualInsureAmt], [RedectionAmt], [TransportClass], [HireDate], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [trgFMS_UNITS], [AdditionalInfo1], [AdditionalInfo2], [AdditionalInfo3], [AdditionalInfo4], [AdditionalInfo5], [AdditionalInfo6], [AdditionalInfo7], [AdditionalInfo8], [AdditionalInfo9], [AdditionalInfo10], [AdditionalInfo11], [UpperGPS], [LowerGPS], [UpperGPSID], [LowerGPSID], [CurrentValue], [FuelPerc], [Field1], [Field2], [Field3], [Field4], [Field5], [SplInvComments], [MilesOrKm], [UpperEngSerialNo], [LowerEngSerialNo], [TransSerialNo], [CurrencyCode], [YardCodePL], [HasMeterHrsUp], [HasMeterHrsLo], [HasOdometerMiles], [OwnedOrRent], [StateCode], [RevenueAsOfDate], [Revenue], [LaborExpenses], [PartsExpenses], [VIN], [Chassis], [ManufacturerID], [ApplySMMTax], [Date1], [Date2], [EquipmentID], [AcceleratedTaxPaid], [HeavyMachinery], [TerpEligible], [EquipmentIDUpper], [ExpAcct], @BatchStart, SYSUTCDATETIME()
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
               AND ObjectName = N'FMS_UNITS';
        END

        EXEC sp_releaseapplock @Resource = N'[etl].[usp_Refresh_FMS_UNITS_Full]', @LockOwner = N'Session';
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK TRANSACTION;

        EXEC sp_releaseapplock @Resource = N'[etl].[usp_Refresh_FMS_UNITS_Full]', @LockOwner = N'Session';

        DECLARE
            @ErrLine int = ERROR_LINE(),
            @ErrMsg  nvarchar(4000) = ERROR_MESSAGE(),
            @ThrowMsg nvarchar(2048);

        SET @ThrowMsg = LEFT(CONCAT(N'[etl].[usp_Refresh_FMS_UNITS_Full] failed (line ', @ErrLine, N'): ', @ErrMsg), 2048);
        THROW 51000, @ThrowMsg, 1;
    END CATCH
END;
