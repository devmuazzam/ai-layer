
CREATE   PROCEDURE test.usp_Test_SpecialSaturday_Min8
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
        WHERE RuleCode = 'SPECIAL_SAT_MIN_8'
        ORDER BY
            GuaranteeDate DESC,
            CalculatedAtUTC DESC,
            GuaranteeAllocationID DESC;
    END;

    IF @LaborPayrollID IS NULL
        THROW 51079, 'SpecialSaturdayMin8 test skipped/failed: no SPECIAL_SAT_MIN_8 allocation exists. Recalculate a special Saturday date range first.', 1;

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
        THROW 51080, 'SpecialSaturdayMin8 test failed: LaborPayrollID not found in fms.Payroll_Calculated.', 1;

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
        AND a.RuleCode = 'SPECIAL_SAT_MIN_8'
    ORDER BY
        a.CalculatedAtUTC DESC,
        a.GuaranteeAllocationID DESC;

    SELECT
        TestName = 'SpecialSaturday_Min8',
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
        THROW 51081, 'SpecialSaturdayMin8 test failed: no SPECIAL_SAT_MIN_8 allocation found for this LaborPayrollID.', 1;

    IF @HolidayName IS NOT NULL AND @HolidayName NOT LIKE '%Special Saturday%'
        THROW 51082, 'SpecialSaturdayMin8 test failed: GuaranteeDate is not labeled as a Special Saturday in dim.LU12_Holiday.', 1;

    IF ABS(@MinimumHours - 8.0) > @Tol
        THROW 51083, 'SpecialSaturdayMin8 test failed: guarantee minimum hours is not ~ 8.0.', 1;

    IF ABS(@Multiplier - 2.0) > @Tol
        THROW 51084, 'SpecialSaturdayMin8 test failed: special Saturday multiplier is not ~ 2.0.', 1;

    IF ABS(@GroupGap - (8.0 - @GroupActual)) > @Tol
        THROW 51085, 'SpecialSaturdayMin8 test failed: group gap is not ~ (8 - group actual qualifying hours).', 1;

    IF ABS(@AllocatedGap - @GroupGap) > @Tol
        THROW 51086, 'SpecialSaturdayMin8 test failed: allocated gap does not match group gap for this test case.', 1;

    IF ABS(@PcGap - @AllocatedGap) > @Tol
        THROW 51087, 'SpecialSaturdayMin8 test failed: fms.Payroll_Calculated.Gap_Hrs_Total does not match allocated special Saturday gap.', 1;

    IF ABS(@PayTotal - (@Act + @AllocatedGap)) > @Tol
        THROW 51088, 'SpecialSaturdayMin8 test failed: Pay_Total_Hrs is not Act_Total_Hrs + allocated special Saturday gap.', 1;

    PRINT 'Special Saturday minimum-8 rule validated successfully.';
END;
