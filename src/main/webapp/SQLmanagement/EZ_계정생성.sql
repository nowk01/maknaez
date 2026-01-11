------------------------------------------------------
-- 프로젝트 계정 생성
-- Username : ez
-- Password : maknaez$!
-- Hostname: 211.238.142.95
-- Port : 1521
-- Service Name : XE

ALTER SESSION SET "_ORACLE_SCRIPT" = true;

DROP USER ez CASCADE;

GRANT CONNECT, RESOURCE, UNLIMITED TABLESPACE TO ez IDENTIFIED BY "maknaez$!";
ALTER USER ez DEFAULT TABLESPACE USERS;
ALTER USER ez TEMPORARY TABLESPACE TEMP;

CONN ez/"maknaez$!";
---------------------------