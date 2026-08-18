
CREATE     VIEW [calc].[v_Calc_Labor_Timeline]
AS
WITH R0 AS
(
    SELECT
        -- Key expected by pricing engine
        LaborPayrollID = lp.Original_LaborID,

        -- Identifiers
        lp.PreProcessID,
        lp.Original_LaborID,
        lp.EmpID,
        lp.JobCode,
        lp.Pricing_Date,
        lp.Actual_WorkDate,
        lp.Is_Gap_Row,

        -- Raw times
        lp.Pay_Start,
        lp.Pay_End,

        -- Rounded times (Start down, End up)
        Pay_Start_Rounded =
            CASE WHEN lp.Pay_Start IS NULL THEN NULL
                 ELSE DATEADD(MINUTE, (DATEDIFF(MINUTE, 0, lp.Pay_Start) / 30) * 30, 0)
            END,
        Pay_End_Rounded =
            CASE WHEN lp.Pay_End IS NULL THEN NULL
                 ELSE DATEADD(MINUTE, ((DATEDIFF(MINUTE, 0, lp.Pay_End) + 29) / 30) * 30, 0)
            END,

        lp.Total_Hrs,
        lp.CraftCode,
        lp.UnionCode
    FROM fms.Labor_PreProcessed lp
    WHERE lp.Is_Gap_Row = 0
),
R1 AS
(
    SELECT
        r0.*,

        Prev_End_Rounded =
            LAG(r0.Pay_End_Rounded) OVER
            (
                PARTITION BY r0.EmpID
                ORDER BY r0.Pay_Start_Rounded, r0.LaborPayrollID
            ),

        Prev_LaborPayrollID =
            LAG(r0.LaborPayrollID) OVER
            (
                PARTITION BY r0.EmpID
                ORDER BY r0.Pay_Start_Rounded, r0.LaborPayrollID
            ),

        Gap_Minutes_Raw =
            CASE
                WHEN LAG(r0.Pay_End_Rounded) OVER
                     (PARTITION BY r0.EmpID ORDER BY r0.Pay_Start_Rounded, r0.LaborPayrollID) IS NULL
                THEN NULL
                ELSE DATEDIFF
                     (
                        MINUTE,
                        LAG(r0.Pay_End_Rounded) OVER
                        (PARTITION BY r0.EmpID ORDER BY r0.Pay_Start_Rounded, r0.LaborPayrollID),
                        r0.Pay_Start_Rounded
                     )
            END
    FROM R0 r0
),
R2 AS
(
    SELECT
        r1.*,

        Is_Overlap =
            CASE
                WHEN r1.Gap_Minutes_Raw IS NULL THEN CONVERT(bit, 0)
                WHEN r1.Gap_Minutes_Raw < 0 THEN CONVERT(bit, 1)
                ELSE CONVERT(bit, 0)
            END,

        Gap_Minutes =
            CASE
                WHEN r1.Gap_Minutes_Raw IS NULL THEN NULL
                WHEN r1.Gap_Minutes_Raw < 0 THEN 0
                ELSE r1.Gap_Minutes_Raw
            END,

        Gap_Hours =
            CASE
                WHEN r1.Gap_Minutes_Raw IS NULL THEN NULL
                WHEN r1.Gap_Minutes_Raw < 0 THEN CONVERT(decimal(10,2), 0.00)
                ELSE CONVERT(decimal(10,2), r1.Gap_Minutes_Raw / 60.0)
            END,

        IsChainStart =
            CASE
                WHEN r1.Prev_End_Rounded IS NULL THEN CONVERT(bit, 1)
                WHEN r1.Gap_Minutes_Raw >= 480 THEN CONVERT(bit, 1)
                ELSE CONVERT(bit, 0)
            END
    FROM R1 r1
),
R3 AS
(
    SELECT
        r2.*,

        ChainGroup =
            SUM(CASE WHEN r2.IsChainStart = 1 THEN 1 ELSE 0 END) OVER
            (
                PARTITION BY r2.EmpID
                ORDER BY r2.Pay_Start_Rounded, r2.LaborPayrollID
                ROWS UNBOUNDED PRECEDING
            )
    FROM R2 r2
)
SELECT
    -- existing columns (keep stable)
    LaborPayrollID,
    PreProcessID,
    Original_LaborID,
    EmpID,
    JobCode,
    Pricing_Date,
    Actual_WorkDate,
    Is_Gap_Row,
    Pay_Start,
    Pay_End,
    Pay_Start_Rounded,
    Pay_End_Rounded,
    Prev_LaborPayrollID,

    -- existing duration used by rest-period premium logic
    Duration_Total_Payable =
        CASE
            WHEN Pay_Start_Rounded IS NULL OR Pay_End_Rounded IS NULL THEN NULL
            WHEN Pay_End_Rounded <= Pay_Start_Rounded THEN CONVERT(decimal(10,2), 0.00)
            ELSE CONVERT(decimal(10,2), DATEDIFF(MINUTE, Pay_Start_Rounded, Pay_End_Rounded) / 60.0)
        END,

    Total_Hrs,
    CraftCode,
    UnionCode,

    -- NEW: continuity / rest-gap diagnostics (unpaid)
    Prev_End_Rounded,
    Gap_Minutes_Raw,
    Gap_Minutes,
    Gap_Hours,
    Is_Overlap,
    IsChainStart,
    ChainGroup,

    ChainStart =
        MIN(Pay_Start_Rounded) OVER
        (
            PARTITION BY EmpID, ChainGroup
        )
FROM R3;
