

CREATE   VIEW app.v_LaborPayroll_CommentTokens
AS
WITH RawComments AS
(
    SELECT
        p.LaborPayrollID,
        p.EmpID,
        p.WorkDate,
        p.JobCode,
        p.WoCode,
        p.JobTicketID,
        p.CraftCode,

        LaborComments_Raw =
            TRY_CONVERT(nvarchar(max), p.Comments),

        LaborComments_Clean =
            NULLIF
            (
                LTRIM
                (
                    RTRIM
                    (
                        TRY_CONVERT
                        (
                            nvarchar(max),
                            app.fn_StripRTF(TRY_CONVERT(nvarchar(max), p.Comments))
                        )
                    )
                ),
                N''
            )
    FROM src.FMS_LABOR_PAYROLL_Raw p
),
Normalized AS
(
    SELECT
        r.*,

        LaborComments_Search =
            UPPER
            (
                REPLACE
                (
                    REPLACE
                    (
                        REPLACE
                        (
                            REPLACE
                            (
                                COALESCE(r.LaborComments_Clean, r.LaborComments_Raw, N''),
                                CHAR(160),
                                N' '
                            ),
                            CHAR(9),
                            N' '
                        ),
                        CHAR(13),
                        N' '
                    ),
                    CHAR(10),
                    N' '
                )
            )
    FROM RawComments r
),
TokenFlags AS
(
    SELECT
        n.*,

        Has_SHIFT_2 =
            CONVERT(bit,
                CASE
                    WHEN n.LaborComments_Search LIKE N'%(PAY:SHIFT_2)%'
                      OR n.LaborComments_Search LIKE N'%(SHIFT_2)%'
                    THEN 1 ELSE 0
                END
            ),

        Has_SHIFT_3 =
            CONVERT(bit,
                CASE
                    WHEN n.LaborComments_Search LIKE N'%(PAY:SHIFT_3)%'
                      OR n.LaborComments_Search LIKE N'%(SHIFT_3)%'
                    THEN 1 ELSE 0
                END
            ),

        Has_SUB_SHORT =
            CONVERT(bit,
                CASE
                    WHEN n.LaborComments_Search LIKE N'%(PAY:SUB_SHORT)%'
                      OR n.LaborComments_Search LIKE N'%(SUB_SHORT)%'
                    THEN 1 ELSE 0
                END
            ),

        Has_SUB_LONG =
            CONVERT(bit,
                CASE
                    WHEN n.LaborComments_Search LIKE N'%(PAY:SUB_LONG)%'
                      OR n.LaborComments_Search LIKE N'%(SUB_LONG)%'
                    THEN 1 ELSE 0
                END
            ),

        Has_WTL_0 =
            CONVERT(bit,
                CASE
                    WHEN n.LaborComments_Search LIKE N'%(PAY:WTL_0)%'
                      OR n.LaborComments_Search LIKE N'%(WTL_0)%'
                    THEN 1 ELSE 0
                END
            ),

        Has_WTL_1 =
            CONVERT(bit,
                CASE
                    WHEN n.LaborComments_Search LIKE N'%(PAY:WTL_1)%'
                      OR n.LaborComments_Search LIKE N'%(WTL_1)%'
                    THEN 1 ELSE 0
                END
            ),

        Has_WTL_2 =
            CONVERT(bit,
                CASE
                    WHEN n.LaborComments_Search LIKE N'%(PAY:WTL_2)%'
                      OR n.LaborComments_Search LIKE N'%(WTL_2)%'
                    THEN 1 ELSE 0
                END
            ),

        Has_WTL_3 =
            CONVERT(bit,
                CASE
                    WHEN n.LaborComments_Search LIKE N'%(PAY:WTL_3)%'
                      OR n.LaborComments_Search LIKE N'%(WTL_3)%'
                    THEN 1 ELSE 0
                END
            ),

        Has_WTL_4 =
            CONVERT(bit,
                CASE
                    WHEN n.LaborComments_Search LIKE N'%(PAY:WTL_4)%'
                      OR n.LaborComments_Search LIKE N'%(WTL_4)%'
                    THEN 1 ELSE 0
                END
            ),

        Has_WTL_Legacy =
            CONVERT(bit,
                CASE
                    WHEN n.LaborComments_Search LIKE N'%(PAY:WTL)%'
                      OR n.LaborComments_Search LIKE N'%(WTL)%'
                    THEN 1 ELSE 0
                END
            )
    FROM Normalized n
),
WTLComputed AS
(
    SELECT
        tf.*,

        WTL_TokenCount =
              CONVERT(int, tf.Has_WTL_0)
            + CONVERT(int, tf.Has_WTL_1)
            + CONVERT(int, tf.Has_WTL_2)
            + CONVERT(int, tf.Has_WTL_3)
            + CONVERT(int, tf.Has_WTL_4),

        WTL_Token_MissedMeals =
            CASE
                WHEN
                    (
                          CONVERT(int, tf.Has_WTL_0)
                        + CONVERT(int, tf.Has_WTL_1)
                        + CONVERT(int, tf.Has_WTL_2)
                        + CONVERT(int, tf.Has_WTL_3)
                        + CONVERT(int, tf.Has_WTL_4)
                    ) <> 1
                THEN NULL

                WHEN tf.Has_WTL_4 = 1 THEN 4
                WHEN tf.Has_WTL_3 = 1 THEN 3
                WHEN tf.Has_WTL_2 = 1 THEN 2
                WHEN tf.Has_WTL_1 = 1 THEN 1
                WHEN tf.Has_WTL_0 = 1 THEN 0
                ELSE NULL
            END,

        Has_WTL =
            CONVERT(bit,
                CASE
                    WHEN tf.Has_WTL_0 = 1
                      OR tf.Has_WTL_1 = 1
                      OR tf.Has_WTL_2 = 1
                      OR tf.Has_WTL_3 = 1
                      OR tf.Has_WTL_4 = 1
                      OR tf.Has_WTL_Legacy = 1
                    THEN 1 ELSE 0
                END
            ),

        Has_ConflictingWTLTokens =
            CONVERT(bit,
                CASE
                    WHEN
                        (
                              CONVERT(int, tf.Has_WTL_0)
                            + CONVERT(int, tf.Has_WTL_1)
                            + CONVERT(int, tf.Has_WTL_2)
                            + CONVERT(int, tf.Has_WTL_3)
                            + CONVERT(int, tf.Has_WTL_4)
                        ) > 1
                    THEN 1

                    WHEN tf.Has_WTL_Legacy = 1
                     AND
                        (
                              CONVERT(int, tf.Has_WTL_0)
                            + CONVERT(int, tf.Has_WTL_1)
                            + CONVERT(int, tf.Has_WTL_2)
                            + CONVERT(int, tf.Has_WTL_3)
                            + CONVERT(int, tf.Has_WTL_4)
                        ) > 0
                    THEN 1

                    ELSE 0
                END
            )
    FROM TokenFlags tf
)
SELECT
    LaborPayrollID,
    EmpID,
    WorkDate,
    JobCode,
    WoCode,
    JobTicketID,
    CraftCode,

    LaborComments_Raw,
    LaborComments_Clean,
    LaborComments_Search,

    Has_SHIFT_2,
    Has_SHIFT_3,
    Has_SUB_SHORT,
    Has_SUB_LONG,
    Has_WTL,

    Has_AnyPayToken =
        CONVERT(bit,
            CASE
                WHEN Has_SHIFT_2 = 1
                  OR Has_SHIFT_3 = 1
                  OR Has_SUB_SHORT = 1
                  OR Has_SUB_LONG = 1
                  OR Has_WTL = 1
                THEN 1 ELSE 0
            END
        ),

    Has_ConflictingShiftTokens =
        CONVERT(bit,
            CASE
                WHEN Has_SHIFT_2 = 1 AND Has_SHIFT_3 = 1
                THEN 1 ELSE 0
            END
        ),

    PayrollShiftCode_FromComments =
        CASE
            WHEN Has_SHIFT_3 = 1 THEN 3
            WHEN Has_SHIFT_2 = 1 THEN 2
            ELSE 1
        END,

    SubsistenceCode_FromComments =
        CASE
            WHEN Has_SUB_LONG = 1 THEN 'SUB_LONG'
            WHEN Has_SUB_SHORT = 1 THEN 'SUB_SHORT'
            ELSE NULL
        END,

    /* New WTL-specific fields */
    Has_WTL_0,
    Has_WTL_1,
    Has_WTL_2,
    Has_WTL_3,
    Has_WTL_4,
    Has_WTL_Legacy,
    WTL_TokenCount,
    WTL_Token_MissedMeals,
    Has_ConflictingWTLTokens
FROM WTLComputed;
