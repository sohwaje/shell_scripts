#!/bin/sh
while :
do
  TIME=`/bin/date +%H:%M:%S`
  printf "|%s " ${TIME}
# Determine CPU load
pcpu=$(ps -Ao pcpu | awk '{sum = sum + $1}END{print sum}')

# Determine MEM load
mem=$(ps -Ao rss | awk '{sum = sum + $1}END{print sum}')

# Determine total MEM
tmem=$(cat /proc/meminfo | awk '/MemTotal/ {print $2}')

# Helper function to convert KB to KB/MB/GB/TB
pretty_print() {
  # We start with KB from /proc/meminfo and ps
  [ $1 -lt 1024 ] && echo "${KB} K" && return
  MB=$((($1+512)/1024))
  [ $MB -lt 1024 ] && echo "${MB} M" && return
  GB=$((($MB+512)/1024))
  [ $GB -lt 1024 ] && echo "${GB} G" && return
  TB=$((($GB+512)/1024))
  [ $TB -lt 1024 ] && echo "${TB} T" && return
}

# Helper function to print bars for percentages
print_bars() {
  local GREEN='\033[32m'
  local YELLOW='\033[33m'
  local RED='\033[31m'
  local RESET='\033[0m'
  # local current=$(($1*10/$2))
  local current=$(echo $1*10/$2 | bc)
  local bars=0
  while [ $current -gt 0 ]; do    # > 0
    [ $bars -lt 3 ] && echo -n $GREEN    # < 3
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

# Output: CPU $pcpu [|||   ] - MEM $mem / $tmem [|||   ]
echo -e "CPU $pcpu [$(print_bars $pcpu 100)] - MEM $(pretty_print $mem) / $(pretty_print $tmem) [$(print_bars $mem $tmem)]"
  sleep 2
  clear
done
