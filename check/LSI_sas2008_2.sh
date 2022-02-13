#!/bin/sh
sas2ircu 0 display |grep 'State'|awk -F ':' '{print $2}' >> /tmp/status.txt
sas2ircu 0 display |grep 'Slot #'|awk -F ':' '{print $2}' >> /tmp/hdd_no.txt
paste /tmp/status.txt /tmp/hdd_no.txt >> /tmp/disk_info.txt
 
 
INDEX=0
cat /tmp/disk_info.txt |awk '{print $1}'| while read line; do
 if [[ "$line" == "Optimal" ]];then
 msg="\" $(hostname): DISK $INDEX is OK"\"
 echo "${msg}"
 else
 msg="\" $(hostname): DISK $INDEX was Failed"\"
 echo "${msg}"
 fi
 INDEX=`expr $INDEX + 1`
done
 
 
rm -f /tmp/status.txt /tmp/hdd_no.txt /tmp/disk_info.txt
 
exit 0
