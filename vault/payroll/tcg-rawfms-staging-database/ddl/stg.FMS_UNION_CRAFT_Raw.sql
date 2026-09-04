-- TCG_RawFMS.stg.FMS_UNION_CRAFT_Raw  rows=53  columns=14
CREATE TABLE [stg].[FMS_UNION_CRAFT_Raw] (
    [UnioncraftID] int NOT NULL,
    [UnionCode] varchar(10) NULL,
    [CraftCode] varchar(10) NOT NULL,
    [PayRate] numeric(12,3) NOT NULL,
    [BillingRate] numeric(12,3) NOT NULL,
    [Comments] varchar(max) NULL,
    [CreatedBy] varchar(20) NULL,
    [CreatedDate] datetime2(7) NULL,
    [ModifiedBy] varchar(20) NULL,
    [ModifiedDate] datetime2(7) NULL,
    [StartDate] datetime2(7) NULL,
    [EndDate] datetime2(7) NULL,
    [_SourceExtractedAtUTC] datetime2(0) NOT NULL,
    [_LoadedAtUTC] datetime2(0) NOT NULL
);
-- PRIMARY KEY PK_FMS_UNION_CRAFT_Raw CLUSTERED (UnioncraftID)
