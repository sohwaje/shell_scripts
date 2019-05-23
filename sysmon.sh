#!/bin/sh
while true
do
echo "=========================================UPTIME============================================="
echo ""
  uptime
echo ""
echo "===================================전체 CPU 사용률==========================================="
echo ""
  mpstat 1 2 | tail -n 1 | awk '{print "user:"$3"  ""system:"$5"  ""iowait:"$6"  ""idel:"$NF}'
echo ""
echo "===================================프로세스 CPU 사용률======================================="
echo ""
 pidstat 1 5 | grep "Average"
echo ""
echo "====================================실시간 TCP 통신량========================================"
echo ""
  sar -n TCP,ETCP 1 1 | grep -i "Average"
echo ""
echo "====================================네트워크 사용량=========================================="
echo ""
  sar -n DEV 1 1 | grep -i "Average"
echo ""
echo "======================================시스템 상태 전반========================================"
echo ""
  vmstat 1 5 | tail -n+2
echo ""
echo "======================================연결된 소켓 개수========================================"
echo ""
  netstat -napo | grep -i 'EST' | wc -l
echo ""
echo "======================================TIME_WAIT 소켓 개수====================================="
echo ""
  netstat -napo | grep -i 'TIME_WAIT' | wc -l
echo ""
echo "======================================SYN_RECV 소켓 개수====================================="
echo ""
  netstat -napo | grep -i 'SYN_RECV' | wc -l
echo ""
echo ""
done
