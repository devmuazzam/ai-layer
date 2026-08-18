CREATE TABLE [cfg].[LaborType_TicketPolicy] (
    [LaborType] varchar(20) NOT NULL,
    [Is_AtomLabor] bit NOT NULL,
    [TicketExpectation] varchar(12) NOT NULL,
    [Notes] varchar(200) NULL
);

ALTER TABLE [cfg].[LaborType_TicketPolicy] ADD CONSTRAINT [PK_LaborType_TicketPolicy] PRIMARY KEY CLUSTERED ([LaborType], [Is_AtomLabor]);
ALTER TABLE [cfg].[LaborType_TicketPolicy] ADD CONSTRAINT [CK_LaborType_TicketPolicy_Expectation] CHECK ([TicketExpectation]='NotExpected' OR [TicketExpectation]='Optional' OR [TicketExpectation]='Expected');
