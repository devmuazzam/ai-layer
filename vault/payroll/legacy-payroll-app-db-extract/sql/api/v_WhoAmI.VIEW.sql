CREATE   VIEW api.v_WhoAmI
AS
SELECT
  ORIGINAL_LOGIN() AS OriginalLogin,
  SUSER_SNAME()    AS CurrentLogin,
  USER_NAME()      AS DbUser,
  DB_NAME()        AS DbName,
  HOST_NAME()      AS HostName,
  APP_NAME()       AS AppName;
