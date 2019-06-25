#!/bin/sh
#############################################################
# 운영하는 웹 서버의 상태를 검사하여 이상 발생 시 경고한다.     #
#############################################################
#[1] 타겟 URL
url="http://222.231.21.149"

date_str=$(date '+%Y/%m/%d %H:%M:%S')

#[2] 감시 URL에 curl 명령어로 접속해서 종료 status를 변수 curlresult에 대입
# -s 침묵모드, -o 저장할 파일 경로(여기서는 null), -w 명령어 완료 후 출력할 표시 형식 지정
httpstatus=$(curl -s "$url" -o /dev/null -w "%{http_code}")
curlresult=$?  # 위에서 실행한 curl 명령의 종료 코드

#[3] curl이 성공하면 HTTP 200 OK 출력, 실패하면 HTTP 접속 문제로 판단
if [ "$curlresult" -eq 0 ]; then
  echo "[$date_str] HTTP 200 OK : [$curlresult]"  # 응답 성공 시 200ok

elif [ "$curlresult" -ne 0 ]; then  # -ne 같지 않음
  echo "[$date_str] HTTP 접속 불가 :curl exit status[$curlresult]"
  #/root/alert.sh # 실행할 스크립트

# 400, 500 에러 경고
elif [ "$httpstatus" -ge 400 ]; then # -ge 더 크거나 같음
  echo "[$date_str] HTTP 에러: HTTP status[$httpstatus]"
  #/root/alert.sh # 실행할 스크립트
fi

