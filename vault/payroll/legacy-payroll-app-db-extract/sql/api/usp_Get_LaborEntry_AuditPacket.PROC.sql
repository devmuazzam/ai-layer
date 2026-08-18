
CREATE   PROCEDURE api.usp_Get_LaborEntry_AuditPacket
      @JobCode           varchar(30) = NULL
    , @JobTicketID       int         = NULL
    , @LaborPayrollID    int         = NULL
    , @WorkDateFrom      date        = NULL
    , @WorkDateTo        date        = NULL
    , @MaxEntries        int         = 200
    , @IncludeSlices     bit         = 0
    , @IncludeMaster     bit         = 0
    , @DebugProgress     bit         = 0
    , @ReadUncommitted   bit         = 1

    -- NEW: choose which slice view to return
    , @SliceDetailLevel  varchar(10) = 'UI'   -- UI | ADV
AS
BEGIN
    SET NOCOUNT ON;

    IF @ReadUncommitted = 1
        SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

    SET LOCK_TIMEOUT 10000;

    IF @JobCode IS NULL AND @JobTicketID IS NULL AND @LaborPayrollID IS NULL
        THROW 51010, 'Provide at least one filter: @JobCode or @JobTicketID or @LaborPayrollID.', 1;

    IF @MaxEntries IS NULL OR @MaxEntries < 1 OR @MaxEntries > 5000
        SET @MaxEntries = 200;

    IF OBJECT_ID('tempdb..#LP') IS NOT NULL DROP TABLE #LP;
    CREATE TABLE #LP (LaborPayrollID int NOT NULL PRIMARY KEY);

    IF @DebugProgress = 1 RAISERROR('AuditPack: building LP list...',0,1) WITH NOWAIT;

    DECLARE @q nvarchar(max) = N'
        INSERT INTO #LP (LaborPayrollID)
        SELECT TOP (@MaxEntries) P.LaborPayrollID
        FROM fms.Payroll_Calculated P
        WHERE 1=1
          ' + CASE WHEN @LaborPayrollID IS NOT NULL THEN N' AND P.LaborPayrollID = @LaborPayrollID' ELSE N'' END + N'
          ' + CASE WHEN @JobTicketID    IS NOT NULL THEN N' AND P.JobTicketID    = @JobTicketID'    ELSE N'' END + N'
          ' + CASE WHEN @JobCode        IS NOT NULL THEN N' AND P.JobCode        = @JobCode'        ELSE N'' END + N'
          ' + CASE WHEN @WorkDateFrom   IS NOT NULL THEN N' AND P.WorkDate >= @WorkDateFrom'        ELSE N'' END + N'
          ' + CASE WHEN @WorkDateTo     IS NOT NULL THEN N' AND P.WorkDate <  DATEADD(DAY,1,@WorkDateTo)' ELSE N'' END + N'
        ORDER BY P.WorkDate DESC, P.LaborPayrollID DESC;';

    EXEC sys.sp_executesql
        @q,
        N'@MaxEntries int, @LaborPayrollID int, @JobTicketID int, @JobCode varchar(30), @WorkDateFrom date, @WorkDateTo date',
        @MaxEntries, @LaborPayrollID, @JobTicketID, @JobCode, @WorkDateFrom, @WorkDateTo;

    /* 1) HEADER */
    IF @DebugProgress = 1 RAISERROR('AuditPack: returning HEADER...',0,1) WITH NOWAIT;

    SELECT H.*
    FROM api.v_LaborEntry_AuditHeader H
    JOIN #LP L ON L.LaborPayrollID = H.LaborPayrollID
    ORDER BY H.WorkDate DESC, H.LaborPayrollID DESC
    OPTION (RECOMPILE);

    /* 2) DETAIL AGG (existing) */
    IF @IncludeSlices = 1
    BEGIN
        IF @DebugProgress = 1 RAISERROR('AuditPack: returning DETAIL AGG...',0,1) WITH NOWAIT;

        SELECT D.*
        FROM api.v_Calc_Pricing_Detailed D
        JOIN #LP L ON L.LaborPayrollID = D.LaborPayrollID
        ORDER BY D.LaborPayrollID
        OPTION (RECOMPILE);
    END
    ELSE
        SELECT CAST(NULL AS int) AS LaborPayrollID, CAST(NULL AS varchar(200)) AS Note WHERE 1=0;

    /* 3) SLICE ROWS (UI by default) */
    IF @IncludeSlices = 1
    BEGIN
        IF @DebugProgress = 1 RAISERROR('AuditPack: returning SLICE ROWS...',0,1) WITH NOWAIT;

        IF UPPER(@SliceDetailLevel) IN ('ADV','ADVANCED')
        BEGIN
            SELECT S.*
            FROM api.v_UI_Pricing_Slices_Advanced S
            JOIN #LP L ON L.LaborPayrollID = S.LaborPayrollID
            ORDER BY S.LaborPayrollID, S.Slice_Start
            OPTION (RECOMPILE);
        END
        ELSE
        BEGIN
            SELECT S.*
            FROM api.v_UI_Pricing_Slices S
            JOIN #LP L ON L.LaborPayrollID = S.LaborPayrollID
            ORDER BY S.LaborPayrollID, S.Slice_Start
            OPTION (RECOMPILE);
        END
    END
    ELSE
        SELECT CAST(NULL AS int) AS LaborPayrollID, CAST(NULL AS varchar(200)) AS Note WHERE 1=0;

    /* 4) MASTER AUDIT */
    IF @IncludeMaster = 1
    BEGIN
        IF @DebugProgress = 1 RAISERROR('AuditPack: returning MASTER AUDIT...',0,1) WITH NOWAIT;

        SELECT M.*
        FROM calc.v_Calc_Pricing_Master_Audit M
        JOIN #LP L ON L.LaborPayrollID = M.LaborPayrollID
        ORDER BY M.LaborPayrollID
        OPTION (RECOMPILE);
    END
    ELSE
        SELECT CAST(NULL AS int) AS LaborPayrollID, CAST(NULL AS varchar(200)) AS Note WHERE 1=0;
END
