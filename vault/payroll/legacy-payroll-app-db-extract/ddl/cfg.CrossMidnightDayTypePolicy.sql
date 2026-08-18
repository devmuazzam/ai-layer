CREATE TABLE [cfg].[CrossMidnightDayTypePolicy] (
    [PolicyCode] varchar(20) NOT NULL,
    [PolicyName] varchar(100) NOT NULL,
    [IsActive] bit NOT NULL CONSTRAINT [DF_CrossMidnightDayTypePolicy_IsActive] DEFAULT ((0)),
    [Notes] varchar(300) NULL
);

ALTER TABLE [cfg].[CrossMidnightDayTypePolicy] ADD CONSTRAINT [PK_CrossMidnightDayTypePolicy] PRIMARY KEY CLUSTERED ([PolicyCode]);
