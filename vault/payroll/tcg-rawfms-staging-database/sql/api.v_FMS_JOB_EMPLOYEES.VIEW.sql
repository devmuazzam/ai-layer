CREATE   VIEW [api].[v_FMS_JOB_EMPLOYEES]
AS
SELECT [JobEmpID], [EmpTypeID], [EmpID], [JobCode], [DateStart], [DateEnd], [TimeStart], [TimeEnd], [CraftCode], [Comments], [BillingRate], [TalkedTo], [UnitCode], [LineNumb], [GroupNumb], [Status], [LoadNo], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [EmpDownCode], [JobEmpStatus], [PrimaryResource], [_SourceExtractedAtUTC], [_LoadedAtUTC]
FROM [stg].[FMS_JOB_EMPLOYEES_Raw];
