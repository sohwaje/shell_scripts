#!/bin/bash
var0=0
LIMIT=10

while [ "$var0" -lt "$LIMIT" ]
do
  echo -n "$var0 "        # -n 은 뉴라인을 없애줍니다.
  var0=`expr $var0 + 1`   # var0=$(($var0+1)) 이라고 해도 동작합니다.
done

echo

exit 0
