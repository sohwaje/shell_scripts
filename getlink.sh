#!/bin/bash

if [ $# -eq 0 ]; then
  echo "Usage: $0 [-d|-i|-x] url" >&2
  echo "-d: domain only, -i:interal only, -x:external only" >&2
  exit 1
fi

if [ $# -gt 1 ]; then
  case "$1" in
    -d) lastcmd="cut -d/ -f3|sort|uniq"  # "http://www.example.com/example"의 경우 필드 구분자(/)로 구분된 문자열 필드 3번째를 출력한다(www.example.com)
        shift
        ;;
    -r) basedomain="http://$(echo $2 | cut -d/ -f3)/"
        lastcmd="grep \"^$basedomain\"|sed \"s|$basedomain||g\"|sort|uniq"
        shift
        ;;
    -a) basedomain="http://$(echo $2 | cut -d/ -f3)/"
        lastcmd="grep -v \"^basedomain\"|sort|uniq"
        shift
        ;;
     *) echo "$0: 올바른 옵션을 지정하지 않음: $1" >&2
        exit 1
  esac
    lastcmd="sort|uniq"
fi

lynx -dump "$1"|\
  sed -n '/^References$/,$p'|\
  grep -E '[[:digit:]]+\.'|\
  awk '{print $2}'|\
  cut -d\? -f1|\
  eval $lastcmd #lastcmd의 ""가 변수가 아닌 명령어로 작동하게 한다.

exit 0
