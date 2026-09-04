CREATE   VIEW [dbo].[v_Base_CustomerLocations] AS
SELECT 
    -- 1. Identity
    L.CustLocationID,
    L.CustCode,
    ISNULL(C.Name1, 'Unknown') AS CustomerName1,
    L.LocationName,
    
    -- 2. Physical Address
    L.Address1,
    L.Address2,
    -- Convenience: Combined Address
    LTRIM(RTRIM(ISNULL(L.Address1, '') + ' ' + ISNULL(L.Address2, ''))) AS FullAddress,
    
    L.City,
    L.StateCode,
    L.Zip,
    L.County,
    L.Country,
    L.CountryCode,
    L.CountyCode,
    
    L.Latitude,
    L.Longitude,
    L.GeoFenceRadius,

    -- 3. Contact Info (Location Level)
    L.Phone AS LocationPhone,
    L.AltPhone AS LocationAltPhone,
    L.Fax AS LocationFax,
    
    -- 4. Specific People (Legacy Text Fields)
    L.OrderedBy AS OrderedBy_LegacyText,
    L.OrdByPhone AS OrderedByPhone,
    L.OrderedByEmail,
    L.OrderedByWP AS OrderedByWorkPhone,

    L.ReportTo AS ReportTo_LegacyText,
    L.ReportToPhone,
    L.ReportToEmail,
    L.ReportToWP AS ReportToWorkPhone,

    -- 5. Specific People (Linked Contacts)
    L.OrderedByContactID,
    ISNULL(CC_Ord.ContactName, 'Unknown') AS OrderedBy_ContactName,
    
    L.ReportedToContactID,
    ISNULL(CC_Rep.ContactName, 'Unknown') AS ReportedTo_ContactName,

    -- 6. Status & Flags
    L.Status AS Status_Code,
    CASE WHEN L.Status = 1 THEN 'Active' ELSE 'Inactive' END AS LocationStatus,

    L.MSHA,
    CASE WHEN L.MSHA = 1 THEN 'MSHA' ELSE 'Not MSHA' END AS MSHA_Status,

    L.AddressUnknown,
    CASE WHEN L.AddressUnknown = 1 THEN 'Unknown Address' ELSE 'Address Known' END AS Address_Reliability,

    L.ValidationStatus,
    
    -- 7. Pricing & Billing
    L.PriceList,
    L.PriceExpires,
    L.EntityUseCode,
    L.EmailInvoice,

    -- 8. Descriptions & Directions
    L.Description,
    
    L.Directions AS Directions_Raw,
    dbo.fn_StripRTF(L.Directions) AS Directions

FROM stg.FMS_CUSTOMER_LOCATIONS_Raw L
    -- Parent Customer
    LEFT JOIN stg.FMS_CUSTOMERS_Raw C ON L.CustCode = C.CustCode
    -- Contact: Ordered By
    LEFT JOIN stg.FMS_CUSTOMER_CONTACTS_Raw CC_Ord ON L.OrderedByContactID = CC_Ord.CustContactID
    -- Contact: Reported To
    LEFT JOIN stg.FMS_CUSTOMER_CONTACTS_Raw CC_Rep ON L.ReportedToContactID = CC_Rep.CustContactID;
