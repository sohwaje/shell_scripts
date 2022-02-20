#!/bin/bash
printhelp()
{
    echo "Usage: $0 -p 3 -i tmp/ -x \"Command -to run\""
    echo "-p : 동시에 실행힐 최대 프로세스 수"
    echo "-x : 작업 대상 파일들이 담겨 있는 디렉토리"
    echo "-i : 파일들을 처리할 명령어"
    echo "example : bulkrun -p 3 -i tmp/ -x \"mogrify -resize 50%\""
    exit -1
}

while getopts "p:i:d:x:" opt
do
    case "$opt" in
        p) procs="$OPTARG"
        ;;
        i) inputdir="$OPTARG"
        ;;
        d) destdir="$OPTARG"
        ;;
        x) command="$OPTARG"
        ;;
        ?) prinfhelp
        ;;
    esac
done

# 입력된 인수 검증 
if [[ -z $procs || -z $command || -z $inputdir || -z $destdir ]];then
    echo "Invalid arguments"
    printhelp
fi

# 작업 대상 디렉토리의 파일 개수를 변수에 저장
total=$(ls $inputdir | wc -l)
# 파일과 디렉토리의 목록을 변수에 저장
declare -a files
files=$(ls -Sr $inputdir)

for i in ${files[@]};do
echo $i
done
for k in $(seq 1 $procs $total)
do      
    for i in $(seq 0 $procs)
    do  
        if [[ $((i+k)) -gt $total ]];then
            wait
            exit 0
        fi

        # file=$(echo "$files" | sed $(expr $i + $k)"q;d")  # 명시된 라인에 도달할 때 sed중지(q)하고 해당 라인을 삭제(d)한 뒤에 그 내용을 출력
        # echo "$k+$i: $(expr $i + $k)"
        # echo "Running $command $inputdir/$file $destdir/"
        # $command "$inputdir/$file" $destdir/ &
    done
wait
done

:
'
- 프로세서가 2개, 파일개수(total) 10개 일 경우
가장 바깥쪽 for문은 총 5회 루프를 돈다. 바깥쪽 푸르가 1회 돌 때 안 쪽 루프는 3회 돈다.
k가 1일 때 i는 0,1,2로 총 3회 돈다. 즉, file 리스트에서 0번째 1번째 2번째 파일이 sed에 의해 삭제된다. 그리고 남아 있는 파일은 다시 다음 루프에 의해 다시 삭제된다.
k가 3일 때 i는 0,1,2
k가 5일 때 i는 0,1,2
k가 7일 때 i는 0,1,2
k가 9일 때 i는 0,1,2
'