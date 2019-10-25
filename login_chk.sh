#!/bin/sh
# 인증 실패(af = authentication failure)
af_user=`cat /var/log/secure | grep 'authentication failure' | egrep 'rhost|user' | awk '{print $NF}' | awk -F= '{print $2}' | sort | uniq -c | sort -rn | head -10`
af_ip=`cat /var/log/secure | grep 'authentication failure' | egrep 'rhost|user' | grep -Po '([0-9]{1,3}[\.]){3}[0-9]{1,3}' |sort | uniq -c | sort -rn | head -10`

# 잘못된 패스워드 입력(wp = wrong password)
wp_user=`perl -ne 'print "$1\n" if(/Failed password for (\w.+) from/)' /var/log/secure | sort | uniq -c | sort -rn |head -10'`
wp_ip=`cat /var/log/secure | grep 'Failed password for' | grep -Po '([0-9]{1,3}[\.]){3}[0-9]{1,3}'|sort | uniq -c | sort -rn | head -10`
