#!/bin/bash

logfile="/var/log/nginx/https_stageoauth2client_error.log"

# * -F 실시간 감시
# * -n 0 추가분만 감시

tail -F -n 0 "${logfile}" |\
while read line
do
  case "$line" in
    *"error"*)
    echo "stageoauth2client 백엔드 오류 :$line"
    ;;
  esac
done
