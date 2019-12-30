#!/bin/sh
# 특정 디렉토리에서 삭제해서는 안 되는 디렉토리를 제외하고 모든 디렉토리 하위의 모든 데이터를 삭제한다.

# [1] 타겟 디렉토리: "" 안에 타겟 디렉토리를 명시한다. ex: TARGETDIR="/var/log"
TARGETDIR="/hdcs/store"

# [2] 타겟 디렉토리에서 디렉토리 명이 "temp", "webview", ".", "delete.sh"를 제외한 모든 데이터를 삭제
# 삭제에서 제외할 디렉토리는 "!"로 명시한다.
while (true); do
  echo -e "\033[1;35m $TARGETDIR의 데이터를 삭제하시겠습니까? \033[0m"
  echo -n "[y/n]:"
  read choice

  case "$choice" in
    y|Y])
      echo "$TARGETDIR의 데이터를 모두 삭제합니다."
    cd $TARGETDIR
	find . -maxdepth 1 ! -name temp -and ! -name webview -and ! -name . -and ! -name delete.sh | xargs rm -rvf
      sleep 1
     break
    ;;
    n|N])
      echo "스크립트 종료"
    break
    ;;
    *)
      echo "잘못누르셨습니다"
    break
    ;;
  esac
done
