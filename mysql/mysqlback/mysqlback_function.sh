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
# Backup directory location
INCREMENTALDIR="/data/mysql_backup/incremental"
FULLBACKUPDIR="/data/mysql_backup/fullbackup"
# slack webhook url
WEBHOOK_ADDRESS=""

# mysqlback 파일이 존재하면서 실행 권한이 있는지 확인
check_file_exec()
{
  if [[ ! -x ${MYSQLBACKUP} ]];then
    return 0
  else
    return 1
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

# 검수
_retVal()
{
  local retVal=$?
  test $retVal -eq 0 && \
    slack_message "$DATE : Backup completed Successfully" || slack_message "backup failed " false;exit $retVal
}

## 가장 최근에 만들어진 풀백업 찾기 : show latest backup directory function
latest()
{
  ls -ltr $FULLBACKUPDIR | grep -v grep | awk '{print $NF}' | grep -v ^$ |tail -n1
}

## 디렉토리가 없으면 만든다 : Create incremental dir and fullbackup dir, Just if not exist
exist_check_dir()
{
  if [[ ! -d $INCREMENTALDIR ]];then
    mkdir -p $INCREMENTALDIR
  fi
  if [[ ! -d $FULLBACKUPDIR ]];then
    mkdir -p $FULLBACKUPDIR
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
## 가장 최근의 풀백업에 대한 증분 백업을 시작한다.
incremental_backup()
{
  $MYSQLBACKUP \
    --defaults-file=/etc/my.cnf \
    -u$ID -p$DBPASS \
    --incremental --incremental-base=dir:$FULLBACKUPDIR/$(latest) \
    --with-timestamp --incremental-backup-dir=$INCREMENTALDIR backup
}
