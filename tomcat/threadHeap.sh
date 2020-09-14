#!/bin/bash
/bin/echo -e "\e[1;31mThread and Heap Dump Script\e[0m"
todate=$(date +"%Y-%m-%d-%H")
ps -aux|grep eletter_tomcat7
/bin/echo -e "\e[1;31mHEAPDUMP와 THREAD DUMP가 필요한 PID를 고른다\e[0m"
#echo "Which Java Process ID you need to take heapDump"
read proid
echo "PID를 입력하고 엔터를 누른다."
echo $proid

echo "start heapdumping...."
jmap -dump:format=b,file=/tmp/heapdump-001$todate.hprof $proid
thread=`cat /proc/$proid/status | grep Threads | awk '{print $2}'`

echo "start threaddumping..."
jstack $proid > /tmp/threaddump-$thread-$todate.log

echo $?

if [ "$?" = "0" ]; then
	echo -e " \e[32mHeap Dump and heap dumo got sucessfull. Check the file in /tmp/heapdump-001$todate.hprof & /tmp/threaddump-$thread-$todate.log "
else
         echo "Dump failed"
        exit 1
fi
