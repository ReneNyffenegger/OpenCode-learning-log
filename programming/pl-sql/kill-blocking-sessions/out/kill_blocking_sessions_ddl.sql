-- ===========================================================================
-- DDL fuer die Log-Tabelle der Stored Procedure kill_blocking_sessions
-- ===========================================================================

-- Log-Tabelle: Protokolliert alle getoeteten blockierenden Sessions
-- sowie auftretende Fehler.
create table kill_blocking_sessions_log (
    id                    number generated always as identity primary key,
    log_time              date           default sysdate not null,
    blocking_sid          number,
    blocking_serial#      number,
    blocking_osuser       varchar2(128),
    blocked_sid           number,
    blocked_serial#       number,
    blocked_osuser        varchar2(128),
    blocked_sql           clob,
    blocked_object        varchar2(128),
    action                varchar2(30),
    error_message         clob
);

-- Kommentar auf Tabellenebene
comment on table kill_blocking_sessions_log is
    'Protokolltabelle fuer die Stored Procedure kill_blocking_sessions';

comment on column kill_blocking_sessions_log.log_time is
    'Zeitpunkt des Eintrags';

comment on column kill_blocking_sessions_log.blocking_sid is
    'SID der blockierenden Session';

comment on column kill_blocking_sessions_log.blocking_serial# is
    'Serial# der blockierenden Session';

comment on column kill_blocking_sessions_log.blocking_osuser is
    'Betriebssystem-Benutzer der blockierenden Session';

comment on column kill_blocking_sessions_log.blocked_sid is
    'SID der blockierten Session';

comment on column kill_blocking_sessions_log.blocked_serial# is
    'Serial# der blockierten Session';

comment on column kill_blocking_sessions_log.blocked_osuser is
    'Betriebssystem-Benutzer der blockierten Session';

comment on column kill_blocking_sessions_log.blocked_sql is
    'SQL-Anweisung der blockierten Session';

comment on column kill_blocking_sessions_log.blocked_object is
    'Name des blockierten Objekts (Tabelle)';

comment on column kill_blocking_sessions_log.action is
    'Durchgefuehrte Aktion (KILL SESSION oder ERROR)';

comment on column kill_blocking_sessions_log.error_message is
    'Fehlermeldung bei Auftreten einer Exception';

-- Lesezugriff fuer den Benutzer rene
grant select on kill_blocking_sessions_log to rene;
