#!/bin/sh
_return_result(){
if [[ $? -eq 0 ]];then
  echo "[OK]"
else
  # If value is False => do something
  echo "[Failed]"
  exit 9
fi
}
