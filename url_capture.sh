#!/bin/bash
:
'
1. https://www.daum.net의 html을 다운로드 받는다.
2. 다운로드 받은 html 파일에서 http 또는 https로 시작하는 URL 링크를 캡쳐한다.
3. 캡쳐한 URL을 응답속도 순서로 정렬하여 출력한다.
'
# url index 다운로드(ex: https://www.nate.com)
download_url()
{
 echo -e "INPUT URL: \c "
 read URL
 wget -O /tmp/html_$$.tmp $URL > /dev/null 2>&1
}
 
# html 파일에서 http,https로 시작하는 모든 url 추출
capture_url()
{
 local regex='(https?)://[-A-Za-z0-9\+&@#/%?=~_|!:,.;]*[-A-Za-z0-9\+&@#/%=~_|]'
 cat /tmp/html_$$.tmp | grep -Po "$regex" | awk '{print length, $0}' | sort -n | cut -d ' ' -f2- > /tmp/url_$$.tmp
}
 
print_url_orderby_speed()
{
 download_url && capture_url
 
 if [ $? -eq 0 ];then
 echo "Capture URL"
 else
 echo "Failed to capture URL"
 exit -1
 fi
 
 # curl을 이용하여 응답 속도 측정
 cat /tmp/url_$$.tmp | while read -r line
 do
 echo `curl -o /dev/null -s -w "%{time_total}\n" $line` $line >> /tmp/url.txt
 done
 # 응답 속도 순으로 정렬하여 출력
 cat /tmp/url.txt | awk '{print $1 " " $2}' | sort -n -k1
}
 
print_url_orderby_speed
 
# 임시 파일 및 url 파일 삭제
rm -f /tmp/html_$$.tmp /tmp/url_$$.tmp /tmp/url.txt
 
exit 0
