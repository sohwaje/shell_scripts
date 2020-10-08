#!/bin/bash
#### 가상 머신 생성 알림 설정
WEBHOOK_ADDRESS=""
# 슬랙 메세지 함수
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
