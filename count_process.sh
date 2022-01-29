#!/bin/bash
# 프로세스 개수 실시간 확인 스크립트
COUNT=10
while :
do
  # COUNT=10이면 아래 printf 출력
  if [ $COUNT = 10 ]
  then
    printf "+--------+--------+-------+\n"
    printf "|  TIME  |  NAME  | COUNT |\n"
    printf "+--------+--------+-------+\n"
    COUNT=0
  fi
COUNT=$(expr $COUNT + 1)
TIME=`/bin/date +%H:%M:%S`
printf "|%s" ${TIME}  # "%s":문자열
# 프로세스 목록에서 해당 스크립트를 실행하는 프로세스는 제외
PROC_COUNT=$(ps aux | grep ${1} | grep -v grep |grep -v $0| wc -l)
printf "|  %s | %6d|\n" ${1} ${PROC_COUNT}
sleep 2
done
