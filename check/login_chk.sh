#!/bin/sh
# [0] 변수 설정
AUTHENTICATION_FAILURE_USER=af_user
AUTHENTICATION_FAILURE_IP=af_ip
FAILED_PASSWORD_USER=wp_user
FAILED_PASSWORD_IP=wp_ip
# [1]인증 실패(af = authentication failure)
# af_user는 인증에 실패한 계정과 횟수를 출력한다.
# af_ip는 인증에 실패한 IP와 횟수를 출력한다.
# IP를 찾는 정규식 표현 : ([0-9]{1,3}[\.]){3}[0-9]{1,3} 여기서 {1,3}은 앞에 나온 숫자가 최소 한 자리 또는 최대 세 자리리 일치할 때 참이다.
cat /var/log/secure | grep 'authentication failure' | egrep 'rhost|user' | awk '{print $NF}' | awk -F= '{print $2}' | sort | uniq -c | sort -rn | head -10 >> $AUTHENTICATION_FAILURE_USER.txt
cat /var/log/secure | grep 'authentication failure' | egrep 'rhost|user' | grep -Po '([0-9]{1,3}[\.]){3}[0-9]{1,3}' |sort | uniq -c | sort -rn | head -10 >> $AUTHENTICATION_FAILURE_IP.txt

# [2]잘못된 패스워드 입력(wp = wrong password)
# wp_user는 패스워드가 틀린 사용자 계정과 틀린 횟수를 출력한다.
# wp_ip는 패스워드가 틀린 IP와 횟수를 출력한다.
# 전방 탐색(일치하는 문자열 전방을 탐색하되, 일치하는 문자열은 소비하지 않는다.): ?=
# 후방 탐색(일치하는 문자열 후방을 탐색하되, 일치하는 문자열은 소비하지 않는다.): ?<=
# 전방 탐색과 후방 탐색을 사용하여 for와 from 사이의 문자열을 추출한다.
cat /var/log/secure | grep 'Failed password for' | grep -Po '(?<=for).*(?=from)'| sort | uniq -c | sort -rn |head -10 >> $FAILED_PASSWORD_USER.txt
# 'for\K.*(?=from)'를 사용할 수 있다. \K는 일치하는 문자열을 무시한다. --> 'for\K.*(?=from)'
cat /var/log/secure | grep 'Failed password for' | grep -Po '([0-9]{1,3}[\.]){3}[0-9]{1,3}'|sort | uniq -c | sort -rn | head -10 >> $FAILED_PASSWORD_IP.txt

# [3] 출력
echo -e "\e[32m [1]인증 실패 계정 \e[39m"
cat $AUTHENTICATION_FAILURE_USER.txt | while read -r line
do
echo $line
done

echo -e "\e[32m [2]인증 실패 IP \e[39m"
cat $AUTHENTICATION_FAILURE_IP.txt | while read -r line
do
echo $line
done

echo -e "\e[32m [3]잘못된 패스워드 계정 \e[39m"
cat $FAILED_PASSWORD_USER.txt | while read -r line
do
echo $line
done

echo -e "\e[32m [4]잘못된 패스워드 IP \e[39m"
cat $FAILED_PASSWORD_IP.txt | while read -r line
do
echo $line
done

# [4] 출력 후 파일 삭제
rm -f $AUTHENTICATION_FAILURE_USER.txt $AUTHENTICATION_FAILURE_IP.txt $FAILED_PASSWORD_USER.txt $FAILED_PASSWORD_IP.txt
