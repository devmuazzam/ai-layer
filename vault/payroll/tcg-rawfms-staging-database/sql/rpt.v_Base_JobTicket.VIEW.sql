CREATE   VIEW [dbo].[v_Base_JobTicket] AS
SELECT 
    -- 1. Identity & Keys
    T.JobTicketID,
    T.JobCode,
    T.TicketDate,
    T.JobUnitID,
    T.JobDtlID,
    T.JobEmpID,
    
    -- 2. The 10-Point Payroll Timeline (Chronological)
    T.TimeStart AS TkTm01_TimeStart,
    T.YardOutTime AS TkTm02_YardOutTime,
    T.ArrivedJob AS TkTm03_ArrivedJob,
    T.StartWorkTime AS TkTm04_StartWorkTime,
    T.SignatureInTime AS TkTm05_SignatureInTime,
    T.SignatureOutTime AS TkTm06_SignatureOutTime,
    T.EndWorkTime AS TkTm07_EndWorkTime,
    T.LeftJob AS TkTm08_LeftJob,
    T.YardInTime AS TkTm09_YardInTime,
    T.TimeEnd AS TkTm10_TimeEnd,

    -- Estimated Times
    T.EstStartTime AS EstimatedStartTime,
    T.EstEndTime AS EstimatedEndTime,

    -- 3. Status Logic
    T.JobTicketStatus AS TicketStatus_Code,
    T.TicketType,

    CASE 
        WHEN T.JobTicketStatus = 'X' THEN 'Cancelled'
        WHEN T.JobTicketStatus = 'Z' THEN 'Completed'
        WHEN T.JobTicketStatus = 'T' THEN 
            CASE 
                WHEN T.Viewed = 0 THEN 'Sent'
                WHEN T.Viewed = 1 AND T.Downloaded = 0 THEN 'Viewed'
                WHEN T.Viewed = 1 AND T.Downloaded = 1 THEN
                    CASE WHEN T.TimeStart IS NOT NULL THEN 'Started' ELSE 'Downloaded' END
                ELSE 'Unknown (T)'
            END
        WHEN T.JobTicketStatus = 'Y' THEN
            CASE 
                WHEN T.TimeEnd IS NOT NULL THEN 'Ended'
                ELSE 
                    CASE T.TicketType
                        WHEN 'TRUCKING' THEN 'Departed Receiver'
                        WHEN 'LOAD'     THEN 'Dropped'
                        ELSE 'Arrived Yard' 
                    END
            END
        WHEN T.JobTicketStatus = 'C' THEN 
            CASE T.TicketType
                WHEN 'TRUCKING' THEN 'Arrived at Shipper'
                WHEN 'LOAD'     THEN 'Picked Up'
                ELSE 'Left Yard' 
            END
        WHEN T.JobTicketStatus = 'O' THEN 
            CASE T.TicketType
                WHEN 'TRUCKING' THEN 'Started'
                WHEN 'LOAD'     THEN '1st Signature'
                ELSE 'Arrived Job' 
            END
        WHEN T.JobTicketStatus = 'S' THEN 
            CASE T.TicketType
                WHEN 'TRUCKING' THEN 'Shipper Signature'
                ELSE '1st Signature'
            END
        WHEN T.JobTicketStatus = 'R' THEN 
            CASE T.TicketType
                WHEN 'TRUCKING' THEN 'Receiver Signature'
                ELSE '2nd Signature'
            END
        WHEN T.JobTicketStatus = 'F' THEN 
            CASE T.TicketType
                WHEN 'TRUCKING' THEN 'Received'
                WHEN 'LOAD'     THEN '2nd Signature'
                ELSE 'Left Job' 
            END
        ELSE 'Unknown Status'
    END AS TicketStatus_Description,

    -- 4. Customer & People
    T.CustCode,
    ISNULL(C.Name1, 'Unknown') AS CustomerName1,

    T.EmpID,
    -- CORRECTED LINE BELOW: Changed FirstName/LastName to FName/LName
    ISNULL(CONCAT(E.FName, ' ', E.LName), 'Unknown') AS PrimaryEmployeeTicket,

    -- 5. Signatures
    T.SignatureIn,
    CASE WHEN T.SignatureIn IS NOT NULL THEN 1 ELSE 0 END AS Has_SignatureIn,
    T.SignatureInName,

    T.SignatureOut,
    CASE WHEN T.SignatureOut IS NOT NULL THEN 1 ELSE 0 END AS Has_SignatureOut,
    T.SignatureOutName,

    T.ReqSignatureOnTickets,
    CASE WHEN T.ReqSignatureOnTickets = 1 THEN 'Required' ELSE 'Optional' END AS Signature_Requirement,

    -- 6. Flags
    T.Downloaded,
    CASE WHEN T.Downloaded = 1 THEN 'Yes' ELSE 'No' END AS Is_Downloaded,

    T.AcceptTerms,
    CASE WHEN T.AcceptTerms = 1 THEN 'Accepted' ELSE 'Not Accepted' END AS Terms_Accepted,

    T.WorkThruLunch,
    CASE WHEN T.WorkThruLunch = 1 THEN 'Worked Thru Lunch' ELSE 'Took Meal Breaks' END AS Lunch_Status,

    T.Viewed,
    CASE WHEN T.Viewed = 1 THEN 'Yes' ELSE 'No' END AS Is_Viewed,

    T.SubContractor,
    CASE WHEN T.SubContractor = 1 THEN 'Yes' ELSE 'No' END AS Is_SubContractor,

    -- 7. Text Data
    T.Comments AS TicketComments_Raw,
    dbo.fn_StripRTF(T.Comments) AS TicketComments,

    T.TimeChangeJustification AS TimeChange_Reason_Raw,
    dbo.fn_StripRTF(T.TimeChangeJustification) AS TimeChange_Reason,

    -- 8. Specs
    T.LiftBack,
    T.LiftUp,
    T.LiftIn,
    T.LiftPieces,
    T.TotalWeight,
    T.DistanceHauled,
    T.HeaviestPick,
    T.SrtBackFrBlg,
    T.Radius,
    T.Height,
    
    T.TruckingLength,
    T.TruckingWidth,
    T.TruckingHeight,
    T.TruckingPieces,
    T.TruckingTotalWt AS TruckingTotalWeight

FROM stg.FMS_JOB_TICKET_Raw T
    LEFT JOIN stg.FMS_CUSTOMERS_Raw C ON T.CustCode = C.CustCode
    LEFT JOIN stg.FMS_EMPLOYEES_Raw E ON T.EmpID = E.EmpID;
