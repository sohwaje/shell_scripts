#!/bin/sh
# [1]인증 실패(af = authentication failure)
# af_user는 인증에 실패한 계정과 횟수를 출력한다.
# af_ip는 인증에 실패한 IP와 횟수를 출력한다.
# IP를 찾는 정규식 표현 : ([0-9]{1,3}[\.]){3}[0-9]{1,3} 여기서 {1,3}은 앞에 나온 숫자가 최소 한 자리 또는 최대 세 자리리 일치할 때 참이다.
af_user=`cat /var/log/secure | grep 'authentication failure' | egrep 'rhost|user' | awk '{print $NF}' | awk -F= '{print $2}' | sort | uniq -c | sort -rn | head -10`
af_ip=`cat /var/log/secure | grep 'authentication failure' | egrep 'rhost|user' | grep -Po '([0-9]{1,3}[\.]){3}[0-9]{1,3}' |sort | uniq -c | sort -rn | head -10`
# [2]잘못된 패스워드 입력(wp = wrong password)
# wp_user는 패스워드가 틀린 사용자 계정과 틀린 횟수를 출력한다.
# wp_ip는 패스워드가 틀린 IP와 횟수를 출력한다.
# 전방 탐색(일치하는 문자열 전방을 탐색하되, 일치하는 문자열은 소비하지 않는다.): ?=
# 후방 탐색(일치하는 문자열 후방을 탐색하되, 일치하는 문자열은 소비하지 않는다.): ?<=
# 전방 탐색과 후방 탐색을 사용하여 for와 from 사이의 문자열을 추출한다.
wp_user=`cat /var/log/secure | grep 'Failed password for' | grep -Po '(?<=for).*(?=from)'| sort | uniq -c | sort -rn |head -10`
# 'for\K.*(?=from)'를 사용할 수 있다. \K는 일치하는 문자열을 무시한다. --> 'for\K.*(?=from)'
wp_ip=`cat /var/log/secure | grep 'Failed password for' | grep -Po '([0-9]{1,3}[\.]){3}[0-9]{1,3}'|sort | uniq -c | sort -rn | head -10`

echo $af_user
echo $ af_ip

echo $wp_user
echo $wp_ip
