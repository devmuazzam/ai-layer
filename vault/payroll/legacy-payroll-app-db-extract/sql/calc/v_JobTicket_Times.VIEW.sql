
CREATE   VIEW calc.v_JobTicket_Times
AS
SELECT
    jt.JobTicketID,

    -- Standardized names used by downstream logic:
    TkTm01 = jt.TimeStart,         -- TkTm01_TimeStart
    TkTm02 = jt.YardOutTime,       -- TkTm02_YardOutTime
    TkTm03 = jt.ArrivedJob,        -- TkTm03_ArrivedJob
    TkTm04 = jt.StartWorkTime,     -- TkTm04_StartWorkTime

    TkTm05 = jt.SignatureInTime,   -- TkTm05_SignatureInTime (optional)
    TkTm06 = jt.SignatureOutTime,  -- TkTm06_SignatureOutTime (optional)

    TkTm07 = jt.EndWorkTime,       -- TkTm07_EndWorkTime
    TkTm08 = jt.LeftJob,           -- TkTm08_LeftJob
    TkTm09 = jt.YardInTime,        -- TkTm09_YardInTime
    TkTm10 = jt.TimeEnd            -- TkTm10_TimeEnd
FROM TCG_RawFMS.stg.FMS_JOB_TICKET_Raw jt;
