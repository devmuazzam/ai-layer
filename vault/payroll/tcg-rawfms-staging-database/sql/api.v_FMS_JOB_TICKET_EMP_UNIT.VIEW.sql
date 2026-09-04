CREATE   VIEW [api].[v_FMS_JOB_TICKET_EMP_UNIT]
AS
SELECT [JobTicketEmpUnitID], [JobTicketID], [JobCode], [JobUnitID], [UnitCode], [JobEmpID], [EmpID], [GroupNumb], [Downloaded], [PrimaryEmp], [Comments], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [Viewed], [HoursUtilized], [WorkDescription], [EquipRequired], [JobComments], [LiftBack], [LiftUp], [LiftIn], [LiftPieces], [TotalWeight], [DistanceHauled], [HeaviestPick], [SrtBackFrBlg], [Radius], [Height], [TruckingLength], [TruckingWidth], [TruckingHeight], [TruckingPieces], [TruckingTotalWt], [JobUnitComments], [JobOperComments], [JobOilerComments], [HookReady], [ComponentCode], [JobComponentID], [SpecificationComments], [_SourceExtractedAtUTC], [_LoadedAtUTC]
FROM [stg].[FMS_JOB_TICKET_EMP_UNIT_Raw];
