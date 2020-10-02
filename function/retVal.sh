#!/bin/sh
#### example 1
retVal=$?
_retVal()
{
  if [[ $retVal -eq 0 ]];then
    echo "[OK]"
    # do something
  else
    echo "[Failed]"
    exit
  fi
}

#### example 2
retVal=$?
test $retVal -eq 0 && echo "[OK]" || echo "[Failed]";exit $retVal

#### example 3
ec=$?
case $ec in
  0) ;;
  1) echo "Command exited with no-zero"; exit 1;;
  *) echo "something wrong exited code"; exit;;
esac
