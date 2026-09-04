CREATE   VIEW [dbo].[v_Base_CustomerNotes] AS
SELECT 
    -- 1. Identity
    N.CustomerNotesID,
    N.CustCode,
    ISNULL(C.Name1, 'Unknown') AS CustomerName1,
    N.GroupNumb,
    
    -- 2. Message Details
    N.Name AS MessageName,
    N.DisplayMessage,

    -- 3. Text Content (Cleaned)
    N.PopUpMessage AS PopUpMessage_Raw,
    dbo.fn_StripRTF(N.PopUpMessage) AS PopUpMessage,

    N.Comments AS MessageComments_Raw,
    dbo.fn_StripRTF(N.Comments) AS MessageComments

FROM stg.FMS_CUSTOMER_NOTES_Raw N
    LEFT JOIN stg.FMS_CUSTOMERS_Raw C ON N.CustCode = C.CustCode;
