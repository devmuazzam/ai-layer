
CREATE   FUNCTION [dbo].[fn_StripRTF]
(
    @rtf NVARCHAR(MAX)
)
RETURNS NVARCHAR(MAX)
WITH RETURNS NULL ON NULL INPUT
AS
BEGIN
    -- Fast exits
    IF @rtf IS NULL RETURN NULL;
    IF LEN(@rtf) = 0 RETURN N'';
    IF LEFT(LTRIM(@rtf), 1) <> N'{' RETURN LTRIM(RTRIM(@rtf));

    DECLARE @Stage NVARCHAR(MAX) = @rtf;

    DECLARE @bs NCHAR(1) = NCHAR(92); -- '\'
    DECLARE @idx INT, @searchPos INT, @braceCount INT;

    -- Placeholders to preserve literal braces/backslash (from \{ \} \\)
    DECLARE @PH_OB NCHAR(1) = NCHAR(0xE001); -- private use
    DECLARE @PH_CB NCHAR(1) = NCHAR(0xE002);
    DECLARE @PH_BS NCHAR(1) = NCHAR(0xE003);

    /* ============================================================
       STEP 1: Remove whole groups we never want to render
       - Known metadata tables
       - Pictures/objects
       - Any ignorable destination group: {\* ...}
       ============================================================ */
    DECLARE @Kill TABLE (KillID INT IDENTITY(1,1), Tag NVARCHAR(40) NOT NULL);
    INSERT INTO @Kill(Tag) VALUES
        (N'{' + @bs + N'fonttbl'),
        (N'{' + @bs + N'colortbl'),
        (N'{' + @bs + N'stylesheet'),
        (N'{' + @bs + N'info'),
        (N'{' + @bs + N'pict'),
        (N'{' + @bs + N'object'),
        (N'{' + @bs + N'*');          -- ignorable destination

    DECLARE @k INT = 1, @kmax INT = (SELECT MAX(KillID) FROM @Kill);
    DECLARE @TagToKill NVARCHAR(40);

    WHILE @k <= ISNULL(@kmax, 0)
    BEGIN
        SELECT @TagToKill = Tag FROM @Kill WHERE KillID = @k;

        WHILE CHARINDEX(@TagToKill, @Stage) > 0
        BEGIN
            SET @idx = CHARINDEX(@TagToKill, @Stage);
            SET @braceCount = 1;
            SET @searchPos = @idx + LEN(@TagToKill);

            WHILE @braceCount > 0 AND @searchPos <= LEN(@Stage)
            BEGIN
                DECLARE @c NCHAR(1) = SUBSTRING(@Stage, @searchPos, 1);
                IF @c = N'{' SET @braceCount += 1;
                ELSE IF @c = N'}' SET @braceCount -= 1;
                SET @searchPos += 1;
            END

            SET @Stage = STUFF(@Stage, @idx, @searchPos - @idx, N'');
        END

        SET @k += 1;
    END

    /* ============================================================
       STEP 2: Strip/convert control sequences
       ============================================================ */
    DECLARE @uc INT = 1; -- default fallback count
    WHILE CHARINDEX(@bs, @Stage) > 0
    BEGIN
        SET @idx = CHARINDEX(@bs, @Stage);

        DECLARE @next NCHAR(1) = SUBSTRING(@Stage, @idx + 1, 1);

        /* --- 2-byte escapes: \\ \{ \} --- */
        IF @next IN (@bs, N'{', N'}')
        BEGIN
            IF @next = @bs
                SET @Stage = STUFF(@Stage, @idx, 2, @PH_BS);
            ELSE IF @next = N'{'
                SET @Stage = STUFF(@Stage, @idx, 2, @PH_OB);
            ELSE
                SET @Stage = STUFF(@Stage, @idx, 2, @PH_CB);

            CONTINUE;
        END

        /* --- Hex escape: \'hh --- */
        IF @next = N''''
        BEGIN
            DECLARE @hh NVARCHAR(2) = SUBSTRING(@Stage, @idx + 2, 2);
            IF @hh LIKE '[0-9A-Fa-f][0-9A-Fa-f]'
            BEGIN
                DECLARE @b INT = CONVERT(INT, CONVERT(VARBINARY(1), '0x' + @hh, 1));
                DECLARE @ch NCHAR(1) =
                    CASE @b
                        WHEN 0x80 THEN NCHAR(0x20AC)
                        WHEN 0x82 THEN NCHAR(0x201A)
                        WHEN 0x83 THEN NCHAR(0x0192)
                        WHEN 0x84 THEN NCHAR(0x201E)
                        WHEN 0x85 THEN NCHAR(0x2026)
                        WHEN 0x86 THEN NCHAR(0x2020)
                        WHEN 0x87 THEN NCHAR(0x2021)
                        WHEN 0x88 THEN NCHAR(0x02C6)
                        WHEN 0x89 THEN NCHAR(0x2030)
                        WHEN 0x8A THEN NCHAR(0x0160)
                        WHEN 0x8B THEN NCHAR(0x2039)
                        WHEN 0x8C THEN NCHAR(0x0152)
                        WHEN 0x8E THEN NCHAR(0x017D)
                        WHEN 0x91 THEN NCHAR(0x2018)
                        WHEN 0x92 THEN NCHAR(0x2019)
                        WHEN 0x93 THEN NCHAR(0x201C)
                        WHEN 0x94 THEN NCHAR(0x201D)
                        WHEN 0x95 THEN NCHAR(0x2022)
                        WHEN 0x96 THEN NCHAR(0x2013)
                        WHEN 0x97 THEN NCHAR(0x2014)
                        WHEN 0x98 THEN NCHAR(0x02DC)
                        WHEN 0x99 THEN NCHAR(0x2122)
                        WHEN 0x9A THEN NCHAR(0x0161)
                        WHEN 0x9B THEN NCHAR(0x203A)
                        WHEN 0x9C THEN NCHAR(0x0153)
                        WHEN 0x9E THEN NCHAR(0x017E)
                        WHEN 0x9F THEN NCHAR(0x0178)
                        ELSE NCHAR(@b)
                    END;

                SET @Stage = STUFF(@Stage, @idx, 4, @ch);
                CONTINUE;
            END
        END

        /* --- Common RTF renderings: require delimiter after keyword --- */
        IF SUBSTRING(@Stage, @idx + 1, 3) = N'par'
           AND (UNICODE(SUBSTRING(@Stage, @idx + 4, 1)) NOT BETWEEN 65 AND 90)
           AND (UNICODE(SUBSTRING(@Stage, @idx + 4, 1)) NOT BETWEEN 97 AND 122)
        BEGIN
            DECLARE @afterPar NCHAR(1) = SUBSTRING(@Stage, @idx + 4, 1);
            IF @afterPar IN (N' ', NCHAR(13), NCHAR(10))
                SET @Stage = STUFF(@Stage, @idx, 5, NCHAR(13) + NCHAR(10));
            ELSE
                SET @Stage = STUFF(@Stage, @idx, 4, NCHAR(13) + NCHAR(10));
            CONTINUE;
        END

        IF SUBSTRING(@Stage, @idx + 1, 4) = N'line'
           AND (UNICODE(SUBSTRING(@Stage, @idx + 5, 1)) NOT BETWEEN 65 AND 90)
           AND (UNICODE(SUBSTRING(@Stage, @idx + 5, 1)) NOT BETWEEN 97 AND 122)
        BEGIN
            DECLARE @afterLine NCHAR(1) = SUBSTRING(@Stage, @idx + 5, 1);
            IF @afterLine IN (N' ', NCHAR(13), NCHAR(10))
                SET @Stage = STUFF(@Stage, @idx, 6, NCHAR(13) + NCHAR(10));
            ELSE
                SET @Stage = STUFF(@Stage, @idx, 5, NCHAR(13) + NCHAR(10));
            CONTINUE;
        END

        IF SUBSTRING(@Stage, @idx + 1, 3) = N'tab'
           AND (UNICODE(SUBSTRING(@Stage, @idx + 4, 1)) NOT BETWEEN 65 AND 90)
           AND (UNICODE(SUBSTRING(@Stage, @idx + 4, 1)) NOT BETWEEN 97 AND 122)
        BEGIN
            SET @Stage = STUFF(@Stage, @idx, 4, NCHAR(9));
            CONTINUE;
        END

        IF SUBSTRING(@Stage, @idx + 1, 4) = N'bull'
           AND (UNICODE(SUBSTRING(@Stage, @idx + 5, 1)) NOT BETWEEN 65 AND 90)
           AND (UNICODE(SUBSTRING(@Stage, @idx + 5, 1)) NOT BETWEEN 97 AND 122)
        BEGIN
            SET @Stage = STUFF(@Stage, @idx, 5, N'•');
            CONTINUE;
        END

        IF SUBSTRING(@Stage, @idx + 1, 6) = N'emdash'
           AND (UNICODE(SUBSTRING(@Stage, @idx + 7, 1)) NOT BETWEEN 65 AND 90)
           AND (UNICODE(SUBSTRING(@Stage, @idx + 7, 1)) NOT BETWEEN 97 AND 122)
        BEGIN
            DECLARE @afterEmDash NCHAR(1) = SUBSTRING(@Stage, @idx + 7, 1);
            IF @afterEmDash = N' '
                SET @Stage = STUFF(@Stage, @idx, 8, NCHAR(0x2014));
            ELSE
                SET @Stage = STUFF(@Stage, @idx, 7, NCHAR(0x2014));
            CONTINUE;
        END

        IF SUBSTRING(@Stage, @idx + 1, 6) = N'endash'
           AND (UNICODE(SUBSTRING(@Stage, @idx + 7, 1)) NOT BETWEEN 65 AND 90)
           AND (UNICODE(SUBSTRING(@Stage, @idx + 7, 1)) NOT BETWEEN 97 AND 122)
        BEGIN
            DECLARE @afterEnDash NCHAR(1) = SUBSTRING(@Stage, @idx + 7, 1);
            IF @afterEnDash = N' '
                SET @Stage = STUFF(@Stage, @idx, 8, NCHAR(0x2013));
            ELSE
                SET @Stage = STUFF(@Stage, @idx, 7, NCHAR(0x2013));
            CONTINUE;
        END

        IF SUBSTRING(@Stage, @idx + 1, 6) = N'lquote'
           AND (UNICODE(SUBSTRING(@Stage, @idx + 7, 1)) NOT BETWEEN 65 AND 90)
           AND (UNICODE(SUBSTRING(@Stage, @idx + 7, 1)) NOT BETWEEN 97 AND 122)
        BEGIN
            DECLARE @afterLQ NCHAR(1) = SUBSTRING(@Stage, @idx + 7, 1);
            IF @afterLQ = N' '
                SET @Stage = STUFF(@Stage, @idx, 8, NCHAR(0x2018));
            ELSE
                SET @Stage = STUFF(@Stage, @idx, 7, NCHAR(0x2018));
            CONTINUE;
        END

        IF SUBSTRING(@Stage, @idx + 1, 6) = N'rquote'
           AND (UNICODE(SUBSTRING(@Stage, @idx + 7, 1)) NOT BETWEEN 65 AND 90)
           AND (UNICODE(SUBSTRING(@Stage, @idx + 7, 1)) NOT BETWEEN 97 AND 122)
        BEGIN
            DECLARE @afterRQ NCHAR(1) = SUBSTRING(@Stage, @idx + 7, 1);
            IF @afterRQ = N' '
                SET @Stage = STUFF(@Stage, @idx, 8, NCHAR(0x2019));
            ELSE
                SET @Stage = STUFF(@Stage, @idx, 7, NCHAR(0x2019));
            CONTINUE;
        END

        IF SUBSTRING(@Stage, @idx + 1, 9) = N'ldblquote'
           AND (UNICODE(SUBSTRING(@Stage, @idx + 10, 1)) NOT BETWEEN 65 AND 90)
           AND (UNICODE(SUBSTRING(@Stage, @idx + 10, 1)) NOT BETWEEN 97 AND 122)
        BEGIN
            DECLARE @afterLDQ NCHAR(1) = SUBSTRING(@Stage, @idx + 10, 1);
            IF @afterLDQ = N' '
                SET @Stage = STUFF(@Stage, @idx, 11, NCHAR(0x201C));
            ELSE
                SET @Stage = STUFF(@Stage, @idx, 10, NCHAR(0x201C));
            CONTINUE;
        END

        IF SUBSTRING(@Stage, @idx + 1, 9) = N'rdblquote'
           AND (UNICODE(SUBSTRING(@Stage, @idx + 10, 1)) NOT BETWEEN 65 AND 90)
           AND (UNICODE(SUBSTRING(@Stage, @idx + 10, 1)) NOT BETWEEN 97 AND 122)
        BEGIN
            DECLARE @afterRDQ NCHAR(1) = SUBSTRING(@Stage, @idx + 10, 1);
            IF @afterRDQ = N' '
                SET @Stage = STUFF(@Stage, @idx, 11, NCHAR(0x201D));
            ELSE
                SET @Stage = STUFF(@Stage, @idx, 10, NCHAR(0x201D));
            CONTINUE;
        END

        IF SUBSTRING(@Stage, @idx + 1, 1) = N'~'
        BEGIN
            SET @Stage = STUFF(@Stage, @idx, 2, N' ');
            CONTINUE;
        END

        /* --- \ucN --- */
        IF SUBSTRING(@Stage, @idx + 1, 2) = N'uc'
        BEGIN
            DECLARE @p INT = @idx + 3;
            DECLARE @num NVARCHAR(10) = N'';

            WHILE SUBSTRING(@Stage, @p, 1) BETWEEN N'0' AND N'9'
            BEGIN
                SET @num += SUBSTRING(@Stage, @p, 1);
                SET @p += 1;
            END

            IF TRY_CONVERT(INT, @num) IS NOT NULL
                SET @uc = TRY_CONVERT(INT, @num);

            IF SUBSTRING(@Stage, @p, 1) = N' ' SET @p += 1;

            SET @Stage = STUFF(@Stage, @idx, @p - @idx, N'');
            CONTINUE;
        END

        /* --- \uN --- */
        IF SUBSTRING(@Stage, @idx + 1, 1) = N'u'
           AND SUBSTRING(@Stage, @idx + 2, 1) IN (N'-', N'0', N'1', N'2', N'3', N'4', N'5', N'6', N'7', N'8', N'9')
        BEGIN
            DECLARE @p2 INT = @idx + 2;
            DECLARE @sign INT = 1;
            IF SUBSTRING(@Stage, @p2, 1) = N'-' BEGIN SET @sign = -1; SET @p2 += 1; END

            DECLARE @num2 NVARCHAR(12) = N'';
            WHILE SUBSTRING(@Stage, @p2, 1) BETWEEN N'0' AND N'9'
            BEGIN
                SET @num2 += SUBSTRING(@Stage, @p2, 1);
                SET @p2 += 1;
            END

            DECLARE @code INT = @sign * TRY_CONVERT(INT, @num2);
            IF @code IS NULL SET @code = 63;

            IF @code < 0 SET @code = @code + 65536;
            IF @code < 0 OR @code > 65535 SET @code = 63;

            DECLARE @uChar NCHAR(1) = NCHAR(@code);

            IF SUBSTRING(@Stage, @p2, 1) = N' ' SET @p2 += 1;

            SET @Stage = STUFF(@Stage, @idx, @p2 - @idx, @uChar);

            DECLARE @skip INT = ISNULL(@uc, 1);
            DECLARE @pos INT = @idx + 1;

            WHILE @skip > 0 AND @pos <= LEN(@Stage)
            BEGIN
                IF SUBSTRING(@Stage, @pos, 1) = @bs
                BEGIN
                    IF SUBSTRING(@Stage, @pos + 1, 1) = N''''
                       AND SUBSTRING(@Stage, @pos + 2, 2) LIKE '[0-9A-Fa-f][0-9A-Fa-f]'
                    BEGIN
                        SET @Stage = STUFF(@Stage, @pos, 4, N'');
                    END
                    ELSE IF SUBSTRING(@Stage, @pos + 1, 1) IN (@bs, N'{', N'}')
                    BEGIN
                        SET @Stage = STUFF(@Stage, @pos, 2, N'');
                    END
                    ELSE
                    BEGIN
                        SET @Stage = STUFF(@Stage, @pos, 1, N'');
                    END
                END
                ELSE
                BEGIN
                    SET @Stage = STUFF(@Stage, @pos, 1, N'');
                END

                SET @skip -= 1;
            END

            CONTINUE;
        END

        /* --- Default: remove a control word --- */
        DECLARE @p3 INT = @idx + 1;

        IF NOT (SUBSTRING(@Stage, @p3, 1) BETWEEN N'A' AND N'Z'
             OR SUBSTRING(@Stage, @p3, 1) BETWEEN N'a' AND N'z')
        BEGIN
            SET @Stage = STUFF(@Stage, @idx, 2, N'');
            CONTINUE;
        END

        WHILE SUBSTRING(@Stage, @p3, 1) BETWEEN N'A' AND N'Z'
           OR SUBSTRING(@Stage, @p3, 1) BETWEEN N'a' AND N'z'
            SET @p3 += 1;

        IF SUBSTRING(@Stage, @p3, 1) = N'-' SET @p3 += 1;
        WHILE SUBSTRING(@Stage, @p3, 1) BETWEEN N'0' AND N'9'
            SET @p3 += 1;

        IF SUBSTRING(@Stage, @p3, 1) = N' ' SET @p3 += 1;

        SET @Stage = STUFF(@Stage, @idx, @p3 - @idx, N'');
    END

    /* ============================================================
       STEP 3: Remove remaining group braces, then restore literals
       ============================================================ */
    SET @Stage = REPLACE(@Stage, N'{', N'');
    SET @Stage = REPLACE(@Stage, N'}', N'');

    SET @Stage = REPLACE(@Stage, @PH_OB, N'{');
    SET @Stage = REPLACE(@Stage, @PH_CB, N'}');
    SET @Stage = REPLACE(@Stage, @PH_BS, @bs);

    /* ============================================================
       STEP 4: Whitespace cleanup
       ============================================================ */
    SET @Stage = REPLACE(@Stage, NCHAR(13) + NCHAR(10), NCHAR(10));
    SET @Stage = REPLACE(@Stage, NCHAR(13), NCHAR(10));

    WHILE CHARINDEX(NCHAR(10) + NCHAR(10) + NCHAR(10), @Stage) > 0
        SET @Stage = REPLACE(@Stage, NCHAR(10) + NCHAR(10) + NCHAR(10), NCHAR(10) + NCHAR(10));

    SET @Stage = REPLACE(@Stage, N' ' + NCHAR(10), NCHAR(10));
    SET @Stage = REPLACE(@Stage, NCHAR(10) + N' ', NCHAR(10));

    WHILE CHARINDEX(N'  ', @Stage) > 0
        SET @Stage = REPLACE(@Stage, N'  ', N' ');

    SET @Stage = REPLACE(@Stage, NCHAR(10), NCHAR(13) + NCHAR(10));

    SET @Stage = LTRIM(RTRIM(@Stage));
    WHILE LEFT(@Stage, 2) = NCHAR(13) + NCHAR(10)
        SET @Stage = SUBSTRING(@Stage, 3, LEN(@Stage));
    WHILE RIGHT(@Stage, 2) = NCHAR(13) + NCHAR(10)
        SET @Stage = SUBSTRING(@Stage, 1, LEN(@Stage) - 2);

    RETURN @Stage;
END;
