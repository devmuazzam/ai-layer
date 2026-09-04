CREATE   VIEW [dbo].[v_Base_Customers] AS
SELECT 
    -- 1. Identity
    C.CustCode,
    C.Name1 AS CustomerName1,
    C.Name2 AS CustomerName2,
    -- Convenience Column: Combined Name
    ISNULL(C.Name1, '') + CASE WHEN C.Name2 IS NOT NULL THEN ' ' + C.Name2 ELSE '' END AS FullCustomerName,
    
    C.DBAName,
    C.ParentCustCode,
    
    -- 2. Address & Location
    C.Address1,
    C.Address2,
    C.City,
    C.StateCode,
    C.Zip,
    C.Country,
    
    -- 3. Contact Details
    C.Phone AS MainPhone,
    C.Fax,
    C.Email AS MainEmail,
    C.WebSite,
    
    C.BillContact1,
    C.BillPhone1,
    C.BillContact2,
    C.BillPhone2,

    -- 4. Sales & Account Management
    C.SpersonCode AS SalesPerson_Code,
    ISNULL(CONCAT(SP.FName, ' ', SP.LName), 'Unknown') AS SalesPerson_Name,
    
    C.IndustryCode,
    ISNULL(I.Name, 'Unknown') AS IndustryName,
    
    C.ProspectStatus,
    CASE WHEN C.ProspectStatus = 1 THEN 'Prospect' ELSE 'Customer' END AS Customer_Type,

    C.Status AS Status_Code,
    CASE WHEN C.Status = 'A' THEN 'Active' WHEN C.Status = 'I' THEN 'Inactive' ELSE 'Unknown' END AS Status_Description,

    -- 5. Financials & Billing Terms
    C.TermID,
    ISNULL(T.TermName, 'Unknown') AS PaymentTerms,
    
    C.PriceList,
    C.PriceExpires,
    C.PricingMatrixCode,
    
    C.CreditLimit,
    C.CurrentBalance,
    C.AcctIntCode AS Accounting_Integration_Code,
    
    C.MarkUpPerc AS MarkUpPercent,
    C.FinChgPercent AS FinanceChargePercent,
    
    -- 6. Flags & Rules
    C.PORequire,
    CASE WHEN C.PORequire = 1 THEN 'Yes' ELSE 'No' END AS PO_Required,
    
    C.ContractNumb AS ContractNumber,
    
    C.Taxable,
    CASE WHEN C.Taxable = 1 THEN 'Yes' ELSE 'No' END AS IsTaxable,
    C.SalesTaxCode,
    
    C.EmailDocOK,
    CASE WHEN C.EmailDocOK = 1 THEN 'Yes' ELSE 'No' END AS EmailDocumentOk,
    
    C.AcctUpdated,
    CASE WHEN C.AcctUpdated = 1 THEN 'Yes' ELSE 'No' END AS Is_AccountUpdated,

    C.ListMarkUp,
    C.StatementType,

    -- 7. Notes (Cleaned)
    C.Comments AS Comments_Raw,
    dbo.fn_StripRTF(C.Comments) AS Comments,
    
    C.Notes AS Notes_Raw,
    dbo.fn_StripRTF(C.Notes) AS Notes

FROM stg.FMS_CUSTOMERS_Raw C
    -- Sales Person
    LEFT JOIN stg.FMS_SALES_PERSON_Raw SP ON C.SpersonCode = SP.SpersonCode
    -- Industry
    LEFT JOIN stg.FMS_INDUSTRIES_Raw I ON C.IndustryCode = I.IndustryCode
    -- Terms
    LEFT JOIN stg.FMS_TERMS_Raw T ON C.TermID = T.TermID;
