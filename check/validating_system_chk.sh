#!/bin/sh
: '
- get_process로 pid 존재여부만 확인하도록 함수 수정
- ipv6 nic는 출력하지 않도록 수정
'
# 출력 색 지정
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
RESET=$(tput sgr0)
 
# 프로세스의 PID 존재여부 확인
get_process()
{
 local value=$(ps aux | grep $1 | grep -v grep | awk '{print $2}'| head -1)
 echo "$value"
}
 
# 확인해야 할 프로세스를 추가
PROCESS=(
 "imapd"
 "stunnel"
 "sendmail"
 "ulocatord"
 "msgputterd"
 "msgrcvd"
 "boxctld"
 "sendspam_pr"
 "unseen2d"
 "dbgated"
 "dbcached"
 "java"
 "rsync"
 "boxd"
 "Pusher"
 "scc_agentd"
 "httpd"
 "sshd"
 "zabbix_agentd"
 "xinetd"
 "nginx" # catch a nginx process
 "php-fpm" # catch a php-fpm process
 "redis"
)
 
# 데몬 확인
DAEMON_CHK()
{
 echo "[데몬 확인]"
 echo "========"
 for i in ${PROCESS[@]};do
 if [[ -z $(get_process $i) ]];then
 # echo -e "$RED Not Active $RESET [$i]"
 printf "%20s %3s\n" "${RED} Not Active ${RESET}" "[$i]"
 
 else
 # echo -e "$GREEN Active $RESET [$i]"
 printf "%20s %3s\n" "${GREEN} Active ${RESET}" "[$i]"
 fi
 done
echo ""
}
 
# NIC 확인
NIC_CHK()
{
 echo "[NIC 확인]"
 echo "========"
 NIC=$(ip addr |grep "inet"|grep -v "inet6"|sed 's/^ *//')
 printf "$GREEN${NIC}$RESET\n"
echo ""
}
 
# NIC 목록 및 NIC 스피드 확인
NIC_SPEED_CHK()
{
 echo "[NIC Speed 켾Y~U뼾]¸]"
 echo "=============="
 NIC_LIST=$(ifconfig -a | sed 's/[ \t].*//;/^$/d' | cut -d ':' -f 1)
 for i in ${NIC_LIST};do
 # echo -e "$i $GREEN $(ethtool $i | grep Speed) $RESET"
 SPEED=$(ethtool $i |grep 'Speed'|awk '{print $2}')
 if [[ "$SPEED" == "1000Mb/s" ]];then
 printf "$i $GREEN $(ethtool $i | grep Speed) $RESET\n"
 elif [[ "$SPEED" == "100Mb/s" ]];then
 printf "$i $RED $(ethtool $i | grep Speed) $RESET\n"
 elif [[ -z "$SPEED" ]] && [[ "$i" == "lo" ]];then
 printf "%0s %13s %10s\n" $i Loopback Interface
 else
 # printf "$i $RED Is this a Virtual Host Interface? Empty Speed $RESET\n"
 printf ""
 fi
 done
echo ""
}
 
# NFS 확인
NFS_CHK()
{
 echo "[NFS 확인]"
 echo "#======="
 NFS=$(df -hT | grep -Po '^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}')
 if [[ -z "${NFS}" ]];then
 echo "No mounted as NFS"
 else
 df -hT | grep "${NFS}"
 fi
echo ""
}
 
# IPTABLES Rules 개수 확인
COUNT_RULES()
{
 echo "[IPTABLES RULES 개수 확인]"
 echo "========================"
 INPUT_COUNT=$(iptables -S INPUT | wc -l)
 FOR_COUNT=$(iptables -S FORWARD | wc -l)
 OUT_COUNT=$(iptables -S OUTPUT | wc -l)
 BLACK_COUNT=$(iptables -S BLACKLIST | wc -l)
 printf "%1s %1s %5s %5s %1s\n" INPUT count: $GREEN $INPUT_COUNT $RESET
 printf "%1s %1s %5s %3s %1s\n" FORWARD count: $GREEN $FOR_COUNT $RESET
 printf "%1s %1s %5s %4s %1s\n" OUTPUT count: $GREEN $OUT_COUNT $RESET
 printf "%1s %1s %5s %1s %1s\n" BLACKLIST count: $GREEN $BLACK_COUNT $RESET
echo ""
}
 
clear
# 스크립트 실행
DAEMON_CHK
NIC_CHK
NIC_SPEED_CHK
NFS_CHK
COUNT_RULES
