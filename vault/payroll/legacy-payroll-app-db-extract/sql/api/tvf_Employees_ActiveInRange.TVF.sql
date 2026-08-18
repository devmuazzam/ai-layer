
CREATE   FUNCTION api.tvf_Employees_ActiveInRange
(
    @FromDate date,
    @ToDate   date
)
RETURNS TABLE
AS
RETURN
(
    SELECT
        EmpID = CONVERT(varchar(15), e.EmpID),
        e.FullName,
        StartDate = CONVERT(date, e.StartDate),
        TermDate  = CONVERT(date, e.TermDate),
        e.EmploymentStatus,
        e.CraftCode,
        e.UnionCode,
        e.PayRate,
        e.PayType,
        e.PayCycle,
        e.YardCode,

        -- Added for UI filtering (Field vs Office)
        e.InOffice,
        e.Is_OfficeStaff
    FROM app.v_Base_Employees e
    WHERE e.StartDate <= DATEADD(DAY, 1, @ToDate)  -- inclusive end
      AND (e.TermDate IS NULL OR e.TermDate >= @FromDate)
);
