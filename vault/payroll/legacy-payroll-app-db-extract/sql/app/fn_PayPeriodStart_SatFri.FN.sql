
CREATE   FUNCTION app.fn_PayPeriodStart_SatFri (@AnyDate date)
RETURNS date
AS
BEGIN
    DECLARE @RefSat date = '2020-01-04'; -- known Saturday
    DECLARE @d int = DATEDIFF(DAY, @RefSat, @AnyDate);
    DECLARE @off int = ((@d % 7) + 7) % 7; -- 0..6
    RETURN DATEADD(DAY, -@off, @AnyDate);
END;
