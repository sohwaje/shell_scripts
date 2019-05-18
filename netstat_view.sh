OUT_OF_ORDER=`netstat -s -p --tcp | grep 'out of order' | awk '{print $1}'`
echo $OUT_OF_ORDER
