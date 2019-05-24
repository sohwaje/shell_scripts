#!/bin/sh
time_wait_idle=20

time_wait=$(netstat -napo | grep -i 'TIME_WAIT' | wc -l)

alert=$(echo "$time_wait < $time_wait_idle" | bc)

if [ "$alert" -eq 1 ]; then
  date_str=$(date '+%Y/%m/%d %H:%H:%S')

  echo "[$date_str] TIME_WAIT 소켓 개수 : $time_wait 개"
  mail -s "TIME_WAIT 소켓이 $time_wait 개 입니다." $YOUR_EMAIL_ADDRESS
fi
exit 0
