#!/bin/bash
#### 가상 머신 생성 알림 설정
WEBHOOK_ADDRESS=""
# 슬랙 메세지 함수
function slack_message(){
    # $1 : message
    # $2 : true=good, false=danger

    COLOR="danger"
    if $2 ; then
        COLOR="good"
    fi
    curl -s -d 'payload={"attachments":[{"color":"'"$COLOR"'","pretext":"<!channel> *lab*","text":"*HOST* : '"$HOSTNAME"' \n*MESSAGE* : '"$1"'"}]}' $WEBHOOK_ADDRESS > /dev/null 2>&1
}
slack_message "$HOSTNAME UP"
