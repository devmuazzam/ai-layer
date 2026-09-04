CREATE   VIEW [dbo].[v_Base_JobMaster] AS
SELECT 
    -- 1. Identity & Codes
    M.JobCode,
    M.CompanyCode,
    M.YardCode,
    M.DeptCode,
    
    -- 2. Customer Info
    M.CustCode,
    ISNULL(C.Name1, 'Unknown') AS CustomerName1,
    M.ReportedBy,
    M.OrderedBy,
    M.PoNumb,
    
    -- 3. Job Site Location (Expanded)
    M.CustLocationID AS JobSite_LocationID,
    ISNULL(L.LocationName, 'Unknown') AS JobSite_LocationName,
    -- Combine Address 1 & 2, removing extra spaces if #2 is empty
    NULLIF(TRIM(CONCAT(L.Address1, ' ', L.Address2)), '') AS JobSite_Address,
    L.City AS JobSite_City,
    L.StateCode AS JobSite_State,
    L.Zip AS JobSite_Zip,

    -- 4. Dates & Times
    M.JobSdate AS JobStartDate,
    M.JobEdate AS JobEndDate,
    M.JobStime AS JobStartTime,
    M.JobEtime AS JobEndTime,
    M.TimeEntered,
    
    -- Flexibility Flags
    M.DateFlex,
    CASE WHEN M.DateFlex = 1 THEN 'Flexible' ELSE 'Fixed' END AS Date_Flexibility,
    
    M.TimeFlex,
    CASE WHEN M.TimeFlex = 1 THEN 'Flexible' ELSE 'Fixed' END AS Time_Flexibility,

    -- 5. Status & Classification
    M.Dispatched,
    CASE WHEN M.Dispatched = 1 THEN 'Dispatched' ELSE 'Pending Dispatch' END AS Dispatch_Status,
    
    M.WorkWeekend,
    CASE WHEN M.WorkWeekend = 1 THEN 'Authorized' ELSE 'Weekdays Only' END AS Weekend_Work_Status,
    
    M.Status AS JobStatusCode,
    ISNULL(JS.Description, 'Unknown') AS JobStatus,

    M.JobTypeCode,
    ISNULL(JT.Description, 'Unknown') AS JobType,
    
    -- 6. People & Responsibilities
    -- Sales Person
    M.SpersonCode AS SalesPerson_Code,
    ISNULL(CONCAT(SP.FName, ' ', SP.LName), 'Unknown') AS SalesPerson_Name,
    
    -- Job Checked By
    M.CheckID AS JobCheckedByID,
    ISNULL(CONCAT(CT_Check.FirstName, ' ', CT_Check.LastName), 'Unknown') AS JobCheckedBy_Name,
    
    -- Job Taken By
    M.TakenID AS JobTakenByID,
    ISNULL(CONCAT(CT_Taken.FirstName, ' ', CT_Taken.LastName), 'Unknown') AS JobTakenBy_Name,

    -- Contacts
    M.OrderedByContactID,
    ISNULL(CC_Ord.ContactName, 'Unknown') AS OrderedByContact,
    
    M.ReportedToContactID,
    ISNULL(CC_Rep.ContactName, 'Unknown') AS ReportedToContact,

    -- 7. Descriptions (RTF Cleaned)
    -- Work Description
    M.WorkDescription AS WorkDescription_Raw,
    dbo.fn_StripRTF(M.WorkDescription) AS WorkDescription,

    -- Equipment Required
    M.EquipRequired AS EquipRequired_Raw,
    dbo.fn_StripRTF(M.EquipRequired) AS EquipRequired,

    -- Job Comments
    M.Comments AS JobComments_Raw,
    dbo.fn_StripRTF(M.Comments) AS JobComments,

    -- In House Comments
    M.InHouse AS InHouseComments_Raw,
    dbo.fn_StripRTF(M.InHouse) AS InHouseComments,
    
    -- Billing Description
    M.BillingDescription AS BillingDescription_Raw,
    dbo.fn_StripRTF(M.BillingDescription) AS BillingDescription,

    -- 8. Financials & Billing
    M.GLAcctCode,
    M.QuoteNumb,
    M.PriceList,
    
    M.CertPay,
    CASE WHEN M.CertPay = 1 THEN 'Certified Payroll' ELSE 'Standard' END AS Payroll_Classification,
    
    M.ReqSignatureOnTickets,
    CASE WHEN M.ReqSignatureOnTickets = 1 THEN 'Required' ELSE 'Optional' END AS Signature_Requirement,
    
    M.NonBillable,
    CASE WHEN M.NonBillable = 1 THEN 'Non-Billable' ELSE 'Billable' END AS Billing_Type,

    M.TermCondID,
    ISNULL(T.TermName, 'Unknown') AS BillingTerms,

    -- 9. Lift Details / Specs
    M.SortNumb,
    M.LiftBack,
    M.LiftUp,
    M.LiftIn,
    M.LiftPieces,
    M.TotalWeight,
    M.DistanceHauled,
    M.HeaviestPick,
    M.SrtBackFrBlg,
    M.Radius,
    M.Height

FROM stg.FMS_JOB_MASTER_Raw M
    -- Customer
    LEFT JOIN stg.FMS_CUSTOMERS_Raw C ON M.CustCode = C.CustCode
    -- Location
    LEFT JOIN stg.FMS_CUSTOMER_LOCATIONS_Raw L ON M.CustLocationID = L.CustLocationID
    -- Job Type
    LEFT JOIN stg.FMS_JOB_TYPES_Raw JT ON M.JobTypeCode = JT.JobTypeCode
    -- Job Status
    LEFT JOIN stg.FMS_JOB_STATUS_Raw JS ON M.Status = JS.JobStatusCode
    -- Sales Person
    LEFT JOIN stg.FMS_SALES_PERSON_Raw SP ON M.SpersonCode = SP.SpersonCode
    -- Checked Taken (Joined Twice: Once for CheckID, Once for TakenID)
    LEFT JOIN stg.FMS_CHECKED_TAKEN_Raw CT_Check ON M.CheckID = CT_Check.CheckTakenID
    LEFT JOIN stg.FMS_CHECKED_TAKEN_Raw CT_Taken ON M.TakenID = CT_Taken.CheckTakenID
    -- Terms
    LEFT JOIN stg.FMS_TERMS_Raw T ON M.TermCondID = T.TermID
    -- Contacts (Ordered By / Reported To)
    LEFT JOIN stg.FMS_CUSTOMER_CONTACTS_Raw CC_Ord ON M.OrderedByContactID = CC_Ord.CustContactID
    LEFT JOIN stg.FMS_CUSTOMER_CONTACTS_Raw CC_Rep ON M.ReportedToContactID = CC_Rep.CustContactID;
