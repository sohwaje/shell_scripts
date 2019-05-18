#!/bin/bash
echo -e "INPUT URL: \c "
read URL  #JAVA INSTANCE PID
DATE=`date "+%Y%m%d_%H%M%S"`

#[1] URL의 index.html 다운로드
wget -O html $URL > /dev/null 2>&1

#[2] html 파일에서 url만 추출
cat html | grep -Po 'http.*://[^"]+' | grep -Po 'http.*://[^[[:space:]]+' >> $DATE.tmp

#[3]
#3-1 cat 명령어로 파일을 열어서 파이프 라인을 통해 awk 명령어로 출력 값을 넘긴다.
#3-2 awk는 각 행 전체($0)의 문자열 길이를 계산하여 문자열과 함께 출력한다. => "length 문자열"" 형식오로 표시된다.
#3-3 sor -n 각 라인의 필드를 비교하는 대상을 숫자로 한정함. 즉, 여기서는 문자열의 길이를 기준으로 정렬.
#3-4 정렬된 필드에서 -d' ' -f2- 필드 앞 부분 부터 두 번째 공백 필드를 제외한 모든 부분을 잘라낸다. 
cat $DATE.tmp | awk '{print length, $0}' | sort -n | cut -d ' ' -f2- | tail > result.txt

#[4] result.txt에서 한 줄 씩 읽어서 curl을 이용하여 응답 속도 측정
# url.txt에 "응답속도 URL" 형식으로 저장
cat result.txt | while read -r line
do
echo `curl -o /dev/null -s -w "%{time_total}\n" $line` $line >> url.txt
done

#[5] 응답 속도 순으로 정렬하여 출력
cat url.txt | awk '{print $1 " "  $2}' |  sort -n -k1

#[6]
rm -f html *.tmp result.txt

exit 0
