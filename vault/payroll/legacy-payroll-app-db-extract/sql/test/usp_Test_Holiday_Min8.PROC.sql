
CREATE   PROCEDURE test.usp_Test_Holiday_Min8
    @LaborPayrollID int = NULL,
    @Tol decimal(10,4) = 0.01
AS
BEGIN
    SET NOCOUNT ON;

    IF @LaborPayrollID IS NULL
    BEGIN
        SELECT TOP (1)
            @LaborPayrollID = LaborPayrollID
        FROM api.v_UI_GuaranteeAllocations
        WHERE RuleCode = 'HOLIDAY_MIN_8'
        ORDER BY
            GuaranteeDate DESC,
            CalculatedAtUTC DESC,
            GuaranteeAllocationID DESC;
    END;

    IF @LaborPayrollID IS NULL
        THROW 51069, 'HolidayMin8 test skipped/failed: no HOLIDAY_MIN_8 allocation exists. Recalculate a holiday date range first.', 1;

    DECLARE
        @Act decimal(10,4),
        @PayTotal decimal(10,4),
        @PcGap decimal(10,4),
        @PcPayGapAdd decimal(12,4),
        @RuleCode varchar(40),
        @RuleName varchar(120),
        @GuaranteeDate date,
        @HolidayName nvarchar(200),
        @GroupActual decimal(10,4),
        @MinimumHours decimal(10,4),
        @GroupGap decimal(10,4),
        @AllocatedGap decimal(10,4),
        @AllocatedPay decimal(12,4),
        @Multiplier decimal(10,4),
        @AllocationMethod varchar(60);

    SELECT
        @Act = CAST(pc.Act_Total_Hrs AS decimal(10,4)),
        @PayTotal = CAST(pc.Pay_Total_Hrs AS decimal(10,4)),
        @PcGap = CAST(pc.Gap_Hrs_Total AS decimal(10,4)),
        @PcPayGapAdd = CAST(pc.Pay_Gap_Add AS decimal(12,4))
    FROM fms.Payroll_Calculated pc
    WHERE pc.LaborPayrollID = @LaborPayrollID;

    IF @Act IS NULL
        THROW 51070, 'HolidayMin8 test failed: LaborPayrollID not found in fms.Payroll_Calculated.', 1;

    SELECT TOP (1)
        @RuleCode = a.RuleCode,
        @RuleName = a.RuleName,
        @GuaranteeDate = a.GuaranteeDate,
        @HolidayName = h.HolidayName,
        @GroupActual = CAST(g.ActualQualifyingHours AS decimal(10,4)),
        @MinimumHours = CAST(g.MinimumHours AS decimal(10,4)),
        @GroupGap = CAST(g.GapHours AS decimal(10,4)),
        @AllocatedGap = CAST(a.AllocatedGapHours AS decimal(10,4)),
        @AllocatedPay = CAST(a.AllocatedGapPay AS decimal(12,4)),
        @Multiplier = CAST(a.MultiplierUsed AS decimal(10,4)),
        @AllocationMethod = a.AllocationMethod
    FROM api.v_UI_GuaranteeAllocations a
    JOIN api.v_UI_GuaranteeGroups g
        ON g.GuaranteeGroupID = a.GuaranteeGroupID
    LEFT JOIN dim.LU12_Holiday h
        ON h.[Date] = a.GuaranteeDate
    WHERE
        a.LaborPayrollID = @LaborPayrollID
        AND a.RuleCode = 'HOLIDAY_MIN_8'
    ORDER BY
        a.CalculatedAtUTC DESC,
        a.GuaranteeAllocationID DESC;

    SELECT
        TestName = 'Holiday_Min8',
        LaborPayrollID = @LaborPayrollID,
        RuleCode = @RuleCode,
        RuleName = @RuleName,
        GuaranteeDate = @GuaranteeDate,
        HolidayName = @HolidayName,
        GroupActualQualifyingHours = @GroupActual,
        MinimumHours = @MinimumHours,
        GroupGapHours = @GroupGap,
        AllocatedGapHours = @AllocatedGap,
        AllocatedGapPay = @AllocatedPay,
        MultiplierUsed = @Multiplier,
        AllocationMethod = @AllocationMethod,
        PayrollCalculated_Act_Total_Hrs = @Act,
        PayrollCalculated_Pay_Total_Hrs = @PayTotal,
        PayrollCalculated_Gap_Hrs_Total = @PcGap,
        PayrollCalculated_Pay_Gap_Add = @PcPayGapAdd;

    IF @RuleCode IS NULL
        THROW 51071, 'HolidayMin8 test failed: no HOLIDAY_MIN_8 allocation found for this LaborPayrollID.', 1;

    IF @HolidayName IS NULL
        THROW 51072, 'HolidayMin8 test failed: GuaranteeDate did not match dim.LU12_Holiday.', 1;

    IF ABS(@MinimumHours - 8.0) > @Tol
        THROW 51073, 'HolidayMin8 test failed: guarantee minimum hours is not ~ 8.0.', 1;

    IF ABS(@Multiplier - 3.0) > @Tol
        THROW 51074, 'HolidayMin8 test failed: holiday multiplier is not ~ 3.0.', 1;

    IF ABS(@GroupGap - (8.0 - @GroupActual)) > @Tol
        THROW 51075, 'HolidayMin8 test failed: group gap is not ~ (8 - group actual qualifying hours).', 1;

    IF ABS(@AllocatedGap - @GroupGap) > @Tol
        THROW 51076, 'HolidayMin8 test failed: allocated gap does not match group gap for this test case.', 1;

    IF ABS(@PcGap - @AllocatedGap) > @Tol
        THROW 51077, 'HolidayMin8 test failed: fms.Payroll_Calculated.Gap_Hrs_Total does not match allocated holiday gap.', 1;

    IF ABS(@PayTotal - (@Act + @AllocatedGap)) > @Tol
        THROW 51078, 'HolidayMin8 test failed: Pay_Total_Hrs is not Act_Total_Hrs + allocated holiday gap.', 1;

    PRINT 'Holiday minimum-8 rule validated successfully.';
END;
