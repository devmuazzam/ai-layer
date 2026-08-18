
/* ============================================================
   35D - Add Job Ticket Status Tests to Current Payroll Checkpoint

   SAFE CHANGE:
     Updates test.usp_RunAll_CurrentPayrollRegression_Checkpoint
     so Job Ticket Status is included in the known-good suite.

   No payroll math changes.
   ============================================================ */

CREATE   PROCEDURE test.usp_RunAll_CurrentPayrollRegression_Checkpoint
AS
BEGIN
    SET NOCOUNT ON;

    PRINT '1. Core payroll scenario baseline';
    EXEC test.usp_Run_CorePayrollScenario_Baseline
        @ShowDetail = 0;

    PRINT '2. Time-source consistency';
    EXEC test.usp_Run_TimeSourceConsistency_Tests;

    PRINT '3. Slice-view alignment';
    EXEC test.usp_Run_SliceViewAlignment_Tests;

    PRINT '4. Boom breakdown';
    EXEC test.usp_Run_BoomBreakdown_Tests;

    PRINT '5. Labor Entry UI display readiness';
    EXEC test.usp_Run_LaborEntryUIDisplay_Readiness_Tests;

    PRINT '6. Job Ticket Status';
    EXEC test.usp_Run_JobTicketStatus_Tests
        @ShowDetail = 0;

    PRINT 'Current payroll regression checkpoint completed.';
END;
