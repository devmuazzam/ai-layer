
CREATE   PROCEDURE app.usp_Set_LaborBreakOverride
      @LaborPayrollID        int
    , @Breaks_NotTaken_Count tinyint = NULL
    , @Notes                 nvarchar(500) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    -- normalize notes
    SET @Notes = NULLIF(LTRIM(RTRIM(@Notes)), '');

    IF @Breaks_NotTaken_Count IS NOT NULL AND (@Breaks_NotTaken_Count < 0 OR @Breaks_NotTaken_Count > 9)
        THROW 50000, 'Breaks_NotTaken_Count must be NULL or between 0 and 9.', 1;

    -- If they set both to NULL, treat it as "clear"
    IF @Breaks_NotTaken_Count IS NULL AND @Notes IS NULL
    BEGIN
        DELETE FROM app.LaborBreakOverride WHERE LaborPayrollID = @LaborPayrollID;
        RETURN;
    END

    MERGE app.LaborBreakOverride AS tgt
    USING (SELECT @LaborPayrollID AS LaborPayrollID) AS src
        ON tgt.LaborPayrollID = src.LaborPayrollID
    WHEN MATCHED THEN
        UPDATE SET
            Breaks_NotTaken_Count = @Breaks_NotTaken_Count,
            Notes                 = @Notes,
            UpdatedAt             = SYSUTCDATETIME(),
            UpdatedBy             = ORIGINAL_LOGIN()
    WHEN NOT MATCHED THEN
        INSERT (LaborPayrollID, Breaks_NotTaken_Count, Notes)
        VALUES (@LaborPayrollID, @Breaks_NotTaken_Count, @Notes);
END
