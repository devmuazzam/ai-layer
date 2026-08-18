CREATE   VIEW [dbo].[v_Base_Employees] AS
SELECT 
    -- 1. Identity & Contact
    E.EmpID,
    E.FName AS FirstName,
    E.MName AS MiddleName,
    E.LName AS LastName,
    ISNULL(CONCAT(E.FName, ' ', E.LName), 'Unknown') AS FullName, -- Added for convenience
    
    E.Ssn,
    E.BirthDate,
    E.Gender,
    E.MaritalStatus,
    
    E.Address1,
    E.Address2,
    E.City,
    E.StateCode,
    E.Zip,
    
    E.Phone,
    E.Mobile,
    E.Pager,
    E.Email,

    -- 2. Employment Status & Dates
    E.Status AS Status_Code,
    CASE WHEN E.Status = 1 THEN 'Active' ELSE 'Inactive' END AS EmploymentStatus,
    
    E.StartDate,
    E.RehireDate,
    E.TermDate,
    E.TermReason,
    
    E.InOffice,
    CASE WHEN E.InOffice = 'Y' THEN 'Yes' ELSE 'No' END AS Is_OfficeStaff,
    
    E.Supervisor,
    CASE WHEN E.Supervisor = 1 THEN 'Yes' ELSE 'No' END AS Is_Supervisor,

    E.EmpTypeId,
    ISNULL(ET.Description, 'Unknown') AS EmployeeType,

    -- 3. Payroll & Union Logic
    E.CompanyCode,
    E.YardCode,
    E.PayCycle,
    E.PayType,
    E.UnionCode,
    
    -- Classification Logic
    E.ClassCode,
    ISNULL(CL.Description, 'Unknown') AS ClassDescription,
    
    -- Logic 1: Labor Type (from Classification)
    CASE CL.Labor 
        WHEN 'L' THEN 'Labor' 
        WHEN 'M' THEN 'Material' 
        WHEN 'B' THEN 'Both' 
        ELSE 'Unknown' 
    END AS LaborType,
    
    -- Logic 2: Certified Payroll (from Classification)
    CASE WHEN CL.UseCertifiedPayroll = 1 THEN 'Yes' ELSE 'No' END AS UseCertifiedPayroll,

    -- Logic 3: Employee Specific CertPay Flag
    E.CertPay,
    CASE WHEN E.CertPay = 1 THEN 'Certified Payroll' ELSE 'Standard' END AS Payroll_Classification,

    -- 4. Crafts & Rates
    E.CraftCode,
    ISNULL(C.Description, 'Unknown') AS CraftDescription,
    
    E.PayRate,
    E.BillingRate,
    E.PayRateOT,
    E.PayRateDB,
    E.BillRateOT,
    E.BillRateDB,
    
    E.UnionOverScale,
    E.UnionOverScaleDB,
    E.UnionOverScaleOT,
    
    E.Apprentice,
    CASE WHEN E.Apprentice = 1 THEN 'Active' ELSE 'Inactive' END AS ApprenticeStatus,
    E.UnionApprenticePerc AS UnionApprenticePercent,

    -- 5. Demographics
    E.Ethnic AS EthnicCode,
    ISNULL(ETH.Description, 'Unknown') AS Ethnicity,

    -- 6. Accounting Codes
    E.BurdenCode,
    E.WorkerCompCode,
    E.GLAcctCode,
    
    -- 7. Notes
    E.Comments

FROM src.FMS_EMPLOYEES_Raw E
    -- Join Crafts
    LEFT JOIN src.FMS_CRAFTS_Raw C ON E.CraftCode = C.CraftCode
    -- Join Employee Types
    LEFT JOIN src.FMS_EMPLOYEE_TYPES_Raw ET ON E.EmpTypeId = ET.EmpTypeID
    -- Join Classifications
    LEFT JOIN src.FMS_CLASSIFICATIONS_Raw CL ON E.ClassCode = CL.ClassCode
    -- Join Ethnicity
    LEFT JOIN src.FMS_ETHNICITY_Raw ETH ON E.Ethnic = ETH.EthnicityCode;
