#!/bin/sh
### Name    : web_alive_check.sh
### Author  : sohwaje
### Version : 1.0
### Date    : 2020-09-18
################################################################################
# 운영하는 JAVA 웹 서버의 상태를 검사하여 이상 발생 시 경고한다.
# 재시작하기 전 스레드 덤프를 생성한다.
# 톰캣을 기준으로 작성
################################################################################
#[1] 타겟 URL
# usage:
:<<'END'
url="http://URL:PORT"
proc_name="PROCESS_NAME"
start_home="/usr/local/bin/"  # startup scripts dir
thread_dump_dir="/home/dump" # thread dump dir
END
################################################################################
url="http://localhost:8080"
proc_name=""
start_home=""
thread_dump_dir=""
_date=`date +%Y%m%d`
date_str=$(date '+%Y/%m/%d %H:%M:%S')
#[2] 감시 URL에 curl 명령어로 접속해서 종료 status를 변수 curlresult에 대입
# -s 침묵모드, -o 저장할 파일 경로(여기서는 null), -w 명령어 완료 후 출력할 표시 형식 지정
httpstatus=$(curl -s "$url" -o /dev/null -w "%{http_code}" --max-time 10)
curlresult=$?  # 위에서 실행한 curl 명령의 종료 코드
################################################################################
# 프로세스 강제 종료
process_kill()
{
  local PID=$(get_process)
  kill -9 $PID
}
# 프로세스 재시작
restart()
{
  cd $start_home;./startup.sh
}
# PID 찾기
get_process()
{
  ps ux | grep $proc_name | grep -v grep | awk '{print $2}'
}
# 스레드덤프
thread_dump()
{
  local PID=$(get_process)
  if [ -n $PID ];then
    echo "$PID is running"
    jstack -l $PID > $thread_dump_dir/dump-${_date}.txts
  else
    echo "$PID is dead. go to restart!!"
  fi
}

#[2] curl이 성공하면 HTTP 200 OK 출력, 실패하면 HTTP 접속 문제로 판단
main()
{
if [[ "$curlresult" -eq 0 ]];then
  echo "[$date_str] HTTP 200 OK : [$curlresult]"  # 응답 성공 시 200ok

elif [[ "$curlresult" -ne 0 ]];then  # -ne 같지 않음
  echo "[$date_str] HTTP 접속 불가 :curl exit status[$curlresult]"
  echo "#########################################################"
  thread_dump >& /dev/null
  echo "thread dump"
  process_kill >& /dev/null
  restart

#[3] 400, 500 에러 경고
elif [[ "$httpstatus" -ge 400 ]];then # -ge 더 크거나 같음
  echo "[$date_str] HTTP 에러: HTTP status[$httpstatus]"
  echo "#########################################################"
  thread_dump >& /dev/null
  echo "thread dump"
  process_kill >& /dev/null
  restart
fi
}

main
