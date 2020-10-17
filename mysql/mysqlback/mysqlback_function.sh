#!/bin/bash
### Name    : web_alive_check.sh
### Author  : Lee.Yu-Sung
### Version : 1.0
### Date    : 2020-10-08

# COMMON Variables
ID="root"
DBPASS='root'
MYSQLBACKUP="/usr/local/mysql/bin/mysqlbackup"
DATE=$(date '+%Y-%m-%d %H:%M:%S')
# Name of the backup directory moved
ARCHIVING_DATE=$(date +%Y%m%d%H%M%S)
# Backup directory location
INCREMENTALDIR="/mysql_backup/db/incremental"
FULLBACKUPDIR="/mysql_backup/db/fullbackup"
ARCHIVINGDIR="/mysql_backup/db/archiving"
# slack webhook url
WEBHOOK_ADDRESS=""

# mysqlback 파일이 존재하면서 실행 권한이 있는지 확인
check_file_exec()
{
  if [[ -x ${MYSQLBACKUP} ]];then
    return 0
  else
    "Unable to execute file."
    exit 1
  fi
}

# 슬랙 메세지 함수
slack_message(){
    # $1 : message
    # $2 : true=good, false=danger
    COLOR="danger"
    icon_emoji=":scream:"
    if $2 ; then
        COLOR="good"
	icon_emoji=":smile:"
    fi
    curl -s -d 'payload={"attachments":[{"color":"'"$COLOR"'","pretext":"<!channel> *smm*","text":"*HOST* : '"$HOSTNAME"' \n*MESSAGE* : '"$1"' '"$icon_emoji"'"}]}' $WEBHOOK_ADDRESS > /dev/null 2>&1
}

# 쉘 종료 코드 검수
_retVal()
{
  local retVal=$?
  test $retVal -eq 0 && \
    slack_message "$(date '+%Y-%m-%d %H:%M:%S') : Backup completed Successfully" || slack_message "backup failed " false;exit $retVal
}

## 가장 최근에 만들어진 풀백업 찾기 : show latest backup directory function
latest()
{
  ls -ltr $FULLBACKUPDIR | grep -v grep | awk '{print $NF}' | grep -v ^$ |tail -n1
}

## 디렉토리가 없으면 만든다 : Create incremental dir, fullbackup dir and archiving dir, Only if not exist
exist_check_dir()
{
  if [[ ! -d $INCREMENTALDIR ]];then
    mkdir -p $INCREMENTALDIR
  fi
  if [[ ! -d $FULLBACKUPDIR ]];then
    mkdir -p $FULLBACKUPDIR
  fi
  if [[ ! -d $ARCHIVINGDIR ]];then
    mkdir -p $ARCHIVINGDIR
  fi
}

# FULL BACKUP function
full_backup()
{
  $MYSQLBACKUP \
    --defaults-file=/etc/my.cnf \
    -u$ID -p$DBPASS \
    --backup-dir=$FULLBACKUPDIR \
    --with-timestamp backup-and-apply-log
}

# INCREMENTAL Backup function
incremental_backup()
{
  $MYSQLBACKUP \
    --defaults-file=/etc/my.cnf \
    -u$ID -p$DBPASS \
    --incremental --incremental-base=dir:$FULLBACKUPDIR/$(latest) \
    --with-timestamp --incremental-backup-dir=$INCREMENTALDIR backup
}
#///////////////////////////////////////////////////////////////////////////////
## old backup directory delete before starting new backup
incremental_backup_delete()
{
  if [[ "$(ls -A ${INCREMENTALDIR})" ]];then    # 증분 백업 디렉토리가 비어 있지 않을 때 실행
    rm -rf $INCREMENTALDIR/*
  else
    echo "empty $INCREMENTALDIR"
  fi
}

# 아카이빙 디렉토리에서 지난 백업 데이터를 삭제한다.
backup_delete()
{
  if [[ "$(ls -A ${ARCHIVINGDIR})" ]];then     # 풀 백업 디렉토리가 비어 있지 않을 때 실행
    local targets=$(find $ARCHIVINGDIR -mindepth 1 -maxdepth 1 -mtime +0 -type d) # 해당 기간에 포함되는 디렉토리 리스트를 배열로 저장
    if [[ ! -z $targets ]];then
      for target in ${targets[@]}
      do
        rm -rf $target # 지난 날짜의 백업 삭제
      done
    fi
  fi
}

# 이전 풀백업, 증분백업 디렉토리의 이름을 변경하고 아카이빙 디렉토리에 보관한다.
archiving_backup()
{
  backup_delete # 아카이빙 디렉토리 삭제 함수 호출
  if [[ -d ${FULLBACKUPDIR} ]] && [[ -d ${INCREMENTALDIR} ]];then
    echo "move backup directory"
    mv ${FULLBACKUPDIR} $ARCHIVINGDIR/fullbackup-$ARCHIVING_DATE && \
    mv ${INCREMENTALDIR} $ARCHIVINGDIR/incrementalbackup-$ARCHIVING_DATE && \
    slack_message "$DATE : ARCHIVING success"
  else
    echo "ARCHIVING failed"
    slack_message "$DATE : ARCHIVING failed" false
  fi
}
