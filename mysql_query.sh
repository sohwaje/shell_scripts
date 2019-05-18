#!/bin/bash
# 스크립트 중단은 CTRL+C
mysql=/mysql/bin/mysql
USER=root
PASSWORD='PASSWORD'
while true
do
$mysql -u$USER -p$PASSWORD -e 'show processlist' | grep -v 'Sleep' #show processlist 상태가 sleep이 아닌 쿼리를 화면에 출력
sleep 2
done
