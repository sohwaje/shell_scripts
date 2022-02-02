#!/bin/sh
a_flag=0
separator=""
while getopts "ap:" option
do
    case $option in
     a)
       a_flag=1;;
     p)
       separator="$OPTARG";;
     \?)
       echo "Usage: getopts.sh [-a] [-p separator] target_dir" 1>&2
       exit 1;;
    esac
done

# 옵션 지정을 위치 파라미터에서 삭제하기
shift $(expr $OPTIND - 1)
path="$1"

# -a 옵션이 지정되었는지 쉘 변수 a_flag 값으로 판단하기
if [[ $a_flag -eq 1 ]];then
    ls -a -- "$path"
else
    ls -- "$path"
fi

if [[ -n "$separator" ]]; then
    echo "$separator"
fi