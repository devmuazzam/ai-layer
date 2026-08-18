
/* ============================================================
   51N-C - Suppress calculated pay when Source_Rate_Raw is missing
   Purpose:
   - Final cleanup step after pricing/guarantee/rest procedures.
   - If Source_Rate_Raw is missing:
       Pay_Actual_Gross = 0
       Pay_Gap_Add = 0
       Pay_Rest_Add = 0
       Final_Gross_Pay = 0
   - Keeps hours/buckets for review visibility.
   ============================================================ */

CREATE   PROCEDURE app.usp_SuppressPay_WhenSourceRateMissing
    @WorkDateFrom date = NULL,
    @WorkDateTo   date = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @FromDT datetime2(0) = CONVERT(datetime2(0), COALESCE(@WorkDateFrom, '19000101'));
    DECLARE @ToExDT datetime2(0) = DATEADD(DAY, 1, CONVERT(datetime2(0), COALESCE(@WorkDateTo, '99991231')));

    UPDATE pc
       SET Pay_Actual_Gross = CONVERT(decimal(12,2), 0.00),
           Pay_Gap_Add      = CONVERT(decimal(12,2), 0.00),
           Pay_Rest_Add     = CONVERT(decimal(19,4), 0.0000),
           Final_Gross_Pay  = CONVERT(decimal(12,2), 0.00)
    FROM fms.Payroll_Calculated pc
    JOIN app.v_Base_LaborPayroll b
        ON b.LaborPayrollID = pc.LaborPayrollID
    WHERE pc.WorkDate >= @FromDT
      AND pc.WorkDate <  @ToExDT
      AND ISNULL(pc.Act_Total_Hrs, 0) > 0
      AND NULLIF(CONVERT(decimal(19,6), ISNULL(b.Source_Rate_Raw, 0.0)), 0.0) IS NULL
      AND
      (
            ISNULL(pc.Pay_Actual_Gross, 0) <> 0
         OR ISNULL(pc.Pay_Gap_Add, 0) <> 0
         OR ISNULL(pc.Pay_Rest_Add, 0) <> 0
         OR ISNULL(pc.Final_Gross_Pay, 0) <> 0
      );

    PRINT CONCAT('Suppressed pay for missing Source_Rate_Raw rows: ', @@ROWCOUNT);
END;
