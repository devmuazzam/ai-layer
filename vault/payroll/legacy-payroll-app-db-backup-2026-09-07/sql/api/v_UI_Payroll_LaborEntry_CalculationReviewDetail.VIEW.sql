    api.v_UI_Payroll_LaborEntry_CalculationReviewDetail
AS

/*==============================================================
  UX-REVIEW-2E
  PERFORMANCE-OPTIMIZED DETAIL VIEW

  Key performance change:
    REMOVED:
      api.v_UI_Payroll_LaborEntry_WeekDetail_WithBuckets

    REPLACED WITH:
      app.v_Base_LaborPayroll.HoursWorked_Raw
      api.v_UI_Payroll_LaborEntry_HourBuckets.Bucket_Source

  HourBuckets is joined by CalcID + LaborPayrollID so the
  canonical bucket source belongs to the same calculated row.

  NO PAYROLL CALCULATION LOGIC IS CHANGED.
==============================================================*/

WITH ExceptionBase AS
(
    SELECT
        ex.RunId,
        pc.CalcID,
        ex.LaborPayrollID,

        WorkDate =
            CONVERT(date, pc.WorkDate),

        pc.EmpID,
        pc.Employee_Name,

        b.JobTicketID,
        b.JobCode,
        b.UnionCode,

        e.PayrollGroup,

        hb.Bucket_Source,

        HoursWorked_Raw =
            b.HoursWorked_Raw,

        pc.Act_Total_Hrs,

        ExceptionReason =
            ex.Reason,

        ExceptionShiftStart =
            ex.Shift_Start,

        ExceptionShiftEnd =
            ex.Shift_End

    FROM fms.Payroll_CalcException ex

    JOIN fms.Payroll_Calculated pc
        ON pc.RunId = ex.RunId
       AND pc.LaborPayrollID = ex.LaborPayrollID

    LEFT JOIN app.v_Base_LaborPayroll b
        ON b.LaborPayrollID = ex.LaborPayrollID

    LEFT JOIN api.v_UI_Employee_PayrollGroupRate e
        ON e.EmpID = b.EmpID

    LEFT JOIN api.v_UI_Payroll_LaborEntry_HourBuckets hb
        ON hb.CalcID = pc.CalcID
       AND hb.LaborPayrollID = ex.LaborPayrollID

    WHERE
           ex.Reason LIKE 'Warn_DuplicateWindow%'
        OR ex.Reason LIKE 'Warn_Overlap%'
        OR ex.Reason LIKE '%Possible24Plus%'
        OR ex.Reason LIKE '%Warn_Reconstruction_ShiftMismatch%'

        OR ex.Reason LIKE
           'WTL warning: labor entry grouped with another labor entry for WTL rules.%'

        OR ex.Reason LIKE
           'WTL warning: grouped labor entries overlap.%'

        OR ex.Reason LIKE
           'WTL warning: no WTL token found; assuming WTL_0.%'

        OR ex.Reason LIKE
           'WTL error: multiple or conflicting WTL tokens found.%'

        OR ex.Reason LIKE
           'WTL review: grouped labor span exceeds configured threshold.%'

        OR ex.Reason LIKE
           'WTL error: WTL token exceeds computed maximum meal periods.%'

        OR ex.Reason LIKE
           'WTL review: one or more modeled meal periods did not match a priced slice.%'
),

ExceptionNotes AS
(
    SELECT
        e.RunId,
        e.CalcID,
        e.LaborPayrollID,
        e.WorkDate,
        e.EmpID,
        e.Employee_Name,
        e.JobTicketID,
        e.JobCode,
        e.UnionCode,
        e.PayrollGroup,
        e.Bucket_Source,

        NoteType =
            CONVERT(varchar(10), n.NoteType),

        NoteCode =
            CONVERT(varchar(60), n.NoteCode),

        NoteTitle =
            CONVERT(varchar(100), n.NoteTitle),

        PayrollMessage =
            CONVERT(nvarchar(1000), n.PayrollMessage),

        ActionNeeded =
            CONVERT(bit, n.ActionNeeded),

        TechnicalReason =
            CONVERT(nvarchar(1000), e.ExceptionReason),

        DisplaySort =
            CONVERT(int, n.DisplaySort),

        DedupeKey =
            CONVERT(nvarchar(400), n.DedupeKey)

    FROM ExceptionBase e

    CROSS APPLY
    (
        VALUES

        /*------------------------------------------------------
          DUPLICATE WINDOW
        ------------------------------------------------------*/
        (
            CASE
                WHEN e.ExceptionReason LIKE 'Warn_DuplicateWindow%'
                    THEN 1
                ELSE 0
            END,

            'REVIEW',
            'DUPLICATE_WINDOW',
            'Possible duplicate labor entries',

            CONVERT
            (
                nvarchar(max),
                CONCAT
                (
                    'Possible duplicate labor entries: another labor entry ',
                    'has the same time window from ',
                    CONVERT(char(5), e.ExceptionShiftStart, 108),
                    ' to ',
                    CONVERT(char(5), e.ExceptionShiftEnd, 108),
                    '. Verify that both entries should be paid.'
                )
            ),

            1,
            10,

            CONVERT
            (
                nvarchar(400),
                CONCAT
                (
                    'DUPLICATE_WINDOW|',
                    e.EmpID,
                    '|',
                    CONVERT(char(10), e.WorkDate, 23),
                    '|',
                    CONVERT(char(16), e.ExceptionShiftStart, 120),
                    '|',
                    CONVERT(char(16), e.ExceptionShiftEnd, 120)
                )
            )
        ),


        /*------------------------------------------------------
          GENERIC LABOR OVERLAP
        ------------------------------------------------------*/
        (
            CASE
                WHEN e.ExceptionReason LIKE 'Warn_Overlap%'
                    THEN 1
                ELSE 0
            END,

            'REVIEW',
            'LABOR_OVERLAP',
            'Overlapping labor entries',

            CONVERT
            (
                nvarchar(max),
                'Overlapping labor entries: this entry overlaps the previous labor entry. Verify the start/end times for both entries.'
            ),

            1,
            20,

            CONVERT
            (
                nvarchar(400),
                CONCAT
                (
                    'LABOR_OVERLAP|',
                    e.RunId,
                    '|',
                    e.LaborPayrollID
                )
            )
        ),


        /*------------------------------------------------------
          POSSIBLE 24+ RECONSTRUCTION
        ------------------------------------------------------*/
        (
            CASE
                WHEN e.ExceptionReason LIKE '%Possible24Plus%'
                    THEN 1
                ELSE 0
            END,

            'REVIEW',
            'RECONSTRUCTION_24_PLUS',
            '24+ hour reconstruction review',

            CONVERT
            (
                nvarchar(max),
                CONCAT
                (
                    '24+ hour review required: FCC Hours Worked is ',
                    CONVERT
                    (
                        varchar(20),
                        CONVERT(decimal(10,2), e.HoursWorked_Raw)
                    ),
                    'h while PayrollAPP reconstructed ',
                    CONVERT
                    (
                        varchar(20),
                        CONVERT(decimal(10,2), e.Act_Total_Hrs)
                    ),
                    'h from the labor time window. ',
                    'Verify the correct payable hours.'
                )
            ),

            1,
            30,

            CONVERT
            (
                nvarchar(400),
                CONCAT
                (
                    'RECONSTRUCTION_24_PLUS|',
                    e.RunId,
                    '|',
                    e.LaborPayrollID
                )
            )
        ),


        /*------------------------------------------------------
          RECONSTRUCTION SHIFT MISMATCH
        ------------------------------------------------------*/
        (
            CASE
                WHEN e.ExceptionReason LIKE
                     '%Warn_Reconstruction_ShiftMismatch%'
                    THEN 1
                ELSE 0
            END,

            'REVIEW',
            'RECONSTRUCTION_SHIFT_MISMATCH',
            'Labor / ticket time mismatch',

            CONVERT
            (
                nvarchar(max),
                'Labor / ticket time review: PayrollAPP reconstructed labor times that differ from the ticket shift times. Verify the source labor and ticket times.'
            ),

            1,
            40,

            CONVERT
            (
                nvarchar(400),
                CONCAT
                (
                    'RECONSTRUCTION_SHIFT_MISMATCH|',
                    e.RunId,
                    '|',
                    e.LaborPayrollID
                )
            )
        ),


        /*------------------------------------------------------
          WTL GROUPING - INFO
        ------------------------------------------------------*/
        (
            CASE
                WHEN e.Bucket_Source = 'PRICING_SLICES'
                 AND e.UnionCode = 'L12'
                 AND e.ExceptionReason LIKE
                     'WTL warning: labor entry grouped with another labor entry for WTL rules.%'
                    THEN 1
                ELSE 0
            END,

            'INFO',
            'WTL_GROUPING',
            'WTL labor grouping',

            CONVERT
            (
                nvarchar(max),
                'WTL grouping: multiple labor entries were evaluated together for meal-period rules.'
            ),

            0,
            100,

            CONVERT
            (
                nvarchar(400),
                CONCAT
                (
                    'WTL_GROUPING|',
                    e.RunId,
                    '|',
                    e.LaborPayrollID
                )
            )
        ),


        /*------------------------------------------------------
          WTL OVERLAPPING GROUP - INFO
        ------------------------------------------------------*/
        (
            CASE
                WHEN e.Bucket_Source = 'PRICING_SLICES'
                 AND e.UnionCode = 'L12'
                 AND e.ExceptionReason LIKE
                     'WTL warning: grouped labor entries overlap.%'
                    THEN 1
                ELSE 0
            END,

            'INFO',
            'WTL_GROUP_OVERLAP',
            'WTL overlapping-entry grouping',

            CONVERT
            (
                nvarchar(max),
                'WTL grouping: overlapping labor entries were evaluated together for meal-period rules.'
            ),

            0,
            105,

            CONVERT
            (
                nvarchar(400),
                CONCAT
                (
                    'WTL_GROUP_OVERLAP|',
                    e.RunId,
                    '|',
                    e.LaborPayrollID
                )
            )
        ),


        /*------------------------------------------------------
          MISSING WTL TOKEN
        ------------------------------------------------------*/
        (
            CASE
                WHEN e.Bucket_Source = 'PRICING_SLICES'
                 AND e.UnionCode = 'L12'
                 AND e.ExceptionReason LIKE
                     'WTL warning: no WTL token found; assuming WTL_0.%'
                    THEN 1
                ELSE 0
            END,

            'REVIEW',
            'WTL_MISSING_TOKEN',
            'Lunch / WTL code missing',

            CONVERT
            (
                nvarchar(max),
                'Lunch / WTL code missing: no WTL token was found, so the current legacy WTL_0 behavior was used. Verify the lunch / WTL coding.'
            ),

            1,
            110,

            CONVERT
            (
                nvarchar(400),
                CONCAT
                (
                    'WTL_MISSING_TOKEN|',
                    e.RunId,
                    '|',
                    e.LaborPayrollID
                )
            )
        ),


        /*------------------------------------------------------
          CONFLICTING WTL TOKENS
        ------------------------------------------------------*/
        (
            CASE
                WHEN e.Bucket_Source = 'PRICING_SLICES'
                 AND e.UnionCode = 'L12'
                 AND e.ExceptionReason LIKE
                     'WTL error: multiple or conflicting WTL tokens found.%'
                    THEN 1
                ELSE 0
            END,

            'REVIEW',
            'WTL_CONFLICTING_TOKENS',
            'WTL code conflict',

            CONVERT
            (
                nvarchar(max),
                'WTL code conflict: multiple or conflicting WTL tokens were found. Verify the lunch / WTL coding.'
            ),

            1,
            120,

            CONVERT
            (
                nvarchar(400),
                CONCAT
                (
                    'WTL_CONFLICTING_TOKENS|',
                    e.RunId,
                    '|',
                    e.LaborPayrollID
                )
            )
        ),


        /*------------------------------------------------------
          WTL GROUP SPAN THRESHOLD
        ------------------------------------------------------*/
        (
            CASE
                WHEN e.Bucket_Source = 'PRICING_SLICES'
                 AND e.UnionCode = 'L12'
                 AND e.ExceptionReason LIKE
                     'WTL review: grouped labor span exceeds configured threshold.%'
                    THEN 1
                ELSE 0
            END,

            'REVIEW',
            'WTL_GROUP_SPAN_THRESHOLD',
            'WTL grouped span review',

            CONVERT
            (
                nvarchar(max),
                'WTL review: the grouped labor span falls outside the configured meal-period thresholds. Verify the labor times and lunch / WTL coding.'
            ),

            1,
            130,

            CONVERT
            (
                nvarchar(400),
                CONCAT
                (
                    'WTL_GROUP_SPAN_THRESHOLD|',
                    e.RunId,
                    '|',
                    e.LaborPayrollID
                )
            )
        ),


        /*------------------------------------------------------
          WTL TOKEN EXCEEDS COMPUTED MAX
        ------------------------------------------------------*/
        (
            CASE
                WHEN e.Bucket_Source = 'PRICING_SLICES'
                 AND e.UnionCode = 'L12'
                 AND e.ExceptionReason LIKE
                     'WTL error: WTL token exceeds computed maximum meal periods.%'
                    THEN 1
                ELSE 0
            END,

            'REVIEW',
            'WTL_TOKEN_EXCEEDS_MAX',
            'WTL code exceeds meal maximum',

            CONVERT
            (
                nvarchar(max),
                'WTL review: the WTL code specifies more missed meals than the calculated labor span allows. Verify the labor times and lunch / WTL coding.'
            ),

            1,
            140,

            CONVERT
            (
                nvarchar(400),
                CONCAT
                (
                    'WTL_TOKEN_EXCEEDS_MAX|',
                    e.RunId,
                    '|',
                    e.LaborPayrollID
                )
            )
        ),


        /*------------------------------------------------------
          WTL MODELED MEAL DID NOT MATCH PRICED SLICE
        ------------------------------------------------------*/
        (
            CASE
                WHEN e.Bucket_Source = 'PRICING_SLICES'
                 AND e.UnionCode = 'L12'
                 AND e.ExceptionReason LIKE
                     'WTL review: one or more modeled meal periods did not match a priced slice.%'
                    THEN 1
                ELSE 0
            END,

            'REVIEW',
            'WTL_NO_MATCHED_SLICE',
            'WTL meal-period pricing review',

            CONVERT
            (
                nvarchar(max),
                'WTL review: one or more modeled meal periods did not match a priced payroll slice. Review the labor times and meal-period calculation.'
            ),

            1,
            150,

            CONVERT
            (
                nvarchar(400),
                CONCAT
                (
                    'WTL_NO_MATCHED_SLICE|',
                    e.RunId,
                    '|',
                    e.LaborPayrollID
                )
            )
        )

    ) n
    (
        IsEnabled,
        NoteType,
        NoteCode,
        NoteTitle,
        PayrollMessage,
        ActionNeeded,
        DisplaySort,
        DedupeKey
    )

    WHERE n.IsEnabled = 1
),

RestNotes AS
(
    SELECT
        pc.RunId,
        pc.CalcID,
        pc.LaborPayrollID,

        WorkDate =
            CONVERT(date, pc.WorkDate),

        pc.EmpID,
        pc.Employee_Name,

        b.JobTicketID,
        b.JobCode,
        b.UnionCode,

        e.PayrollGroup,

        hb.Bucket_Source,

        NoteType =
            CONVERT(varchar(10), 'INFO'),

        NoteCode =
            CONVERT(varchar(60), 'REST_CONTINUITY'),

        NoteTitle =
            CONVERT(varchar(100), 'Rest-period continuity'),

        PayrollMessage =
            CONVERT
            (
                nvarchar(1000),
                CONCAT
                (
                    'Rest-period continuity: ',
                    CONVERT
                    (
                        varchar(20),
                        CONVERT
                        (
                            decimal(10,2),
                            pc.Rest_Gap_Hrs_FromPrevChain
                        )
                    ),
                    ' hours of rest occurred before this labor, so prior ',
                    'qualifying work remained relevant to the required ',
                    'rest-period calculation.'
                )
            ),

        ActionNeeded =
            CONVERT(bit, 0),

        TechnicalReason =
            CONVERT
            (
                nvarchar(1000),
                CONCAT
                (
                    'Rest_IsForced=1; Rest_ChainId=',
                    COALESCE
                    (
                        CONVERT(varchar(20), pc.Rest_ChainId),
                        'NULL'
                    ),
                    '; GapHours=',
                    COALESCE
                    (
                        CONVERT
                        (
                            varchar(20),
                            pc.Rest_Gap_Hrs_FromPrevChain
                        ),
                        'NULL'
                    )
                )
            ),

        DisplaySort =
            CONVERT(int, 200),

        DedupeKey =
            CONVERT
            (
                nvarchar(400),
                CONCAT
                (
                    'REST_CONTINUITY|',
                    pc.RunId,
                    '|',
                    pc.LaborPayrollID
                )
            )

    FROM fms.Payroll_Calculated pc

    LEFT JOIN app.v_Base_LaborPayroll b
        ON b.LaborPayrollID = pc.LaborPayrollID

    LEFT JOIN api.v_UI_Employee_PayrollGroupRate e
        ON e.EmpID = b.EmpID

    LEFT JOIN api.v_UI_Payroll_LaborEntry_HourBuckets hb
        ON hb.CalcID = pc.CalcID
       AND hb.LaborPayrollID = pc.LaborPayrollID

    WHERE pc.Rest_IsForced = 1
      AND hb.Bucket_Source = 'PRICING_SLICES'
      AND b.UnionCode = 'L12'
)

SELECT
    RunId,
    CalcID,
    LaborPayrollID,
    WorkDate,
    EmpID,
    Employee_Name,
    JobTicketID,
    JobCode,
    UnionCode,
    PayrollGroup,
    Bucket_Source,
    NoteType,
    NoteCode,
    NoteTitle,
    PayrollMessage,
    ActionNeeded,
    TechnicalReason,
    DisplaySort,
    DedupeKey

FROM ExceptionNotes

UNION ALL

SELECT
    RunId,
    CalcID,
    LaborPayrollID,
    WorkDate,
    EmpID,
    Employee_Name,
    JobTicketID,
    JobCode,
    UnionCode,
    PayrollGroup,
    Bucket_Source,
    NoteType,
    NoteCode,
    NoteTitle,
    PayrollMessage,
    ActionNeeded,
    TechnicalReason,
    DisplaySort,
    DedupeKey

FROM RestNotes;

