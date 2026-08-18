
CREATE   PROCEDURE api.usp_UI_SaveEmployeeExternalIdentifier
    @EmpID varchar(50),
    @ExternalIdentifierValue varchar(100),
    @Notes varchar(500) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @ExternalSystemCode varchar(50) = 'ADP';
    DECLARE @ExternalIdentifierName varchar(100) = 'FILE_NUMBER';

    DECLARE @EmpID_Clean varchar(50) =
        NULLIF(LTRIM(RTRIM(@EmpID)), '');

    DECLARE @Value_Clean varchar(100) =
        UPPER(NULLIF(LTRIM(RTRIM(@ExternalIdentifierValue)), ''));

    IF @EmpID_Clean IS NULL
    BEGIN
        THROW 51000, 'Employee ID is required.', 1;
    END;

    IF NOT EXISTS (
        SELECT 1
        FROM src.FMS_EMPLOYEES_Raw e
        WHERE e.EmpID = @EmpID_Clean
    )
    BEGIN
        THROW 51001, 'Employee does not exist in FCC employee master.', 1;
    END;

    IF @Value_Clean IS NULL
    BEGIN
        THROW 51002, 'ADP File Number is required.', 1;
    END;

    IF LEN(@Value_Clean) > 6
    BEGIN
        THROW 51003, 'ADP File Number must be 1 to 6 characters.', 1;
    END;

    IF @Value_Clean COLLATE Latin1_General_BIN2 LIKE '%[^0-9A-Z]%'
    BEGIN
        THROW 51004, 'ADP File Number must contain only uppercase letters and numbers.', 1;
    END;

    /* Enhanced duplicate check with employee name */
    IF EXISTS (
        SELECT 1
        FROM app.EmployeeExternalIdentifier x
        WHERE x.IsActive = 1
          AND x.ExternalSystemCode = @ExternalSystemCode
          AND x.ExternalIdentifierName = @ExternalIdentifierName
          AND x.ExternalIdentifierValue = @Value_Clean
          AND x.EmpID <> @EmpID_Clean
    )
    BEGIN
        DECLARE @DuplicateEmpID varchar(50);
        DECLARE @DuplicateEmployeeName varchar(200);
        DECLARE @DuplicateMessage nvarchar(2048);

        SELECT TOP (1)
            @DuplicateEmpID = x.EmpID,
            @DuplicateEmployeeName =
                NULLIF(
                    LTRIM(RTRIM(
                        CONCAT(
                            ISNULL(NULLIF(LTRIM(RTRIM(e.LName)), ''), ''),
                            CASE
                                WHEN NULLIF(LTRIM(RTRIM(e.LName)), '') IS NOT NULL
                                 AND NULLIF(LTRIM(RTRIM(e.FName)), '') IS NOT NULL
                                    THEN ', '
                                ELSE ''
                            END,
                            ISNULL(NULLIF(LTRIM(RTRIM(e.FName)), ''), '')
                        )
                    )),
                    ''
                )
        FROM app.EmployeeExternalIdentifier x
        LEFT JOIN src.FMS_EMPLOYEES_Raw e
            ON e.EmpID = x.EmpID
        WHERE x.IsActive = 1
          AND x.ExternalSystemCode = @ExternalSystemCode
          AND x.ExternalIdentifierName = @ExternalIdentifierName
          AND x.ExternalIdentifierValue = @Value_Clean
          AND x.EmpID <> @EmpID_Clean
        ORDER BY x.EmployeeExternalIdentifierID;

        SET @DuplicateEmployeeName = COALESCE(@DuplicateEmployeeName, 'EmpID ' + COALESCE(@DuplicateEmpID, 'unknown'));

        SET @DuplicateMessage =
            CONCAT(
                'ADP File Number ',
                @Value_Clean,
                ' is already assigned to ',
                @DuplicateEmployeeName,
                ' (EmpID ',
                COALESCE(@DuplicateEmpID, 'unknown'),
                ').'
            );

        THROW 51005, @DuplicateMessage, 1;
    END;

    BEGIN TRANSACTION;

        UPDATE app.EmployeeExternalIdentifier
        SET
            IsActive = 0,
            UpdatedAtUTC = SYSUTCDATETIME()
        WHERE EmpID = @EmpID_Clean
          AND ExternalSystemCode = @ExternalSystemCode
          AND ExternalIdentifierName = @ExternalIdentifierName
          AND IsActive = 1
          AND ISNULL(ExternalIdentifierValue, '') <> @Value_Clean;

        IF EXISTS (
            SELECT 1
            FROM app.EmployeeExternalIdentifier
            WHERE EmpID = @EmpID_Clean
              AND ExternalSystemCode = @ExternalSystemCode
              AND ExternalIdentifierName = @ExternalIdentifierName
              AND IsActive = 1
              AND ExternalIdentifierValue = @Value_Clean
        )
        BEGIN
            UPDATE app.EmployeeExternalIdentifier
            SET
                Notes = @Notes,
                UpdatedAtUTC = SYSUTCDATETIME()
            WHERE EmpID = @EmpID_Clean
              AND ExternalSystemCode = @ExternalSystemCode
              AND ExternalIdentifierName = @ExternalIdentifierName
              AND IsActive = 1
              AND ExternalIdentifierValue = @Value_Clean;
        END
        ELSE
        BEGIN
            INSERT app.EmployeeExternalIdentifier
            (
                EmpID,
                ExternalSystemCode,
                ExternalIdentifierName,
                ExternalIdentifierValue,
                IsActive,
                Notes,
                CreatedAtUTC,
                UpdatedAtUTC
            )
            VALUES
            (
                @EmpID_Clean,
                @ExternalSystemCode,
                @ExternalIdentifierName,
                @Value_Clean,
                1,
                @Notes,
                SYSUTCDATETIME(),
                SYSUTCDATETIME()
            );
        END;

    COMMIT TRANSACTION;

    SELECT
        ok = CAST(1 AS bit),
        EmpID = @EmpID_Clean,
        ExternalSystemCode = @ExternalSystemCode,
        ExternalIdentifierName = @ExternalIdentifierName,
        ADP_FileNumber = @Value_Clean,
        message = 'ADP File Number saved.';
END;
