#!/bin/bash
# jar 파일 복사
PROC_NAME="$(ls ../ws_chk/gw_mail_appr.jar )"  # app location
echo ${PROC_NAME}
readonly DAEMON="/home/sigongweb/webapps/ws_chk/${PROC_NAME}"
# [1]프로세스 아이디가 존재할 패스를 설정
readonly PID_PATH="/home/sigongweb/webapps/bin/"
readonly PROC_PID="${PID_PATH}${PROC_NAME}-edu.pid"
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
    nohup /home/sigongweb/jdk1.8.0_144/bin/java \
    -jar -XX:MaxMetaspaceSize=512m -XX:MetaspaceSize=256m -Xms1024m -Xmx1024m \
    "${DAEMON}" 183.98.92.243 3000 5 R 600000 > /dev/null 2>&1 &

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
