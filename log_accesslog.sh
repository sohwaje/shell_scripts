#!/bin/sh
if [ $# -eq 0 ]; then
  echo "Usage: $0 access_log_file_name" >&2
  exit 1
fi

logfile="$1"
echo "$logfile를 선택하셨습니다."

if [ ! -f "$logfile" ]; then
  echo "대상 로그 파일이 존재하지 않습니다.: $logfile" >&2
  exit 1
fi

# sort | uniq -c | sort -nr 
# sort로 정렬된 문자열을 uniq -c를 통해 동일한 줄의 출현 개수를 구하고 이를 숫자로 정렬(sort -n)한 다음  다시 역순(-r)으로 정렬한다. 
echo " GET 메서드로 전송된 파일 접속 횟수 집계"
awk '$6=="\"GET" {print $7}' "$logfile" | sort | uniq -c | sort -nr

echo " POST 메서드로 전송된 파일 접속 횟수 집계"
awk '$6=="\"POST" {print $7}' "$logfile" | sort | uniq -c | sort -nr
