
CREATE   PROCEDURE app.usp_Clear_LaborBreakOverride
      @LaborPayrollID int
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM app.LaborBreakOverride
    WHERE LaborPayrollID = @LaborPayrollID;
END
