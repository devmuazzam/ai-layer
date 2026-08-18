CREATE TABLE [dim].[LU12_Holiday] (
    [LU12_HolidayID] int IDENTITY(1,1) NOT NULL,
    [Date] date NOT NULL,
    [HolidayName] nvarchar(100) NOT NULL,
    [PayRateMultiplier] decimal(4,2) NOT NULL,
    [IsWorkRestricted] bit NULL CONSTRAINT [DF_dim_LU12_Holiday_IsWorkRestricted] DEFAULT ((0)),
    [RuleApplied] nvarchar(255) NULL
);

ALTER TABLE [dim].[LU12_Holiday] ADD CONSTRAINT [PK_dim_LU12_Holiday] PRIMARY KEY CLUSTERED ([LU12_HolidayID]);
