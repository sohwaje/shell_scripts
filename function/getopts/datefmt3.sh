#!/bin/sh
# getopt  -o|--options shortopts와 [-l|--longoptions longopts] [-n|--name progname] [--] parameters

# shortopts		옵션을 정의하는 문자
# longopts		긴 옵션을 정의하는 문자 (--diffs와 같은 긴 옵션 정의) ,(콤마)로 구분한다.
# progname      오류 발생시 리포팅할 프로그램 명칭(현재 셸 스크립트 파일명)
# parameters     옵션에 해당하는 실제 명령 구문(보통은 모든 파라미터를 뜻하는 $@ 사용)

# ex) ./datefmt3 -d 3 --unit month --format +%m-%d

print_try() {
    echo "Try './datefmt3.sh -h' for more information!"
    exit 1
}

print_help() {
    echo "usage : ./datefmt3.sh -d <diffs> -u <unit> [-f format]"
    echo "usage : ./datefmt3.sh -d|--diffs <diffs> -u|--unit <unit> [-f|--format format]"
    exit 1
}

options="$(getopt -o d:u:f:h -l diffs:,unit:,format:,help -- "$@")"  # "$@"는 실제 명령 구문
eval set -- $options  # "set --"는 뒤에 붙여진 문자열을 다 쪼개준다. "-d, 3, --unit, month, --format, +%m-%d, --"
                      # eval은 '$options' 문자열을 명령처럼 실행시킨다. 

# ### 요소의 내용 보기
# echo "@=$@"
# echo "1=$1, 2=$2, 3=$3, 4=$4, 5=$5, 6=$6, 7=$7"
# exit 1
# ### 출력 
# @=-d 3 --unit month --format +%m-%d --
# 1=-d, 2=3, 3=--unit, 4=month, 5=--format, 6=+%m-%d, 7=--

while true
do
    # echo "$1, $2  [$@]"
    # 첫 번째 루프 : -d, 3  [-d 3 --unit month --format +%m-%d --]
    # 두 번째 루프 : --unit, month  [--unit month --format +%m-%d --]
    # 세 번째 루프 : --format, +%m-%d  [--format +%m-%d --]
    # 마지막 루프  : --,   [--]
    case $1 in
        -d|--diffs)
            D=$2        
            shift 2;;       # --unit, month  [--unit month --format +%m-%d --]
        -u|--unit)
            U=$2
            shift 2;;       # --format, +%m-%d  [--format +%m-%d --]
        -f|--format)
            F=$2
            shift 2;;       # --,   [--]
        -h|--help)
            print_help;;
        --)
            break;;
        *)
            print_try;;
    esac
done

RET=`date $F --date="$D $U"`
echo "$RET"