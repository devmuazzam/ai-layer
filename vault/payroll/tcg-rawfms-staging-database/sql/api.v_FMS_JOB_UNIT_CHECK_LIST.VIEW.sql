CREATE   VIEW [api].[v_FMS_JOB_UNIT_CHECK_LIST]
AS
SELECT [JobUnitCheckListID], [JobTicketID], [JobCode], [UnitCode], [CheckList], [LineNumb], [Type], [Checked], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [NotApplicable], [CheckedBy], [JobLemID], [CheckListID], [Sections], [SortNumb], [JobOrUnit], [Deficiency], [ConvertedWoCode], [AssignedActivity], [DeficiencyCode], [NoRepair], [RepairCheckedBy], [RepairCheckedDate], [OpenActivityCode], [RepairUnCheckedBy], [RepairUnCheckedDate], [DeficiencyReportedDate], [RequireComments], [ComponentCode], [ResourceCheckListAssignID], [_SourceExtractedAtUTC], [_LoadedAtUTC]
FROM [stg].[FMS_JOB_UNIT_CHECK_LIST_Raw];
