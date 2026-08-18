
-- 1) Create API wrapper (safe)
CREATE   VIEW api.v_Calc_Pricing_Master_Audit
AS
    SELECT * FROM calc.v_Calc_Pricing_Master_Audit;
