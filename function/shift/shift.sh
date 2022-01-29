#!/bin/bash
# 첫 번째 인자가 "-l"이면 length는 두 번째 인자가 된다. 그리고 모든 인자를 shift(제거)한다.
if [[ "$1" = "-l" ]]; then
   length="$2"
   shift 2
fi

# 인자의 개수가 1개 이거나 첫 번째 인자가 읽을 수 없는 파일이면 echo를 출력한다.
if [[ $# -ne 1 -o ! -r "$1" ]]; then
   echo "Usage: $(basename $0) [-l len] error_log" >&2
   exit1
fi