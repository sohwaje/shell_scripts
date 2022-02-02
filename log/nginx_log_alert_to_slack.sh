#!/bin/bash
# Usage: nohup sh panopticon.sh start > /dev/null 2>&1 &
daemonName="panopticon"

pidDir="."
pidFile="$pidDir/$daemonName.pid"

logDir="."
# To use a dated log file.
# logFile="$logDir/$daemonName-"`date +"%Y-%m-%d"`".log"
# To use a regular log file.
logFile="$logDir/$daemonName.log"

# Log maxsize in KB
logMaxSize=1024   # 1mb

runInterval=60 # In seconds

doCommands() {
  echo "doCommand"    # 데몬이 실행할 내용
  httplogdir="/var/log/nginx/oauth2client"
  logfile="/var/log/nginx/oauth2client/https_stageoauth2client_error.log"
  webhook="WEBHOOK_ADDRESS"  # 슬랙 webhook API 주소

  # * slack 알림 함수
  function slack_message(){
      # $1 : message
      # $2 : true=good, false=danger

      COLOR="danger"
      icon_emoji=":scream:"
      if $2 ; then
          COLOR="good"
  	  icon_emoji=":smile:"
      fi
      curl -s -d 'payload={"attachments":[{"color":"'"$COLOR"'","pretext":"<!channel> *lab*","text":"*HOST* : '"$HOSTNAME"' \n*MESSAGE* : '"$1"' '"$icon_emoji"'"}]}' $webhook > /dev/null 2>&1
  }

  # * slack 알림 함수 호출 -> 에러 메시지 전송 -> 로그 백업 -> 로그 초기화(error가 로그가 쌓여서 알림이 여러개 오는 것을 방지)
  function send_alert(){
    slack_message "$(echo $line | sed "s/\"/'/g")" false
    cp ${logfile} ${logfile}_$(date '+%Y%m%d%H%M%S')
    # rm -f ${httplogdir}/*.log_*  # 백업한 로그 삭제
    cat /dev/null > ${logfile}
  }
  # * -F 실시간 감시
  # * -n 0 추가분만 감시
  # * error, warn이 로그에 찍힐 경우 트리거된다.
  tail -F -n 0 "${logfile}" |\
  while read line
  do
    case "$line" in
      *"error"*)
      send_alert
      ;;
      *"warn"*)
      send_alert
      ;;
    esac
  done
}

pid_num=`echo $$`

setupDaemon() {
  # Make sure that the directories work.
  if [ ! -d "$pidDir" ]; then
    mkdir "$pidDir"
  fi
  if [ ! -d "$logDir" ]; then
    mkdir "$logDir"
  fi
  if [ ! -f "$logFile" ]; then
    touch "$logFile"
  else
    # Check to see if we need to rotate the logs.
    size=$((`ls -l "$logFile" | cut -d " " -f 4`/1024))
    if [[ $size -gt $logMaxSize ]]; then
      mv $logFile "$logFile.old"
      touch "$logFile"
    fi
  fi
}

startDaemon() {
  # Start the daemon.
  setupDaemon # Make sure the directories are there.
  if [[ `checkDaemon` == false ]]; then
    echo " * Errorm: $daemonName is already running."
    exit 1
  fi
  echo " * Starting $daemonName with PID: $pid_num."
  echo "$pid_num" > "$pidFile"
  log '*** '`date +"%Y-%m-%d"`": Starting up $daemonName."

  # Start the loop.
  loop
}

stopDaemon() {
  # Stop the daemon.
  if [[ `checkDaemon` == false ]]; then
    echo " * Stopping $daemonName"
    log '*** '`date +"%Y-%m-%d"`": $daemonName stopped."
    kill -9 `cat "$pidFile"` &> /dev/null
    rm -f "$pidFile"
    sleep 3
    echo "done"
  else
    echo " * Error: $daemonName is not running."
    exit 1
  fi


}

statusDaemon() {
  # Query and return whether the daemon is running.
  if [[ `checkDaemon` == true ]]; then
    echo " * $daemonName isn't running."
  else
    echo " * $daemonName is running."
  fi
  exit 0
}

restartDaemon() {
  # Restart the daemon.
  if [[ `checkDaemon` == false ]]; then
    # stopDaemon; echo "restart"; nohup sh $0 start > /dev/null 2>&1 &
    stopDaemon && echo "restart" && startDaemon; sleep 3
    exit 0
    # Can't restart it if it isn't running.
  else
    echo "$daemonName isn't running. Daemon start first."
    exit 1
  fi

}

checkDaemon() {
  if [[ -f "$pidFile" ]] && [[ -r "$pidFile" ]]; then
      # Daemon is running.
    echo "false"
  else
        # Daemon isn't running.
    echo "true"
  fi

}

loop() {
  # This is the loop.
  now=`date +%s`

  if [ -z $last ]; then
    last=`date +%s`
  fi

  # Do everything you need the daemon to do.
  doCommands

  # Check to see how long we actually need to sleep for. If we want this to run
  # once a minute and it's taken more than a minute, then we should just run it
  # anyway.
  last=`date +%s`

  # Set the sleep interval
  if [[ ! $((now-last+runInterval+1)) -lt $((runInterval)) ]]; then
    sleep $((now-last+runInterval))
  fi

  # Startover
  loop
}

log() {
  # Generic log function.
  echo "$1" >> "$logFile"
}


################################################################################
# Parse the command.
################################################################################

case "$1" in
  start)
    startDaemon
    ;;
  stop)
    stopDaemon
    ;;
  status)
    statusDaemon
    ;;
  restart)
    restartDaemon
    ;;
  *)
  echo "Error: usage $0 { start | stop | restart | status }"
  exit 1
esac

exit 0
