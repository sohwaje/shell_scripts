#!/bin/bash
_f100=15  # 100%가 되기 위한 개수 지정(15 = 100%)
_current=0 i=0
_spin="⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏"
declare a b
echo ""
printf '\e[1;34m%-6s\e[m' "Spawning Containers"
echo "
"
tput civis
stty -echo
CleanUp () {
   tput cnorm
   stty echo
}
trap CleanUp EXIT

# 프로그래시브 바의 진행율을 표시하기 위한 명령 또는 다른 실행 파일(백그라운드로 실행)
for (( i = 0 ; i < 14; i++)); do  sleep 5;  touch /home/sigongweb/test/$i; done > /dev/null 2>&1 &

ProgressBar () {
   _percent=$((${1}*100/${_f100}*100/100))
   _progress=$((${_percent}*4/10))
   _remainder=$((40-_progress))
   _completed=$(printf "%${_progress}s")
   _left=$(printf "%${_remainder}s")
   printf "\rProgress : [\e[42m\e[30m${_completed// /#}\e[0m${a}${_spin:i++%${#_spin}:1}${b}${_left// /-}] ${_percent}%%"
}
while [ "${_current}" -lt "${_f100}" ]    # _f100보다 작은 경우 while loop
do
   sleep 1
   _current=$(ls -l /home/sigongweb/test | wc -l)
    if [ "${_current}" = "${_f100}" ]
      then
       _spin="#"
       a="\e[42m\e[30m"
       b="\e[0m"
    fi
      ProgressBar "${_current}"
done
echo "
"
printf '\e[0;32m%-6s\e[m' "$(tput bold)Containers are Ready!!"
echo "
"
# EOF