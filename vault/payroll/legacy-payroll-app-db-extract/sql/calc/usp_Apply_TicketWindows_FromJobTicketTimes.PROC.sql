
CREATE   PROCEDURE calc.usp_Apply_TicketWindows_FromJobTicketTimes
    @IDs calc.JobTicketIDList READONLY
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    /*
      ALWAYS anchor to TicketTimeline.TicketDate (date).
      Use only the time-of-day component from TkTm values.

      Shift:
        Start = TkTm01 else TkTm02 (round down)
        End   = TkTm10 else TkTm09 (round up)

      Boom:
        Start = TkTm04 else TkTm03 (round down)
        End   = TkTm07 else TkTm08 (round up)

      Cross-midnight:
        if EndDT < StartDT then EndDT += 1 day
    */

    ;WITH T AS
    (
        SELECT
            tt.JobTicketID,
            TicketDate = CONVERT(date, tt.TicketDate),

            jt.TkTm01, jt.TkTm02, jt.TkTm03, jt.TkTm04,
            jt.TkTm07, jt.TkTm08, jt.TkTm09, jt.TkTm10,

            ShiftStartRaw = COALESCE(jt.TkTm01, jt.TkTm02),
            ShiftEndRaw   = COALESCE(jt.TkTm10, jt.TkTm09),

            BoomStartRaw  = COALESCE(jt.TkTm04, jt.TkTm03),
            BoomEndRaw    = COALESCE(jt.TkTm07, jt.TkTm08),

            Shift_Source_Start = CASE WHEN jt.TkTm01 IS NOT NULL THEN 'TkTm01' WHEN jt.TkTm02 IS NOT NULL THEN 'TkTm02' END,
            Shift_Source_End   = CASE WHEN jt.TkTm10 IS NOT NULL THEN 'TkTm10' WHEN jt.TkTm09 IS NOT NULL THEN 'TkTm09' END,

            Boom_Source_Start  = CASE WHEN jt.TkTm04 IS NOT NULL THEN 'TkTm04' WHEN jt.TkTm03 IS NOT NULL THEN 'TkTm03' END,
            Boom_Source_End    = CASE WHEN jt.TkTm07 IS NOT NULL THEN 'TkTm07' WHEN jt.TkTm08 IS NOT NULL THEN 'TkTm08' END
        FROM @IDs i
        JOIN calc.TicketTimeline tt
          ON tt.JobTicketID = i.JobTicketID
        JOIN calc.v_JobTicket_Times jt
          ON jt.JobTicketID = i.JobTicketID
        WHERE tt.TicketDate IS NOT NULL
    ),
    A AS
    (
        SELECT
            JobTicketID,
            Shift_Source_Start, Shift_Source_End,
            Boom_Source_Start,  Boom_Source_End,

            -- anchor to TicketDate using only time-of-day from raw datetime
            ShiftStartDT =
                CASE WHEN ShiftStartRaw IS NULL THEN NULL
                     ELSE DATEADD(MINUTE,
                                  DATEDIFF(MINUTE, 0, CONVERT(time(0), ShiftStartRaw)),
                                  CAST(TicketDate AS datetime2(0)))
                END,

            ShiftEndDT_Base =
                CASE WHEN ShiftEndRaw IS NULL THEN NULL
                     ELSE DATEADD(MINUTE,
                                  DATEDIFF(MINUTE, 0, CONVERT(time(0), ShiftEndRaw)),
                                  CAST(TicketDate AS datetime2(0)))
                END,

            BoomStartDT =
                CASE WHEN BoomStartRaw IS NULL THEN NULL
                     ELSE DATEADD(MINUTE,
                                  DATEDIFF(MINUTE, 0, CONVERT(time(0), BoomStartRaw)),
                                  CAST(TicketDate AS datetime2(0)))
                END,

            BoomEndDT_Base =
                CASE WHEN BoomEndRaw IS NULL THEN NULL
                     ELSE DATEADD(MINUTE,
                                  DATEDIFF(MINUTE, 0, CONVERT(time(0), BoomEndRaw)),
                                  CAST(TicketDate AS datetime2(0)))
                END
        FROM T
    ),
    B AS
    (
        SELECT
            JobTicketID,
            Shift_Source_Start, Shift_Source_End,
            Boom_Source_Start,  Boom_Source_End,

            ShiftStartDT,
            BoomStartDT,

            ShiftEndDT =
                CASE WHEN ShiftEndDT_Base IS NOT NULL AND ShiftStartDT IS NOT NULL AND ShiftEndDT_Base < ShiftStartDT
                     THEN DATEADD(DAY, 1, ShiftEndDT_Base)
                     ELSE ShiftEndDT_Base END,

            BoomEndDT =
                CASE WHEN BoomEndDT_Base IS NOT NULL AND BoomStartDT IS NOT NULL AND BoomEndDT_Base < BoomStartDT
                     THEN DATEADD(DAY, 1, BoomEndDT_Base)
                     ELSE BoomEndDT_Base END
        FROM A
    ),
    R AS
    (
        SELECT
            JobTicketID,
            Shift_Source_Start, Shift_Source_End,
            Boom_Source_Start,  Boom_Source_End,

            New_Shift_Start =
                CASE WHEN ShiftStartDT IS NULL THEN NULL
                     ELSE DATEADD(MINUTE, (DATEDIFF(MINUTE, 0, ShiftStartDT) / 30) * 30, 0) END,

            New_Shift_End =
                CASE WHEN ShiftEndDT IS NULL THEN NULL
                     ELSE DATEADD(MINUTE, ((DATEDIFF(MINUTE, 0, ShiftEndDT) + 29) / 30) * 30, 0) END,

            New_Boom_Start =
                CASE WHEN BoomStartDT IS NULL THEN NULL
                     ELSE DATEADD(MINUTE, (DATEDIFF(MINUTE, 0, BoomStartDT) / 30) * 30, 0) END,

            New_Boom_End =
                CASE WHEN BoomEndDT IS NULL THEN NULL
                     ELSE DATEADD(MINUTE, ((DATEDIFF(MINUTE, 0, BoomEndDT) + 29) / 30) * 30, 0) END
        FROM B
    )
    UPDATE tt
        SET
            tt.Shift_Window_Start = COALESCE(r.New_Shift_Start, tt.Shift_Window_Start),
            tt.Shift_Window_End   = COALESCE(r.New_Shift_End,   tt.Shift_Window_End),
            tt.Shift_Source_Start = CASE WHEN r.New_Shift_Start IS NOT NULL THEN r.Shift_Source_Start ELSE tt.Shift_Source_Start END,
            tt.Shift_Source_End   = CASE WHEN r.New_Shift_End   IS NOT NULL THEN r.Shift_Source_End   ELSE tt.Shift_Source_End   END,

            tt.Boom_Window_Start  = COALESCE(r.New_Boom_Start, tt.Boom_Window_Start),
            tt.Boom_Window_End    = COALESCE(r.New_Boom_End,   tt.Boom_Window_End),
            tt.Boom_Source_Start  = CASE WHEN r.New_Boom_Start IS NOT NULL THEN r.Boom_Source_Start ELSE tt.Boom_Source_Start END,
            tt.Boom_Source_End    = CASE WHEN r.New_Boom_End   IS NOT NULL THEN r.Boom_Source_End   ELSE tt.Boom_Source_End   END
    FROM calc.TicketTimeline tt
    JOIN R r
      ON r.JobTicketID = tt.JobTicketID;
END
