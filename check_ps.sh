#!/bin/sh
#[1] 종료 코드 값
UNKNOWN_STATE=3
CRITICAL_STATE=2
WARNING_STATE=1
OK_STATE=0

#[2] 명령행 인자값 검수
if [ $# -eq 0 ]; then # $#: 명령 라인 인자가 없으면 사용법을 출력한다.
       echo "사용법: check_ps.sh [프로세스 이름]" # 반드시 1개의 인자를 명시한다.
       exit $CRITICAL_STATE
fi

#[3] 프로세스를 찾는다.
PNAME=$(ps -ef |grep -i $1 | grep -v grep | grep -v "bin/sh") # $1는 명령 라인의 인자

#[4] 해당 프로세스가 존재하면, 존재하지 않으면.
if [ -z "$PNAME" ];then  # 문자열이 "null" 값이라면.
       echo "CRITICAL - $1 프로세스가 존재하지 않습니다."
       exit $CRITICAL_STATE
else
       echo "OK - $1 프로세스가 실행 중입니다."
       exit $OK_STATE
fi

exit $OK_STATE
