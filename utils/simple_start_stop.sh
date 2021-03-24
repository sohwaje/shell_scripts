#!/bin/bash
cd "$(dirname "$0")"
# jar 파일 복사
PROC_NAME="$(ls ../apps )"  # app location
echo ${PROC_NAME}
readonly DAEMON="/home/azureuser/apps/${PROC_NAME}"
# [1]프로세스 아이디가 존재할 패스를 설정
readonly PID_PATH="/home/azureuser/bin/"
readonly PROC_PID="${PID_PATH}${PROC_NAME}.pid"
# 채널:build-deploy
WEBHOOK_ADDRESS=""

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
    curl -s -d 'payload={"attachments":[{"color":"'"$COLOR"'","pretext":"<!channel> *build-deploy*","text":"*HOST* : '"$HOSTNAME"' \n*MESSAGE* : '"$1"' '"$icon_emoji"'"}]}' $WEBHOOK_ADDRESS > /dev/null 2>&1
}
# 시작 함수
start()
{
   echo "Starting ${PROC_NAME}..."
    local PID=$(get_status)
    if [ -n "${PID}" ]; then
        echo "${PROC_NAME} is already running"
        #exit 0
    fi
    nohup java \
    -jar -XX:MaxMetaspaceSize=512m -XX:MetaspaceSize=256m -Xms256m -Xmx256m \
    "${DAEMON}" > /dev/null 2>&1 &

    local PID=${!}

    if [ -n ${PID} ]; then
        echo " - Starting..."
        echo " - Created Process ID in ${PROC_PID}"
        echo ${PID} > ${PROC_PID}
        slack_message "Started ${PROC_PID}"
    else
        echo " - failed to start."
        slack_message "Start failed ${PROC_PID}" false
    fi
}
# 중지
stop()
{
    echo "Stopping ${PROC_NAME}..."
    local DAEMON_PID=`cat "${PROC_PID}" 2>/dev/null`

    if [ -z "$DAEMON_PID" ]; then
        echo "${PROC_NAME} was not running."
    else
        kill $DAEMON_PID 2>/dev/null
        rm -f $PROC_PID 2>/dev/null
        echo " - Shutdown ...."
        slack_message "Shutdown ${PROC_PID}"
    fi
}
# 상태
status()
{
    local PID=$(get_status)
    if [ -n "${PID}" ]; then
        echo "${PROC_NAME} is running"
    else
        echo "${PROC_NAME} is stopped"
        # start daemon
        #nohup java -jar "${DAEMON}" > /dev/null 2>&1 &
    fi
}

get_status()
{
    ps ux | grep ${PROC_NAME} | grep -v grep | awk '{print $2}'
}

# 케이스 별로 함수를 호출하도록 한다.

case "$1" in
start)
start
sleep 7
;;
stop)
stop
sleep 5
;;
restart)
stop ; echo "Restarting..."; sleep 5 ;
start
;;
status)
status "${PROC_NAME}"
    ;;
    *)
    echo "Usage: $0 {start | stop | restart | status }"
esac
exit 0
