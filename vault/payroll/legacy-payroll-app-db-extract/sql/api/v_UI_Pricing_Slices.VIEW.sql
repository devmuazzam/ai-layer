
CREATE   VIEW api.v_UI_Pricing_Slices
AS
SELECT
    LaborPayrollID,
    JobTicketID,
    JobCode,
    EmpID,
    Employee_Name,
    WorkDate,

    SliceIndex,
    Slice_Start,
    Slice_End,
    Slice_Hours,

    Day_Type,
    Accumulation_Status,
    Is_Outside_Window,
    Is_Boom_Active,

    Bucket_Label =
        CASE
            WHEN Final_Multiplier >= Mul_DT THEN 'DT'
            WHEN Final_Multiplier =  Mul_OT THEN 'OT'
            ELSE 'ST'
        END,

    Premium_Label =
        LTRIM(RTRIM(
            CONCAT(
                CASE WHEN Is_Outside_Window = 1 THEN 'OutsideWindow' ELSE '' END,
                CASE WHEN Is_Outside_Window = 1 AND Is_Boom_Active = 1 THEN ' + ' ELSE '' END,
                CASE
                    WHEN Is_Boom_Active = 1 AND COALESCE(Rate_Boom_Applied,0) > 0 THEN 'Boom'
                    WHEN Is_Boom_Active = 1 AND COALESCE(Rate_Boom_Applied,0) = 0 THEN 'BoomWindow'
                    ELSE ''
                END
            )
        )),

    RateComponents =
        CONCAT(
            'Base ', CONVERT(varchar(20), CAST(COALESCE(Rate_Base,0) AS decimal(10,2))),
            CASE
                WHEN COALESCE(Rate_Shift,0) <> 0
                THEN CONCAT(' + Shift ', CONVERT(varchar(20), CAST(Rate_Shift AS decimal(10,2))))
                ELSE ''
            END,
            CASE
                WHEN COALESCE(Rate_Boom_Applied,0) <> 0
                THEN CONCAT(' + Boom ', CONVERT(varchar(20), CAST(Rate_Boom_Applied AS decimal(10,2))))
                ELSE ''
            END
        ),

    Hourly_Rate_Raw,
    Final_Multiplier,
    Effective_Rate,
    Slice_Pay
FROM api.v_Calc_Pricing_Slices;
