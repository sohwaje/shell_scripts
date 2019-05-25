#!/bin/sh
while true
do
echo -e "\e[42m=====================================UPTIME=====================================\e[0m"
echo ""
  uptime
echo ""
echo -e "\e[42m===========================전체 CPU 사용률=========================================\e[0m"
echo ""
  mpstat 1 2 | tail -n 1 | awk '{print "user:"$3"  ""system:"$5"  ""iowait:"$6"  ""idel:"$NF}'
echo ""
echo -e "\e[42m===========================프로세스 CPU 사용률======================================\e[0m"
echo ""
 pidstat 1 5 | grep "Average"
echo ""
echo -e "\e[42m============================실시간 TCP 통신량======================================\e[0m"
echo ""
  sar -n TCP,ETCP 1 1 | grep -i "Average"
echo ""
echo -e "\e[42m===========================네트워크 사용량=========================================\e[0m"
echo ""
  sar -n DEV 1 1 | grep -i "Average"
echo ""
echo -e "\e[42m============================시스템 상태 전반=======================================\e[0m"
echo ""
  vmstat 1 5 | tail -n+2
echo ""
echo -e "\e[42m=============================연결된 소켓 개수=======================================\e[0m"
echo ""
  netstat -napo | grep -i 'EST' | wc -l
echo ""
echo -e "\e[42m=============================TIME_WAIT 소켓 개수===================================\e[0m"
echo ""
  netstat -napo | grep -i 'TIME_WAIT' | wc -l
echo ""
echo -e "\e[42m=============================SYN_RECV 소켓 개수====================================\e[0m"
echo ""
  netstat -napo | grep -i 'SYN_RECV' | wc -l
echo ""
echo ""
done
