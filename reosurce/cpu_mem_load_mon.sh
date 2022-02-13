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
  if [[ $1 -lt 1024 ]];then
  echo "${1} K"
  exit 0    # exit 대신 return을 사용할 수 있다.  # return은 연산 결과를 반환하거나 넘겨주는 게 아니라 종료 상태값을 저장한다. 여기서 return을 사용하면 조건이 참일 때 다음 if문을 타지 않는다.
  else
  MB=$((($1+512)/1024))
  fi

  if [[ $MB -lt 1024 ]];then
  echo "${MB} M"
  exit 0
  else
  GB=$((($MB+512)/1024))
  fi

  if [[ $GB -lt 1024 ]];then
  echo "${GB} G"
  exit 0
  else
  TB=$((($GB+512)/1024))
  fi

  if [[ $TB -lt 1024 ]];then
  echo "${TB} T"
  exit 0
  fi
}

# Helper function to print bars for percentages
print_bars() {
  local GREEN='\033[32m'
  local YELLOW='\033[33m'
  local RED='\033[31m'
  local RESET='\033[0m'
  local current=$(echo $1*10/$2 | bc) # bash는 floating-point를 표현할 수 없기 때문에 서드파티 프로그램 bc를 설치해야 한다.
  local bars=0
  while [ $current -gt 0 ]; do    
    [ $bars -lt 3 ] && echo -n $GREEN   
    [ $bars -gt 2 ] && echo -n $YELLOW
    [ $bars -gt 5 ] && echo -n $RED
    echo -n "|"
    current=$(($current - 1))
    bars=$((bars + 1))
  done
  echo $RESET
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
