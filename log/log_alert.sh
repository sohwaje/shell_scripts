#!/bin/sh
# 로그의 특정 메시지가 기준치 이상으로 반복해서 찍히면 SLACK으로 Alert 메세지를 보냅니다.
#LOG file
LOG="/home/sigongweb/apps/logs/hi-class-file.log"
regex='^(-?(?:[1-9][0-9]*)?[0-9]{4})-(1[0-2]|0[1-9])-(3[01]|0[1-9]|[12][0-9])T(2[0-3]|[01][0-9]):([0-5][0-9]):([0-5][0-9])(\.[0-9]+)?(Z|[+-](?:2[0-3]|[01][0-9]):[0-5][0-9])?$'
log_check()
{
  # 특정 메시지 개수를 담은 변수
  local nums=$(tail -n 100 ${LOG} | grep 'scheduling' | awk '{print $9}' | grep -Po ${regex} | wc -l)
  echo $nums
}

# Slack 주소
WEBHOOK_ADDRESS=''

# 날짜
DATE=$(date '+%Y-%m-%d %H:%M:%S')

# 슬랙으로 메시지 보내기 함수
function slack_message(){
    # $1 : message
    # $2 : true=good, false=danger

    COLOR="danger"
    icon_emoji=":scream:"
    if $2 ; then
        COLOR="good"
	icon_emoji=":smile:"
    fi
    curl -s -d 'payload={"attachments":[{"color":"'"$COLOR"'","pretext":"<!channel> *hi-class-file*","text":"*HOST* : '"$HOSTNAME"' \n*MESSAGE* : '"$1"' '"$icon_emoji"'"}]}' $WEBHOOK_ADDRESS > /dev/null 2>&1
}

# 정기적인 Alert 메시지를 보내는 함수
function regular_alert_message(){
  BDATE=`echo $DATE | awk '{print $2}' | awk -F ':' '{print $1":"$2}'`
  ADATE="08:00"

if [ "$BDATE" == "$ADATE" ]; then
  slack_message "$HOSTNAME \nNOW AM: $ADATE " true
fi
}
regular_alert_message

NUM=$(log_check)
# 개수 비교
# if [[ $NUM -gt 90 ]]; then
#   echo "Warning: $NUM | Date: $DATE"
#   slack_message "hi-class-file server maybe FAULT!!!!. " false  # 성공
# else
#   echo "Normal : $NUM | DATE: $DATE"
# fi

if [[ $NUM -gt 90 ]];then
  echo "retry log check after 60 seconds"
  sleep 60
  NUM=$(log_check)
  if [[ $NUM -gt 90 ]];then
    echo "Warning: $NUM | Date: $DATE"
    slack_message "hi-class-file server maybe FAULT!!!!. " false  # 성공
  fi
else
  echo "Normal : $NUM | DATE: $DATE"
fi
