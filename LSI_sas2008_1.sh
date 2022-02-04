#!/bin/sh
check=$(sas2ircu 0 display |grep State |grep -v Optimal |grep -v Rebuilding |wc -l)
sas2ircu 0 display |grep 'State'|awk -F ':' '{print $2}' >> /tmp/status.txt
sas2ircu 0 display |grep 'Slot #'|awk -F ':' '{print $2}' >> /tmp/hdd_no.txt
paste /tmp/status.txt /tmp/hdd_no.txt >> /tmp/disk_info.txt
 
 
cat /tmp/disk_info.txt| while read line; do
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
