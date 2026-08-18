
CREATE   VIEW api.v_UI_Pricing_Slices_Advanced
AS
SELECT
    -- Keys
    LaborPayrollID, JobTicketID, JobCode, EmpID, Employee_Name, TicketDate, WorkDate,

    -- Windows
    Shift_Start, Shift_End, Boom_Start, Boom_End,

    -- Slice
    SliceIndex, Slice_Start, Slice_End, Slice_Hours,

    -- Labels/flags
    Holiday_Name, Week_Day, Day_Type, Accumulation_Status,
    Is_Boom_Active, Is_Outside_Window,

    -- Config thresholds
    Cfg_Start_Time, Cfg_End_Time, Limit_Reg, Limit_OT,

    -- Rate components
    Rate_Base, Rate_Shift, Rate_Boom, Rate_Boom_Applied,

    -- Multipliers
    Mul_OT, Mul_DT, Mul_Sat, Mul_Sun, Mul_Hol,
    Final_Multiplier,

    -- Final math
    Hourly_Rate_Raw, Effective_Rate, Slice_Pay

FROM api.v_Calc_Pricing_Slices;
