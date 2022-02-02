#!/bin/bash
# 첫 번째 인자가 "-l"이면 length는 두 번째 인자가 된다. 그리고 모든 인자를 shift(제거)한다.
if [[ "$1" = "-l" ]]; then
   length="$2"
   shift 2
fi

# 전체 파라미터의 개수가 1과 같거나 첫 번째 파라미터가 읽을 수 없다면 echo를 출력한다.
if [[ $# -ne 1 -o ! -r "$1" ]]; then
   echo "Usage: $(basename $0) [-l len] error_log" >&2
   exit1
fi