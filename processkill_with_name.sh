#!/bin/bash
NAME=APP_NAME
PID=$(ps -f | grep $NAME | grep -v grep | awk '{print $2}')

if [ -z $PID ];then
  echo "Process not found"
else
  echo "Kill Process $PID"
  kill -9 $PID
fi
