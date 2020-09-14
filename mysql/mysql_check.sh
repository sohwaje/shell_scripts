#!/bin/sh
# mysql_lock_check.sh
while true; do sleep 1; /mysql/bin/mysql -uroot -p'!@#' -e 'select * from information_schema.innodb_locks'; done

# mysql_lockwait_check.sh
while true; do sleep 1; /mysql/bin/mysql -uroot -p'!@#' -e 'select * from information_schema.innodb_lock_waits'; done

#  mysql_query_check.sh
while true; do sleep 1; /mysql/bin/mysql -uroot -p'!@#' -e 'show processlist' |grep -v 'event_scheduler'| grep -v 'replica'|grep -v 'show processlist'| grep -v 'Sleep' | grep '10.1.0.4'; done

# mysql_tr_check.sh
while true; do sleep 1; /mysql/bin/mysql -uroot -p'!@#' -e 'select * from information_schema.innodb_trx\G'; done
