CREATE   VIEW [api].[v_FMS_TERMS]
AS
SELECT [TermID], [TermName], [DaysDiscount], [DateDiscount], [DayDue], [DateDue], [DiscPer], [AcctTermsCode], [Status], [ShowTerms], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [trgFMS_TERMS], [EOM], [_SourceExtractedAtUTC], [_LoadedAtUTC]
FROM [stg].[FMS_TERMS_Raw];
