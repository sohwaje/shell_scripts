!/bin/sh
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
RESET=$(tput sgr0)
 
# tank 파일시스템의 디바이스, 마운트 포인트, UUID를 /root/old_fs.txt에 저장한다.
if [[ ! -e /root/old_fs.txt ]];then
 lsblk -o NAME,MOUNTPOINT,UUID | \
 grep -i sd | \
 grep tank | \
 grep -v 'SWAP' | \
 sed 's/[^a-z,A-Z,0-9]/ /g' | \
 awk '{print $1"="$2"="$3"-"$4"-"$5"-"$6"-"$7}' > old_fs.txt
fi
 
# 재부팅 전 tank 파일시스템의 디바이스, 마운트 포인트, UUID
old_fs=()
for oldfs in $(cat /root/old_fs.txt);do
 old_fs+=("$oldfs")
done
 # echo ${old_fs[@]} # all value = device
 # echo ${!old_fs[@]} # all Key = UUID
 
# 재부팅 후 tank 파일시스템의 디바이스, 마운트 포인트, UUID
lsblk -o NAME,MOUNTPOINT,UUID | \
 grep -i sd | \
 grep tank | \
 grep -v 'SWAP' | \
 sed 's/[^a-z,A-Z,0-9]/ /g' | \
 awk '{print $1"="$2"="$3"-"$4"-"$5"-"$6"-"$7}' > /root/new_fs.txt
new_fs=()
for newfs in $(cat /root/new_fs.txt);do
 new_fs+=("$newfs") 
done
 # echo ${new_arrs[@]} # all value = device
 # echo ${!new_arrs[@]} # all Key = UUID
 
len=${#old_fs[*]} # 배열 전체 길이 구하기
printf "=================================================================================================================\n"
printf "%20s %38s %30s\n" OLD RESULT NEW
printf "=================================================================================================================\n"
for ((i=0; i<$len; i++)) # 배열 길이만큼 looping
do
 o=$(echo ${old_fs[$i]} |awk -F '=' '{print $1 " " $2 " " "UUID="$3}')
 n=$(echo ${new_fs[$i]} |awk -F '=' '{print $1 " " $2 " " "UUID="$3}')
 if [[ ${old_fs[$i]} != ${new_fs[$i]} ]];then # 배열 인덱스를 활용하여 비교한다.
 # printf "${old_fs[$i]} ${RED} doesn not match ${RESET} ${new_fs[$i]}\n"
 printf "${o} ${RED} doesn not match ${RESET} ${n}\n"
 else
 # printf "${old_fs[$i]} ${GREEN} matches ${RESET} ${new_fs[$i]}\n"
 printf "${o} ${GREEN} matches ${RESET} ${n}\n"
 fi
done
printf "=================================================================================================================\n"
