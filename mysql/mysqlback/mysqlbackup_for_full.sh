#!/bin/bash
### Name    : mysqlbackup_for_full.sh
### Author  : Lee.Yu-Sung
### Version : 1.0
### Date    : 2020-10-08

# include mysqlback function
. mysqlback_function.sh

## Create incremental dir and fullbackup dir, Just if not exist
# 풀백업 디렉토리가 없으면 만든다.
main()
{
  exist_check_dir && archiving_backup
  if [[ ! -d $FULLBACKUPDIR ]];then
    slack_message "Start Full backup"
    mkdir -p $FULLBACKUPDIR
    full_backup
  elif [[ -d $FULLBACKUPDIR ]];then
    slack_message "Start Full backup"
    full_backup
  else
    echo "================> Cannot Start Full backup."
    slack_message "$(date '+%Y-%m-%d %H:%M:%S') : Cannot Start Full backup" false
  fi
}
check_file_exec && main # Checking if a file has run permissions, and run main function
_retVal
