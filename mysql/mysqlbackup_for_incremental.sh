#!/bin/bash
# Created by SIGONGMEDIA Lee.Yu-Sung

# 0. COMMON Variables
ID="root"
DBPASS='root'
MYSQLBACKUP="/usr/local/mysql/bin/mysqlbackup"
DATE=$(date '+%Y-%m-%d %H:%M:%S')
# Backup directory location
INCREMENTALDIR="/data/mysql_backup/incremental"
FULLBACKUPDIR="/data/mysql_backup/fullbackup"

# 0  delete
# find $INCREMENTALDIR -mindepth 1 -maxdepth 1 -mtime +0 -type d -exec rm -rfv {} \;
# find $FULLBACKUPDIR -mindepth 1 -maxdepth 1 -mtime +0 -type d -exec rm -rfv {} \;

# 검수
_retVal()
{
  local retVal=$?
  test $retVal -eq 0 && echo "[$DATE : Incremental Backup completed Successfully ]" || echo "[$DATE : Incremental Backup Failed]";exit $retVal
}

## 가장 최근에 만들어진 풀백업 찾기 : show latest backup directory function
latest()
{
  ls -ltr $FULLBACKUPDIR | grep -v grep | awk '{print $NF}' | grep -v ^$ |tail -n1
}

## 증분백업 디렉토리가 없으면 만든다 : Create incremental dir and fullbackup dir, Just if not exist
exist_check_dir()
{
  if [[ ! -d $INCREMENTALDIR ]];then
    mkdir -p $INCREMENTALDIR
  fi
}

# FULL BACKUP function
# full_backup()
# {
#   $MYSQLBACKUP \
#     --defaults-file=/etc/my.cnf \
#     -u$ID -p$DBPASS \
#     --backup-dir=$FULLBACKUPDIR \
#     --with-timestamp backup-and-apply-log
# }

# INCREMENTAL Backup function
## 가장 최근의 풀백업에 대한 증분 백업을 시작한다.
incremental_backup()
{
  $MYSQLBACKUP \
    --defaults-file=/etc/my.cnf \
    -u$ID -p$DBPASS \
    --incremental --incremental-base=dir:$FULLBACKUPDIR/$(latest) \
    --with-timestamp --incremental-backup-dir=$INCREMENTALDIR backup
}

# Check whether a directory is empty or not
## 풀백업 디렉토리가 비어 있으면 에러, 비어 있지 않으면 증분백업 시작
main()
{
  exist_check_dir # 백업 디렉토리 생성 유무 확인
  if [[ "$(ls -A ${FULLBACKUPDIR})" ]]; then   # 풀 백업 디렉토리가 비어 있지 않으면 증분 백업 시작
    echo "================> Start incremental backup"
    sleep 3
    incremental_backup
  else
    echo "================> Start failed. not found full backup dir"                               # 풀 백업 디렉토리가 비어 있으면 풀 백업 시작
  fi
}

main
_retVal


# 4. INCREMENTAL Restore
# ex) mysqlbackup --incremental-backup-dir=/2017-02-22_10-12-41 --backup-dir=/2017-02-22_10-02-36 apply-incremental-backup
# $MYSQLBACKUP --incremental-backup-dir=$BACKUPDIR/2020-10-07_14-56-14 --backup-dir=$BACKUPDIR/2020-10-07_13-23-56 apply-incremental-backup
