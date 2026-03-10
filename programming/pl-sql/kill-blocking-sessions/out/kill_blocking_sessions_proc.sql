-- ===========================================================================
-- Stored Procedure: kill_blocking_sessions
--
-- Beschreibung:
--   Beendet blockierende Sessions, wenn das blockierte Objekt
--   besitzer oder gpanztag ist.
--   Die Prozedur laeuft in einer Endlosschleife und prueft alle
--   60 Sekunden auf neue blockierende Sessions.
--   Alle Aktionen und Fehler werden in der Tabelle
--   kill_blocking_sessions_log protokolliert.
-- ===========================================================================

create or replace procedure kill_blocking_sessions
is
    -- Cursor: Ermittelt alle blockierenden Sessions fuer die
    -- relevanten Tabellen (besitzer, gpanztag).
    cursor c_blocking_sessions is
        select
            blocker.sid           as blocking_sid,
            blocker.serial#       as blocking_serial,
            blocker.osuser        as blocking_osuser,
            blocked.sid           as blocked_sid,
            blocked.serial#       as blocked_serial,
            blocked.osuser        as blocked_osuser,
            blocked.sql_id        as blocked_sql_id,
            do.object_name        as blocked_object
        from
            v$lock l1
            join v$lock l2
                on  l1.id1 = l2.id1
                and l1.id2 = l2.id2
                and l1.block = 1
                and l2.request > 0
            join v$session blocker
                on blocker.sid = l1.sid
            join v$session blocked
                on blocked.sid = l2.sid
            join v$locked_object lo
                on lo.session_id = blocked.sid
            join dba_objects do
                on do.object_id = lo.object_id
        where
            lower(do.object_name) in ('besitzer', 'gpanztag');

    v_blocked_sql    clob;
    v_kill_stmt      varchar2(200);
    v_error_msg      varchar2(4000);
begin
    -- Aeussere Schleife: Endlosschleife mit 60 Sekunden Pause
    loop
        -- Innere Schleife: Alle blockierenden Sessions durchgehen
        for rec in c_blocking_sessions loop
            begin
                -- SQL-Anweisung der blockierten Session ermitteln
                v_blocked_sql := null;
                if rec.blocked_sql_id is not null then
                    begin
                        select sql_fulltext
                        into   v_blocked_sql
                        from   v$sqlarea
                        where  sql_id = rec.blocked_sql_id;
                    exception
                        when no_data_found then
                            v_blocked_sql := null;
                    end;
                end if;

                -- Blockierende Session beenden
                v_kill_stmt := 'alter system kill session '''
                    || rec.blocking_sid || ',' || rec.blocking_serial
                    || ''' immediate';
                execute immediate v_kill_stmt;

                -- Erfolgreiche Aktion protokollieren
                insert into kill_blocking_sessions_log (
                    log_time,
                    blocking_sid,
                    blocking_serial#,
                    blocking_osuser,
                    blocked_sid,
                    blocked_serial#,
                    blocked_osuser,
                    blocked_sql,
                    blocked_object,
                    action,
                    error_message
                ) values (
                    sysdate,
                    rec.blocking_sid,
                    rec.blocking_serial,
                    rec.blocking_osuser,
                    rec.blocked_sid,
                    rec.blocked_serial,
                    rec.blocked_osuser,
                    v_blocked_sql,
                    rec.blocked_object,
                    'KILL SESSION',
                    null
                );
                commit;

            exception
                when others then
                    -- Fehlermeldung in Variable speichern, da sqlerrm
                    -- nicht direkt in SQL-Anweisungen verwendet werden darf
                    v_error_msg := sqlerrm;

                    -- Fehler protokollieren
                    insert into kill_blocking_sessions_log (
                        log_time,
                        blocking_sid,
                        blocking_serial#,
                        blocking_osuser,
                        blocked_sid,
                        blocked_serial#,
                        blocked_osuser,
                        blocked_sql,
                        blocked_object,
                        action,
                        error_message
                    ) values (
                        sysdate,
                        rec.blocking_sid,
                        rec.blocking_serial,
                        rec.blocking_osuser,
                        rec.blocked_sid,
                        rec.blocked_serial,
                        rec.blocked_osuser,
                        v_blocked_sql,
                        rec.blocked_object,
                        'ERROR',
                        v_error_msg
                    );
                    commit;
            end;
        end loop;

        -- 60 Sekunden warten bis zur naechsten Pruefung
        dbms_session.sleep(60);
    end loop;
end kill_blocking_sessions;
/
