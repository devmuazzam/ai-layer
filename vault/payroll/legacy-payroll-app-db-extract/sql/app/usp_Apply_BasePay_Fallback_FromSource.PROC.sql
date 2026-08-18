
/* ============================================================
   51K-B - Patch app.usp_Apply_BasePay_Fallback_FromSource
   Purpose:
   - Keep procedure as safety net only.
   - Use Source_Rate_Raw only.
   - Do NOT fill from CraftPayRate.
   - Do NOT fill from Source_Amount_Raw / HoursWorked_Raw.
   ============================================================ */

CREATE   PROCEDURE [app].[usp_Apply_BasePay_Fallback_FromSource]
    @WorkDateFrom date = NULL,
    @WorkDateTo   date = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @FromDT datetime2(0) = CONVERT(datetime2(0), COALESCE(@WorkDateFrom, '19000101'));
    DECLARE @ToExDT datetime2(0) = DATEADD(DAY, 1, CONVERT(datetime2(0), COALESCE(@WorkDateTo, '99991231')));

    ;WITH x AS
    (
        SELECT
            pc.LaborPayrollID,
            pc.Pay_Actual_Gross AS OldPay,
            pc.Final_Gross_Pay  AS OldFinal,

            WeightedHrs =
                CONVERT(decimal(19,4),
                    ISNULL(pc.Hrs_ST, 0.0)
                  + 1.5 * ISNULL(pc.Hrs_OT, 0.0)
                  + 2.0 * ISNULL(pc.Hrs_DT, 0.0)
                ),

            EffRate =
                NULLIF(CONVERT(decimal(19,6), ISNULL(blp.Source_Rate_Raw, 0.0)), 0.0)

        FROM fms.Payroll_Calculated pc
        LEFT JOIN app.v_Base_LaborPayroll blp
            ON blp.LaborPayrollID = pc.LaborPayrollID
        WHERE pc.WorkDate >= @FromDT
          AND pc.WorkDate <  @ToExDT
          AND ISNULL(pc.Pay_Actual_Gross, 0.0) = 0.0
          AND (ISNULL(pc.Hrs_ST, 0.0) + ISNULL(pc.Hrs_OT, 0.0) + ISNULL(pc.Hrs_DT, 0.0)) > 0.0
    ),
    calc AS
    (
        SELECT
            LaborPayrollID,
            OldPay,
            NewPay =
                CASE
                    WHEN EffRate IS NOT NULL AND EffRate > 0 AND WeightedHrs > 0
                        THEN CONVERT(decimal(19,4), EffRate * WeightedHrs)
                    ELSE CONVERT(decimal(19,4), 0.0)
                END
        FROM x
    )
    UPDATE pc
       SET pc.Pay_Actual_Gross = c.NewPay,
           pc.Final_Gross_Pay  = pc.Final_Gross_Pay + (c.NewPay - ISNULL(pc.Pay_Actual_Gross, 0.0))
    FROM fms.Payroll_Calculated pc
    JOIN calc c
        ON c.LaborPayrollID = pc.LaborPayrollID
    WHERE c.NewPay > 0;

    DECLARE @Fixed int =
    (
        SELECT COUNT(*)
        FROM fms.Payroll_Calculated pc
        WHERE pc.WorkDate >= @FromDT
          AND pc.WorkDate < @ToExDT
          AND ISNULL(pc.Pay_Actual_Gross, 0.0) > 0
    );

    PRINT CONCAT('Source_Rate_Raw-only base-pay fallback complete. Rows with positive actual pay in range: ', @Fixed);
END;
