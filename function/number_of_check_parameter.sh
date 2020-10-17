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

check_param "$@" 
