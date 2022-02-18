#!/bin/sh
################################################################
# 스크립트의 오작동을 방지하기 위해 "bc" 유틸리티를 설치해야 합니다.#
# 설치 방법 : yum install -y bc #
# 작성자: 이유성(yusung@sk.com) #
################################################################
UPTOP=$(tput cup 0 0)
ERAS2EOL=$(tput el)
REV=$(tput rev)
OFF=$(tput srgv0)

# bc 설치 유무 체크
if [[ -z $(which bc 2>/dev/null) ]]; then
  echo "Install bc package: yum install -y bc"
  exit 9
fi
clear

while :
do
printf '%s' ${UPTOP}
TIME=`/bin/date +%H:%M:%S`
printf "Average |%s " ${TIME}
# 전체 평균 CPU 사용률(mpstat -P ALL 1 1의 결과값의 9번째 열의 합계를 출력)
total_cpu=$(mpstat -P ALL 1 1 | sed -n 9p | awk '{sum = sum + $3 + $4 + $5 + $6 + $7 + $8 + $9}END{print sum}')

# 프로세스 CPU 사용률
pcpu=$(ps -Ao pcpu | awk '{sum = sum + $1}END{print sum}')

# MEM 사용률
mem=$(ps -Ao rss | awk '{sum = sum + $1}END{print sum}')

# Total 메모리
tmem=$(cat /proc/meminfo | awk '/MemTotal/ {print $2}')

# MEM 사용률 상위 5개
top5_mem=$(ps -Ao comm,rss,pid --sort -rss | grep -ivE 'COMMAND|RSS|PID' |head -5 > /tmp/$(hostname)_mem.$$)

# CPU 사용률 상위 5개
top5_cpu=$(ps -Ao comm,pid,pcpu --sort -pcpu | grep -ivE 'COMMAND|PID|%CPU' |head -5 > /tmp/$(hostname)_cpu.$$)

# 스크립트가 종료되면 임시 파일 삭제
trap "$(which rm) -f /tmp/$(hostname)_*.$$" EXIT

# 킬로 바이트를 MB,GB,TB로 변환시키는 함수
resource_print()
{
 if [[ $1 -lt 1024 ]];then # 값이 1024보다 작으면 킬로바이트로 출력
 echo "${1} K"
 exit 0 # exit 대신 return을 사용할 수 있다. # return은 연산 결과를 반환하거나 넘겨주는 게 아니라 종료 상태값을 저장한다. 여기서 return을 사용하면 조건이 참일 때 다음 if문을 타지 않는다.
 else
 MB=$((($1+512)/1024)) # 값이 1024보다 크면 MB로 변환
 fi

 if [[ $MB -lt 1024 ]];then # 값이 1024보다 작으면 메가바이트로 출력
 echo "${MB} M"
 exit 0
 else
 GB=$((($MB+512)/1024)) # 값이 1024보다 크면 GB로 변환
 fi

 if [[ $GB -lt 1024 ]];then # 값이 1024보다 작으면 기가바이트로 출력
 echo "${GB} G"
 exit 0
 else
 TB=$((($GB+512)/1024)) # 값이 1024보다 크면 TB로 전환
 fi

 if [[ $TB -lt 1024 ]];then # 값이 1024보다 작으면 테라바이트로 출력
 echo "${TB} T"
 exit 0
 else
 echo "${TB} T" # 값이 1024보다 커도 테라바이트로 출력
 fi
 }

# 퍼센테이지를 "|" 출력으로 보이게 하는 함수
print_bars() {
 local GREEN='\033[32;1m'
 local YELLOW='\033[33;1m'
 local RED='\033[31;1m'
 local RESET='\033[0m' # 모든 색과 스타일을 검은 바탕의 흰색으로 초기화
 local current=$(echo $1*10/$2 | bc) # bash는 floating-point를 표현할 수 없기 때문에 서드파티 프로그램 bc를 설치해야 한다.
 local bars=0
 while [[ $current -gt 0 ]]; do # current=0 보다 크면 루프를 시작해서 current-1만큼 루프를 탐. current=10이면 1씩 감소하면서 10번 루프를 탐.
    if [[ $bars -lt 3 ]];then
        echo -n $GREEN"|"
    fi
    if [[ $bars -gt 2 ]] && [[ $bars -lt 6 ]]; then
        echo -n $YELLOW"|"
    fi
    if [[ $bars -gt 5 ]] && [[ $bars -lt 10 ]];then
        echo -n $RED"|"
    fi
  current=$(($current - 1))
  bars=$((bars + 1)) # current는 1씩 감소하지만, bars는 1씩 늘어남. bar 개수가 늘면 "|"도 늘어남.
 done
 echo $RESET # echo -n $GREEN echo -n "|" echo $RESET ===> \033[32m(GREEN) | \033[0m\n
 while [ $bars -lt 10 ]; do
    echo -n ''
    bars=$((bars + 1))
 done 
 }

# MEM 사용률 상위 5개
print_top5_mem()
{
 printf " - TOP 5 Memory utilization per Process\n"
 printf "+-------------------+------+--------------+\n"
 printf "|       PROCES      | PID  | MEM used     |\n"
 printf "+-------------------+------+--------------+\n"
 cat /tmp/$(hostname)_mem.$$| while read PROCESS MEMUSED PID
 do
 printf "|%18s |%5s | %5s %1s      |%1s%s\n" $PROCESS $PID $(resource_print $MEMUSED) [$(print_bars $MEMUSED $tmem)] "${ERAS2EOL}"
 done
 printf "+-------------------+-----+---------------+" 
 }

# CPU 사용률 상위 5개
print_top5_cpu() 
{
 printf " - TOP 5 Cpu utilization per Process\n"
 printf "+-------------------+------+--------------+\n"
 printf "|     PROCESS       | PID  | CPU used     |\n"
 printf "+-------------------+------+--------------+\n"
 cat /tmp/$(hostname)_cpu.$$| while read PROCESS PID CPUUSED
 do
 printf "|%18s |%5s | %5s        |%1s%s\n" $PROCESS $PID $CPUUSED [$(print_bars $CPUUSED 100)] "${ERAS2EOL}"
 done
 printf "+-------------------+-----+---------------+" 
 }

# socket 모니터링
socket_mon()
{
 printf " - Network Socket Monitoring\n"
 printf "+-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+ \n"
 printf "|ESTAB|LISTN|T_WAT|CLOSD|S_SEN|S_REC|C_WAT|F_WT1|F_WT2|CLOSI|L_ACK| \n"
 printf "+-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+ \n"
 netstat -an | \
 awk 'BEGIN {
 CLOSED = 0;
 LISTEN = 0;
 SYN_SENT = 0;
 SYN_RECEIVED = 0;
 ESTABLISHED = 0;
 CLOSE_WAIT = 0;
 FIN_WAIT_1 = 0;
 FIN_WAIT_2 = 0;
 CLOSING = 0;
 LAST_ACK = 0;
 TIME_WAIT = 0;
 OTHER = 0;
 }
 $6 ~ /^CLOSED$/ { CLOSED++; }
 $6 ~ /^CLOSE_WAIT$/ { CLOSE_WAIT++; }
 $6 ~ /^CLOSING$/ { CLOSING++; }
 $6 ~ /^ESTABLISHED$/ { ESTABLISHED++; }
 $6 ~ /^FIN_WAIT1$/ { FIN_WAIT_1++; }
 $6 ~ /^FIN_WAIT2$/ { FIN_WAIT_2++; }
 $6 ~ /^LISTEN$/ { LISTEN++; }
 $6 ~ /^LAST_ACK$/ { LAST_ACK++; }
 $6 ~ /^SYN_SENT$/ { SYN_SENT++; }
 $6 ~ /^SYN_RECV$/ { SYN_RECEIVED++; }
 $6 ~ /^TIME_WAIT$/ { TIME_WAIT++; }

 END {
 printf "| %4d| %4d| %4d| %4d| %4d| %4d| %4d| %4d| %4d| %4d| %4d|\n",ESTABLISHED,LISTEN,TIME_WAIT,CLOSED,SYN_SENT,SYN_RECEIVED,CLOSE_WAIT,FIN_WAIT_1,FIN_WAIT_2,CLOSING,LAST_ACK;
 }'
 printf "+-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+ \n"
 sleep 3
}

# 결과물: CPU $pcpu [||| ] - MEM $mem / $tmem [||| ] 
echo -e " CPU $total_cpu % [$(print_bars $total_cpu 100)] - MEM $(resource_print $mem) / $(resource_print $tmem) [$(print_bars $mem $tmem)] ${ERAS2EOL}"
echo ''
echo -e "$(print_top5_mem)"
echo ''
echo -e "$(print_top5_cpu)"
echo ''
socket_mon
 sleep 3
done
exit
