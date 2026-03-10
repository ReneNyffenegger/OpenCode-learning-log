# Kill Blocking Sessions in Oracle

Your task is to create a stored pocedure, written in PL/SQL, whick kills blocking sessions if the blocking table is `besitzer` or `anztag`.

## Solution design

### Loops

The solution will have two loops.

The *inner loop* iterates over all blocking session with the given criteria above and kills them, one by one.

The *outer loop* uses `dbms_session.sleep` to sleep 60 seconds before starting the inner loop.

### Log Table

There will also be a log table which records
- The username (`osuser` from `v$session`) of the blocking and the blocked session
- The SQL statement of the blocked (but not the blocking) session.
- The date/time when the insert was made. This datatype needs to be `date`, not a `timestamp`

The inner loop is guarded by a `exception` block. Whenever an exception occurs, the exception is also logged in the log table.

Grant `select` on the log table to the user `rene`.

### Things to remember

When tempted to use `sqlerrm` when logging an exception, remember that `sqlerrm` cannot be used in an SQL statement.

Also use `v$sqlarea` rather than `v$sql` to extract the SQL statement because `v$sql` contains one record per `sql_id`.\
Thus, you don't need to `group by` on `sql_fulltext` which raises an error because `sql_fulltext` is a `clob`.

## Coding conventions

### Comments

The script is for a german speaking audience. Thus, write comments in German.\
Technical jargon, such as *Stored Procedure* does not need to be translated.

### Created files

Create two files:
- An `.sql` file for the DDL statements
- An `.sql` file for the 
  
### Casing

Write SQL and PL/SQL keywords in lowercase letters.
