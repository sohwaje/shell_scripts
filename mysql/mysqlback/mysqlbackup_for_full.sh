#!/bin/bash
### Name    : mysqlbackup_for_full.sh
### Author  : Lee.Yu-Sung
### Version : 1.0
### Date    : 2020-10-08

# include mysqlback function
. mysqlback_function.sh

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

full_backup_delete()
{
  if [[ "$(ls -A ${FULLBACKUPDIR})" ]];then     # 풀 백업 디렉토리가 비어 있지 않을 때 실행
    local targets=$(find $FULLBACKUPDIR -mindepth 1 -maxdepth 1 -mtime +0 -type d) # 해당 기간에 포함되는 디렉토리 리스트를 배열로 저장
    if [[ ! -z $targets ]];then
      for target in ${targets[@]}
      do
        rm -rf $FULLBACKUPDIR/$target && incremental_backup_delete          # 풀백업 삭제되면, 증분 백업 전부 삭제
      done
    fi
  fi
}

## Create incremental dir and fullbackup dir, Just if not exist
# 풀백업 디렉토리가 없으면 만든다.
main()
{
  full_backup_delete
  if [[ ! -d $FULLBACKUPDIR ]];then
    slack_message "Start Full backup"
    mkdir -p $FULLBACKUPDIR
    full_backup
  elif [[ -d $FULLBACKUPDIR ]];then
    slack_message "Start Full backup"
    full_backup
  else
    echo "================> Cannot Start Full backup."
    slack_message "$DATE : Cannot Start Full backup" false
  fi
}
check_file_exec && main # Checking if a file has run permissions, and run main function
_retVal
