#!/bin/sh
# 실행방법 : nohup sh daemon.sh start > /dev/null 2>&1 &

daemonName="panopticon"

pidDir="/var/run"
pidFile="$pidDir/$daemonName.pid"

logDir="/var/log"
logFile="$logDir/$daemonName.log"

# Log maxsize in KB
logMaxSize=1024

runInterval=60 # In seconds

# 스크립트 종료 시 또는 비정상 종료 시 pid 파일 삭제
trap "$(which rm) -f $pidDir/$daemonName.pid" EXIT

doCommands() {
  # 데몬이 수행해야 할 모든 작업을 명시
  echo "hello"
}

################################################################################
# Below is the skeleton functionality of the daemon.
################################################################################

pid_num=`echo $$`

setupDaemon() {
  # 데몬에 필요한 디렉토리가 있는지 확인, 없으면 만든다.
  if [ ! -d "$pidDir" ]; then
    mkdir "$pidDir"
  fi
  if [ ! -d "$logDir" ]; then
    mkdir "$logDir"
  fi
  if [ ! -f "$logFile" ]; then
    touch "$logFile"
  else
    # 로그 로테이션 사이즈 설정
    size=$((`ls -l "$logFile" | cut -d " " -f 4`/1024))
    if [[ $size -gt $logMaxSize ]]; then
      mv $logFile "$logFile.old"
      touch "$logFile"
    fi
  fi
}

startDaemon() {
  # 데몬 시작
  setupDaemon # 데몬에 필요한 디렉토리가 있는지 확인
  if [[ `checkDaemon` == false ]]; then
    echo " * Errorm: $daemonName is already running."
    exit 1
  fi
  echo " * Starting $daemonName with PID: $pid_num."
  echo "$pid_num" > "$pidFile"
  log '*** '`date +"%Y-%m-%d %H:%M:%S"`": Starting up $daemonName."

  # Start the loop.
  loop
}

stopDaemon() {
  # Stop the daemon.
  if [[ `checkDaemon` == false ]]; then
    echo " * Stopping $daemonName"
    log '*** '`date +"%Y-%m-%d %H:%M:%S"`": $daemonName stopped."
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
    echo "false"       # 데몬 실행
  else
    echo "true"        # 데몬 중지
  fi

}

loop() {
while true
do
    now=$(date +%s)  # 현재 UNIX시간

    if [[ -z $last ]]; then
      last=$(date +%s)
    fi

  # 데몬이 수행해야 할 작업
    doCommands

  # Check to see how long we actually need to sleep for. If we want this to run
  # once a minute and it's taken more than a minute, then we should just run it
  # anyway.
    last=$(date +%s)
  # "now-last+runInterval+1"이 runInterval 시간보다 작지 않으면, (now-last+runInterval) 동안 sleep 유지
    if [[ ! $((now-last+runInterval+1)) -lt $((runInterval)) ]]; then
      sleep $((now-last+runInterval))
    fi
done
}

log() {
  # Generic log function.
  echo "$1 $2" >> "$logFile"
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
