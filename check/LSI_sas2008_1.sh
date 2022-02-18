#!/bin/bash
check=$(sas2ircu 0 display |grep State |grep -v Optimal |grep -v Rebuilding |wc -l) # 비정상 하드디스크 디바이스 개수 확인
status=$(sas2ircu 0 display |grep 'State'|awk -F ':' '{print $2}')
hdd_no=$(sas2ircu 0 display |grep 'Slot #'|awk -F ':' '{print $2}')
result=$(paste <(echo "$status") <(echo "$hdd_no"))
 
 
echo "$result" | while read line; do
 if [[ "$check" == "0" ]];then
 echo "ALL OK"
 else
 # $line 변수의 $1 필드 값이 "Optimal"이 아니면 "Not OK:" 메시지와 함께 $3필드를 출력
 msg=$(echo $line |awk '$1 != "Optimal" { print "Not OK:" $3 }')
 echo $msg
 fi
done
 
 
rm -f /tmp/status.txt /tmp/hdd_no.txt /tmp/disk_info.txt
 
exit 0
