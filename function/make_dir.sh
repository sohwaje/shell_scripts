#!/bin/bash
# 파라미터 체크 함수
check_param()
{
  # 인자값 개수($#) 1보다 작으면, 스크립트 사용법을 출력하고 종료.
  if [[ "$#" -lt 1 ]]; then
    echo "Usage: $0 dirname"
    exit 1
  fi
}

# 디렉토리 생성 함수
make_dir()
{
  check_param "$@"  # call 파라미터 체크 함수
  if [[ -d /home/"${1}" ]];then
    echo "/home/${1} directory does exist. Back up and recreate $1"
    sudo mv /home/"${1}" /home/"${1}-${date_}"
    sudo mkdir -p /home/"${1}" && sudo chmod 0755 /home/"${1}"  # 디렉토리가 있으면 백업하고 다시 만든다.
  else
    echo -e "\e[0;31;47m /home/${1} directory does not exist. Create ${1} directory\e[0m"
    sudo mkdir -p /home/"${1}" && sudo chmod 0755 /home/"${1}"   # 디렉토리가 없으면 백업하고 다시 만든다.
  fi
}

make_dir "$@"   # 모든 파라미터
