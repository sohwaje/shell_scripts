#!/bin/bash
#Created by SIGONGMEDIA Lee.Yu-Sung

# 0. COMMON VALUE
BACKUPDIR="/data/mysql_backup"
ID="root"
DBPASS='root'
MYSQLBACKUP="/usr/local/mysql/bin/mysqlbackup"
INCREMENTALDIR="/data/mysql_backup/incremental"

# 0  delete
find $INCREMENTALDIR -mindepth 1 -maxdepth 1 -mtime +0 -type d -exec rm -rfv {} \;

# 1. FULL BACKUP
full_backup()
{
  $MYSQLBACKUP \
    --defaults-file=/etc/my.cnf \
    -u$ID -p$DBPASS \
    --backup-dir=$BACKUPDIR \
    --with-timestamp backup-and-apply-log
}

# 2. Restore
#$MYSQLBACKUP --defaults-file=/etc/my.cnf -u$ID -p$DBPASS --backup-dir=$BACKUPDIR copy-back-and-apply-log

# 3. INCREMENTAL Backup
incremental_backup()
{
  $MYSQLBACKUP \
    --defaults-file=/etc/my.cnf \
    -u$ID -p$DBPASS \
    --incremental --incremental-base=history:last_backup \
    --with-timestamp --incremental-backup-dir=$INCREMENTALDIR backup
}

if [[ ! -d $INCREMENTALDIR ]];then
  mkdir -p $INCREMENTALDIR
fi

# 가장 최신의 fullbackup 디렉토리 찾기
ls -ltr | grep -v grep | awk '{print $9}' | grep -v ^$ |head -1
# 4. INCREMENTAL Restore
# ex) mysqlbackup --incremental-backup-dir=/2017-02-22_10-12-41 --backup-dir=/2017-02-22_10-02-36 apply-incremental-backup
# $MYSQLBACKUP --incremental-backup-dir=$BACKUPDIR/2020-10-07_14-56-14 --backup-dir=$BACKUPDIR/2020-10-07_13-23-56 apply-incremental-backup
