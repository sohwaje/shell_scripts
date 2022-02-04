#!/bin/bash
# 첫 번째 인자가 "-l"이면 length는 두 번째 인자가 된다. 그리고 모든 인자를 shift(제거)한다.
if [[ "$1" = "-l" ]]; then
   length="$2"
   shift 2
fi

# test
func()
{
   echo "$1 $2 $3 $4"
   shift 2
   echo "$#"
}
