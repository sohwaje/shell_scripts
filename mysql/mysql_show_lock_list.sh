#!/bin/sh
DB="DB_NAME"
PASSWORD='PASSWROD'
TABLE="$(/data/mysql/bin/mysql -uroot -p$PASSWORD $DB -e 'show tables')"

for table in $TABLE
do
  echo "======================================================= TABLE_NAME : $table ======================================================="
  # /data/mysql/bin/mysql -uroot -p$PASSWORD $DB -e 'select trx_state, trx_query from information_schema.INNODB_TRX $table\G'
  /data/mysql/bin/mysql -uroot -p$PASSWORD $DB -e 'select * from information_schema.INNODB_LOCK_WAITS $table\G'
#   /data/mysql/bin/mysql -uroot -p$PASSWORD $DB -e 'select lock_trx_id, lock_mode, lock_table from information_schema.INNODB_LOCKS $table\G'
done
