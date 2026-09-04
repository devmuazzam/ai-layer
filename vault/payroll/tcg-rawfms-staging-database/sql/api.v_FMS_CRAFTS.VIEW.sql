CREATE   VIEW [api].[v_FMS_CRAFTS]
AS
SELECT [CraftCode], [Description], [PayType], [PromptText], [BurdenYN], [WCYN], [UnionYN], [AcctPayType], [Billable], [Status], [GLAcctCode], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [trgFMS_CRAFTS], [AcctIntCode], [PayTypeOrder], [Earnings], [EarningsType], [ExemptApprentice], [_SourceExtractedAtUTC], [_LoadedAtUTC]
FROM [stg].[FMS_CRAFTS_Raw];
