#!/bin/bash
### Name    : mysqlbackup_for_incremental.sh
### Author  : Lee.Yu-Sung
### Version : 1.0
### Date    : 2020-10-08

# include mysqlback function
. mysqlback_function.sh

# Checking if a file has run permissions
check_file_exec

#///////////////////////////////////////////////////////////////////////////////
## delete
# find $INCREMENTALDIR -mindepth 1 -maxdepth 1 -mtime +0 -type d -exec rm -rfv {} \;

## Check whether a directory is empty or not
# 풀백업 디렉토리가 비어 있으면 에러, 비어 있지 않으면 증분백업 시작
main()
{
  exist_check_dir # 백업 디렉토리 생성 유무 확인
  if [[ "$(ls -A ${FULLBACKUPDIR})" ]]; then   # 풀 백업 디렉토리가 비어 있지 않으면 증분 백업 시작
    echo "================> Start incremental backup"
    slack_message "$DATE : Start Incremental Backup"
    sleep 3
    incremental_backup
  else
    echo "================> Cannot Start incremental backup. not found full backup dir"
    slack_message "$DATE : Cannot Start incremental backup" false    # 풀 백업 디렉토리가 비어 있으면 에러
  fi
}

main
_retVal
