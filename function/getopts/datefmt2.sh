#!/bin/sh

print_try() {
    # 옵션 이외의 것이 입력되었을 때 help 메세지를 출력한다.
    echo "Try './datefmt2.sh -h' for more information!"
    exit 1
}

print_help() {
    # 옵션이 -h이면 사용방법을 출력한다.
    echo "usage : ./datefmt2.sh -d <diffs> -u <unit> [-f format]"
    exit 1
}

while getopts d:u:f:h opt   # getopts 함수가 옵션을 정의하는 문자(-d,-u,-f,-h)를 받는다. 인수가 있는 옵션은 뒤에 콜론(:)을 붙인다.
do
    # echo "opt=$opt, OPTARG=$OPTARG"   #opt는 옵션, OPTARG는 인수를 받는다
    case $opt in
        d)
            D=$OPTARG;;     # -d 옵션의 인수는 D=$OPTARG
        u)
            U=$OPTARG;;
        f)
            F=$OPTARG;;
        h)
            print_help;;
        *)
            print_try;;
    esac
done

if [ -z $F ]; then        # -f 옵션을 주지 않을 경우 기본 포맷(+%m-%d)으로 정의한다.
    F="+%m-%d"
fi

RET=`date $F --date="$D $U"`
echo "$RET"