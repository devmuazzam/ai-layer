CREATE   VIEW [dbo].[v_Base_CustomerContacts] AS
SELECT 
    -- 1. Identity
    CC.CustContactID,
    CC.CustCode,
    ISNULL(C.Name1, 'Unknown') AS CustomerName1,
    
    CC.ContactName,
    CC.Position AS ContactPosition,
    
    -- 2. Sales Relationship
    CC.SpersonCode AS SalesPerson_Code,
    ISNULL(CONCAT(SP.FName, ' ', SP.LName), 'Unknown') AS SalesPerson_Name,
    
    -- 3. Communication
    CC.Email,
    CC.Phone AS WorkPhone,
    CC.Mobile AS MobilePhone,
    CC.HomePhone,
    CC.Fax,
    CC.Pager,
    CC.Nextel, -- Legacy field, kept per mapping
    
    -- 4. Address Details
    CC.ContactAddress,
    CC.ContactCity,
    CC.StateProv AS StateCode,
    
    CC.AddressSameAsCust,
    CASE WHEN CC.AddressSameAsCust = 1 THEN 'Same as Customer' ELSE 'Different Address' END AS Address_MatchType,

    -- 5. Status & Classification
    CC.Status AS Status_Code,
    CASE WHEN CC.Status = 1 THEN 'Active' ELSE 'Inactive' END AS ContactStatus,
    
    CC.ContactType,
    CC.DLReg AS DriverLicense_Registration,

    -- 6. Notes (Cleaned)
    CC.OtherInfo AS OtherContactInfo_Raw,
    dbo.fn_StripRTF(CC.OtherInfo) AS OtherContactInfo

FROM stg.FMS_CUSTOMER_CONTACTS_Raw CC
    -- Parent Customer
    LEFT JOIN stg.FMS_CUSTOMERS_Raw C ON CC.CustCode = C.CustCode
    -- Sales Person
    LEFT JOIN stg.FMS_SALES_PERSON_Raw SP ON CC.SpersonCode = SP.SpersonCode;
