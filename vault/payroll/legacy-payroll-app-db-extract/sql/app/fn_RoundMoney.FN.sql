
CREATE   FUNCTION app.fn_RoundMoney
(
    @Amount decimal(38,10)
)
RETURNS decimal(19,2)
WITH SCHEMABINDING
AS
BEGIN
    RETURN CONVERT(decimal(19,2), ROUND(@Amount, 2));
END;
