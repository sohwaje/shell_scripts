#!/bin/bash
printhelp()
{
    echo "Usage: $0 -p 3 -s tmp/ -d /tmp"
    echo "-p : 동시에 실행힐 최대 프로세스 수"
    echo "-s : 소스 디렉토리"  
    echo "-d : 목적지 디렉토리"
    echo "example : bulkcopy -p 3 -s /srcdir -d /destdir"
    exit -1
}

result_time()
{
    if [[ $1 == "begin" ]];then
        StartTime=$(date +%s)
    elif [[ $1 == "end" ]];then
        EndTime=$(date +%s)
        echo "It takes $(($EndTime - $StartTime)) seconds to complete this task."
    else
        exit 1
    fi

}

## 스크립트 실행 시작 시간
result_time "begin"
start_copy()
{
    command="cp -avr"
    total=$(ls $srcdir | wc -l)
    files=$(ls -Sr $srcdir)
    for k in $(seq 1 $procs $total)
    do 
        for i in $(seq 0 $procs)
        do  
            if [[ $((i+k)) -gt $total ]];then  # 스크립트 종료 if문
                wait
                result_time "end"
                exit 0
            fi

            if [[ $k != 1 && $i == 0 ]];then # 중복 제거
                continue
            fi
            
            file=$(echo "$files" | sed $(expr $i + $k)"q;d")  # $i+$k번째 라인 출력
            echo "Running $command $srcdir/$file $destdir/"
            $command "$srcdir/$file" $destdir/ &
        done
        echo "####################### $k #######################"
        wait
    done
}

while getopts "p:s:d:" opt
do
    case "$opt" in
        p) procs="$OPTARG"
        ;;
        s) srcdir="$OPTARG"
        ;;
        d) destdir="$OPTARG"
        ;;
        ?) prinfhelp
        ;;
    esac
done

# 입력된 인수 검증 
if [[ -z $procs || -z $srcdir || -z $destdir ]];then
    echo "Invalid arguments"
    printhelp
fi

start_copy