#!/bin/bash
var=$1

pid_status()
{
  ps -ef | grep $var | grep -v grep | awk '{print $2}' | head -1
}

checkpid()
{
  for i in $* ; do
    [ -d "/proc/$i" ] && return 0
  done
  return 1
}

main()
{
  local pid=$(pid_status)
  if checkpid $pid; then
    echo "Kill Process $PID"
    kill -9 $PID
  else
    echo "$pid is not...."
  fi
}

if [ "$#" -ne 1 ]; then # 인자 1개만: not equal
  echo "Usage: killproc [name]"
  exit 0
fi

main
