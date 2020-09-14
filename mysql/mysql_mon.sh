#!/bin/sh
BASE=/home/sigongweb/work/db_mon/
WWW=/usr/share/netdata/web
CHECK_LIST="slave01 slave02 slave03 slave04 slave05 slave06 slave07 slave08 slave09 slave10"
cat /dev/null > "${WWW}/db_check.html"

for CHECK in $CHECK_LIST
do
/bin/sh "${BASE}${CHECK}"_check.sh >> "${WWW}/db_check.html"
echo "${BASE}${CHECK}_check.sh" 
done


