
/* ============================================================
   2) RebuildSynonyms (fix defaults + add TRY/CATCH + quiet mode)
   - Defaults: TargetSchema=src, DoIt=1, Quiet=1
   ============================================================ */
CREATE   PROCEDURE [etl].[usp_RebuildSynonyms_RawFMS]
      @SourceDb       sysname        = N'TCG_RawFMS'
    , @SourceSchema   sysname        = N'api'
    , @TargetSchema   sysname        = N'src'         -- IMPORTANT: matches app proc references (src.*)
    , @ViewLike       nvarchar(128)  = N'v[_]FMS[_]%' -- matches v_FMS_* views
    , @SynSuffix      sysname        = N'_Raw'        -- synonym naming convention
    , @DoIt           bit            = 1              -- 0=preview, 1=execute
    , @Quiet          bit            = 1              -- 1=suppress per-syn output (nightly-friendly)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @ThisDb sysname = DB_NAME();

    BEGIN TRY
        IF SCHEMA_ID(@TargetSchema) IS NULL
        BEGIN
            DECLARE @mk nvarchar(4000) = N'CREATE SCHEMA ' + QUOTENAME(@TargetSchema) + N' AUTHORIZATION dbo;';
            EXEC sys.sp_executesql @mk;
        END

        CREATE TABLE #Views (ViewName sysname NOT NULL);

        DECLARE @sql nvarchar(max) =
            N'INSERT INTO #Views(ViewName)
              SELECT v.name
              FROM ' + QUOTENAME(@SourceDb) + N'.sys.views v
              JOIN ' + QUOTENAME(@SourceDb) + N'.sys.schemas s ON s.schema_id = v.schema_id
              WHERE s.name = @pSourceSchema
                AND v.name LIKE @pViewLike;';

        EXEC sys.sp_executesql
            @sql,
            N'@pSourceSchema sysname, @pViewLike nvarchar(128)',
            @pSourceSchema = @SourceSchema,
            @pViewLike     = @ViewLike;

        DECLARE
            @ViewName sysname,
            @SynName  sysname,
            @Drop     nvarchar(max),
            @Create   nvarchar(max),
            @Base     nvarchar(512);

        DECLARE cur CURSOR LOCAL FAST_FORWARD FOR
            SELECT ViewName FROM #Views ORDER BY ViewName;

        OPEN cur;
        FETCH NEXT FROM cur INTO @ViewName;

        WHILE @@FETCH_STATUS = 0
        BEGIN
            SET @SynName =
                CASE WHEN LEFT(@ViewName, 2) = N'v_' THEN SUBSTRING(@ViewName, 3, 256) ELSE @ViewName END
                + @SynSuffix;

            SET @Base =
                QUOTENAME(@SourceDb) + N'.' + QUOTENAME(@SourceSchema) + N'.' + QUOTENAME(@ViewName);

            SET @Drop =
                N'IF OBJECT_ID(N''' + @TargetSchema + N'.' + @SynName + N''', N''SN'') IS NOT NULL
                    DROP SYNONYM ' + QUOTENAME(@TargetSchema) + N'.' + QUOTENAME(@SynName) + N';';

            SET @Create =
                N'CREATE SYNONYM ' + QUOTENAME(@TargetSchema) + N'.' + QUOTENAME(@SynName) + N'
                  FOR ' + @Base + N';';

            IF @DoIt = 0
            BEGIN
                IF @Quiet = 0
                BEGIN
                    SELECT
                        Action     = N'PREVIEW',
                        SynonymName= QUOTENAME(@TargetSchema) + N'.' + QUOTENAME(@SynName),
                        BaseObject = @Base,
                        DropSql    = @Drop,
                        CreateSql  = @Create;
                END
            END
            ELSE
            BEGIN
                EXEC sys.sp_executesql @Drop;
                EXEC sys.sp_executesql @Create;

                IF @Quiet = 0
                    PRINT N'OK ' + QUOTENAME(@TargetSchema) + N'.' + QUOTENAME(@SynName) + N' -> ' + @Base;
            END

            FETCH NEXT FROM cur INTO @ViewName;
        END

        CLOSE cur;
        DEALLOCATE cur;

        IF @Quiet = 0
        BEGIN
            SELECT
                schema_name(schema_id) AS SynSchema,
                name AS SynonymName,
                base_object_name
            FROM sys.synonyms
            WHERE schema_name(schema_id) = @TargetSchema
              AND name LIKE N'FMS%'+ @SynSuffix
            ORDER BY SynonymName;
        END
    END TRY
    BEGIN CATCH
        DECLARE @Err nvarchar(max) =
            CONCAT('RebuildSynonyms error ', ERROR_NUMBER(), ' (', ERROR_SEVERITY(), '/', ERROR_STATE(),
                   ') at line ', ERROR_LINE(), ': ', ERROR_MESSAGE());

        RAISERROR(@Err, 16, 1);
        RETURN 1;
    END CATCH

    RETURN 0;
END
