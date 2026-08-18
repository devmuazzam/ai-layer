
-- wrapper stays the same, but recompile it anyway
CREATE   VIEW api.v_LaborEntry_AuditHeader
AS
SELECT * FROM audit.v_LaborEntry_AuditHeader;
