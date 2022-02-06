#!/bin/sh
while :
do
  TIME=`/bin/date +%H:%M:%S`
  printf "|%s " ${TIME}
# CPU 사용률
pcpu=$(ps -Ao pcpu | awk '{sum = sum + $1}END{print sum}')

# MEM 사용률
mem=$(ps -Ao rss | awk '{sum = sum + $1}END{print sum}')

# Total 메모리
tmem=$(cat /proc/meminfo | awk '/MemTotal/ {print $2}')

# 킬로 바이트를 MB,GB,TB로 변환시키는 함수
resource_print()
{
  if [[ $1 -lt 1024 ]];then   # 값이 1024보다 작으면 킬로바이트로 출력
  echo "${1} K"
  exit 0    # exit 대신 return을 사용할 수 있다.  # return은 연산 결과를 반환하거나 넘겨주는 게 아니라 종료 상태값을 저장한다. 여기서 return을 사용하면 조건이 참일 때 다음 if문을 타지 않는다.
  else
  MB=$((($1+512)/1024))       # 값이 1024보다 크면 MB로 변환
  fi

  if [[ $MB -lt 1024 ]];then  # 값이 1024보다 작으면 메가바이트로 출력
  echo "${MB} M"
  exit 0
  else
  GB=$((($MB+512)/1024))      # 값이 1024보다 크면 GB로 변환
  fi

  if [[ $GB -lt 1024 ]];then  # 값이 1024보다 작으면 기가바이트로 출력
  echo "${GB} G"
  exit 0
  else
  TB=$((($GB+512)/1024))      # 값이 1024보다 크면 TB로 전환
  fi

  if [[ $TB -lt 1024 ]];then  # 값이 1024보다 작으면 테라바이트로 출력
  echo "${TB} T"
  exit 0
  else
  echo "${TB} T"              # 값이 1024보다 커도 테라바이트로 출력
  fi
}

# 퍼센테이지를 "|" 출력으로 보이게 하는 함수
print_bars() {
  local GREEN='\033[32m'
  local YELLOW='\033[33m'
  local RED='\033[31m'
  local RESET='\033[0m'               # 모든 색과 스타일을 검은 바탕의 흰색으로 초기화
  local current=$(echo $1*10/$2 | bc) # bash는 floating-point를 표현할 수 없기 때문에 서드파티 프로그램 bc를 설치해야 한다.
  local bars=0
  while [[ $current -gt 0 ]]; do          # 현재값이 0보다 크면 루프 시작 []
        if [[ $bars -lt 3 ]];then
              echo -n $GREEN"|"             # $current [0 |1 |2] 
        fi            
        if [[ $bars -gt 2 ]] && [[ $bars -lt 6 ]]; then
              echo -n $YELLOW"|"            # $current [|3 |4 |5]  
        fi
        if [[ $bars -gt 5 ]] && [[ $bars -lt 10 ]];then
              echo -n $RED"|"              # $current [|6 |7 |8]
        fi
    # echo -n "|"   ## 개행하 않고 한 줄로 표시된다. echo -n $GREEN echo -n "|" ===> \033[32m(GREEN) |
    current=$(($current - 1))
    bars=$((bars + 1))
  done
  echo $RESET     ## echo -n $GREEN echo -n "|" echo $RESET  ===> \033[32m(GREEN) | \033[0m\n
  while [ $bars -lt 10 ]; do
    echo -n ''
    bars=$((bars + 1))
  done
}

# 결과물: CPU $pcpu [|||   ] - MEM $mem / $tmem [|||   ]
echo -e "CPU $pcpu [$(print_bars $pcpu 100)] - MEM $(resource_print $mem) / $(resource_print $tmem) [$(print_bars $mem $tmem)]"
  sleep 2
  clear
done

## [해설] print_bars()
# +--------+--+--+--+--+--+--+--+--+--+--+--+
# |current |10|9 |8 |7 |6 |5 |4 |3 |2 |1 |0 |
# |--------+--+--+--+--+--+--+--+--+--+--+--+
# |color   |G |G |G |Y |Y |Y |R |R |R |R |- |
# +--------+--+--+--+--+--+--+--+--+--+--+--+
# |bar     |0 |1 |2 |3 |4 |5 |6 |7 |8 |9 |- |
# +--------+--+--+--+--+--+--+--+--+--+--+--+