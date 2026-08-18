
CREATE VIEW [app].[v_Base_LaborPayroll] AS
SELECT 
    -- 1. Identity & Keys
    P.LaborPayrollID,
    P.JobTicketID,
    P.JobCode,
    P.WoCode,
    P.JobLineItemID,
    P.WoDetailID,
    P.JobEmpID,
    
    -- The "Trigger" for Shift Rules
    ISNULL(NULLIF(P.ShiftInfo, ''), '1') AS Shift_Code_Raw,
    
    -- 2. Dates & Times
    P.WorkDate,
    P.TimeStart AS TimeStart_Labor,
    P.TimeEnd   AS TimeEnd_Labor,
    P.ProcessedDate,

    -- 3. The "Source Truth" Financials
    P.WorkedHrs AS HoursWorked_Raw,
    P.Rate      AS Source_Rate_Raw,
    P.Amount    AS Source_Amount_Raw,
    
    -- 4. Employee Info
    P.EmpID,
    ISNULL(CONCAT(E.FName, ' ', E.LName), 'Unknown') AS Employee_Name,

    -- 5. Union & Craft Details
    P.UnionCode,
    P.CraftCode,
    ISNULL(Cr.Description, 'Unknown') AS CraftDescription,
    UC.PayRate AS CraftPayRate, 

    P.CraftModifierCode,
    ISNULL(CM.Description, 'Unknown') AS CraftModifierDescription,
    UCM.PayRateChange AS CraftModifierPayRateAdjustment, 
    P.UnionApprenticePerc AS UnionApprenticePercent,

    -- 6. Classification Logic
    P.ClassCode,
    ISNULL(Cls.Description, 'Unknown') AS ClassDescription,
    CASE Cls.Labor 
        WHEN 'L' THEN 'Labor' 
        WHEN 'M' THEN 'Material' 
        WHEN 'B' THEN 'Both' 
        ELSE 'Unknown' 
    END AS LaborType,
    CASE WHEN Cls.UseCertifiedPayroll = 1 THEN 'Yes' ELSE 'No' END AS UseCertifiedPayroll,

    -- 7. Unit Details
    P.UnitCode,
    ISNULL(U.UnitName, 'Unknown') AS UnitName,
    ISNULL(UT.Description, 'Unknown') AS UnitDescription,       
    ISNULL(UST.Description, 'Unknown') AS UnitScheduleType,     
    P.ActivityCode,
    ISNULL(A.Description, 'Unknown') AS ActivityDescription,

    -- 8. Status Flags
    P.Processed,
    CASE WHEN P.Processed = 1 THEN 'Yes' ELSE 'No' END AS Is_Processed,
    P.Approval,
    CASE WHEN P.Approval = 1 THEN 'Approved' ELSE 'Pending' END AS Approval_Status,
    P.ApprovalBy,
    P.ApprovalDate,
    P.Billable,
    CASE WHEN P.Billable = 1 THEN 'Yes' ELSE 'No' END AS Is_Billable,
    P.WorkThruLunch,
    CASE WHEN P.WorkThruLunch = 1 THEN 'Yes' ELSE 'No' END AS WorkedThruLunch,

    P.AtomLabor,

    /* ============================================================
       IMPORTANT CHANGE:
       Is_AtomLabor is now a real BIT (0/1), not 'Yes'/'No'
       ============================================================ */
    CONVERT(bit,
        CASE
            WHEN TRY_CONVERT(int, P.AtomLabor) = 1 THEN 1
            WHEN UPPER(LTRIM(RTRIM(CONVERT(varchar(10), P.AtomLabor)))) IN ('YES','Y','TRUE','T','1') THEN 1
            ELSE 0
        END
    ) AS Is_AtomLabor,

    /* Optional (UI-friendly): keep a Yes/No label too */
    CASE
        WHEN CONVERT(bit,
            CASE
                WHEN TRY_CONVERT(int, P.AtomLabor) = 1 THEN 1
                WHEN UPPER(LTRIM(RTRIM(CONVERT(varchar(10), P.AtomLabor)))) IN ('YES','Y','TRUE','T','1') THEN 1
                ELSE 0
            END
        ) = 1 THEN 'Yes' ELSE 'No'
    END AS Is_AtomLabor_Label,

    P.StdJobTicketHours,
    CASE WHEN P.StdJobTicketHours = 1 THEN 'Yes' ELSE 'No' END AS Is_StandardHours,

    -- 9. Change Notifications
    P.NotifyQtyChg,
    CASE WHEN P.NotifyQtyChg = 1 THEN 'Changed_Input' ELSE 'Original_Input' END AS Status_QtyChange,
    P.NotifyRateChg,
    CASE WHEN P.NotifyRateChg = 1 THEN 'Changed_Input' ELSE 'Original_Input' END AS Status_RateChange,
    P.NotifyCommentsChg,
    CASE WHEN P.NotifyCommentsChg = 1 THEN 'Changed_Input' ELSE 'Original_Input' END AS Status_CommentsChange,
    P.NotifyCraftChg,
    CASE WHEN P.NotifyCraftChg = 1 THEN 'Changed_Input' ELSE 'Original_Input' END AS Status_CraftChange,
    P.NotifyCraftModifierChg,
    CASE WHEN P.NotifyCraftModifierChg = 1 THEN 'Changed_Input' ELSE 'Original_Input' END AS Status_CraftModChange,
    P.NotifyShiftInfoChg,
    CASE WHEN P.NotifyShiftInfoChg = 1 THEN 'Changed_Input' ELSE 'Original_Input' END AS Status_ShiftInfoChange,
    P.NotifyNewRow,
    CASE WHEN P.NotifyNewRow = 1 THEN 'New_Row_Added' ELSE 'Original_Input' END AS Status_NewRow,

    -- 10. Financial Codes
    P.WorkerCompCode,
    P.BurdenCode,
    P.Perdiem

FROM src.FMS_LABOR_PAYROLL_Raw P
LEFT JOIN src.FMS_EMPLOYEES_Raw E
    ON P.EmpID = E.EmpID
LEFT JOIN src.FMS_CRAFTS_Raw Cr
    ON P.CraftCode = Cr.CraftCode
LEFT JOIN src.FMS_UNION_CRAFT_Raw UC
    ON P.CraftCode = UC.CraftCode 
LEFT JOIN src.FMS_CRAFT_MODIFIER_Raw CM
    ON P.CraftModifierCode = CM.CraftModifierCode
LEFT JOIN src.FMS_UNION_CRAFT_MODIFIER_Raw UCM 
    ON P.CraftModifierCode = UCM.CraftModifierCode 
   AND P.UnionCode = UCM.UnionCode
LEFT JOIN src.FMS_CLASSIFICATIONS_Raw Cls
    ON P.ClassCode = Cls.ClassCode
LEFT JOIN src.FMS_ACTIVITIES_Raw A
    ON P.ActivityCode = A.ActivityCode
LEFT JOIN src.FMS_UNITS_Raw U
    ON P.UnitCode = U.UnitCode
LEFT JOIN src.FMS_UNIT_TYPES_Raw UT
    ON U.UnitTypeID = UT.UnitTypeID
LEFT JOIN src.FMS_SCHEDULE_TYPES_Raw UST
    ON U.UnitSchedType = UST.UnitSchedCode;
