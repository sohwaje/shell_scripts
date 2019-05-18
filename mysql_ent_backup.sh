#!/bin/bash

# 기본 정보
BACKUPDIR=/BACKUP_DIR
USER="USER"
DBPASS='DB_PASSWORD'
MYSQLBACKUP="/mysql/bin/mysqlbackup"  # mysql 엔터프라이즈 백업 바이너리 파일 위치(파일명:mysqlbackup)

# 1. 삭제 주기
find $BACKUPDIR -mindepth 1 -maxdepth 1 -mtime +2 -type f -exec rm -f {} \;
wait

# 2. MySQL 엔터프라이즈 full backup 스크립트
$MYSQLBACKUP --defaults-file=/etc/my.cnf -u$ID -p$DBPASS --backup-dir=$BACKUPDIR --with-timestamp backup &>/dev/null

# 3. Restore
#$MYSQLBACKUP --defaults-file=/etc/my.cnf -u$ID -p$DBPASS --backup-dir=$BACKUPDIR copy-back-and-apply-log
