#!/bin/sh
:
'
- 다수의 디스크에 다수의 파티션이 생성될 경우 UUID로 마운트 포인트를 잡지 않으면 가끔 파티션 명과 UUID가 서로 섞이는 문제가 발생한다.
- 주로 온프레미스의 물리 서버들에 해당된다.
- 시스템을 재부팅 하기 전 현재의 "디바이스명,파티션,UUID" 정보를 저장해 놓고, 재부팅 후 현재의 정보와 비교하여 일치 여부를 확인한다.
'
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
RESET=$(tput sgr0)

# 재부팅 전 파일시스템 정보 파일과 재부팅 후 파일 시스템 정보 파일 저장 경로
OLD_FILE_SYSTEM="/root/old_fs.txt"
NEW_FILE_SYSTEM="/root/new_fs.txt"

disk_info()
{
lsblk -o NAME,MOUNTPOINT,UUID | \
 grep -E "sd|xv" | \                # 물리 디스크 명
 grep -E "/|SWAP" | \               # 파티셔닝 된 파일 시스템은 "/"로 시작하고, 스왑은 "SWAP"로 나타난다.
 sed 's/[^a-z,A-Z,0-9,/]/ /g' | \   # 모든 특수문자를 공백으로 대체하지만, 단 "/"는 파티션을 나타내므로 대체하지 않는다.( /, /boot, /data, /home 등)
 awk '{print $1"="$2"="$3"-"$4"-"$5"-"$6"-"$7}'
}

# 디바이스, 마운트 포인트, UUID를 /root/old_fs.txt에 저장한다.
old_fs_()
{
if [[ ! -e "$1" ]];then
 disk_info > "$1"  # UUID의 공백은 다시 "-"로 대체한다.
fi
old_fs=()
for oldfs in $(cat "$1");do
 old_fs+=("$oldfs")
done
 # echo ${old_fs[@]} # all value = device
 # echo ${!old_fs[@]} # all Key = UUID
}

new_fs_()
{
disk_info > "$1"
new_fs=()
for newfs in $(cat "$1");do
 new_fs+=("$newfs") 
done
 # echo ${new_arrs[@]} # all value = device
 # echo ${!new_arrs[@]} # all Key = UUID
}

print_result()
{
len=${#old_fs[*]} # 배열 전체 길이 구하기
printf "=================================================================================================================\n"
printf "%20s %38s %30s\n" OLD RESULT NEW
printf "=================================================================================================================\n"
for ((i=0; i<$len; i++)) # 배열 길이만큼 looping
do
 o=$(echo ${old_fs[$i]} |awk -F '=' '{print $1 " " $2 " " "UUID="$3}')  # old 정보 출력 결과 가공
 n=$(echo ${new_fs[$i]} |awk -F '=' '{print $1 " " $2 " " "UUID="$3}')  # new 정보 출력 결과 가공
 if [[ ${old_fs[$i]} != ${new_fs[$i]} ]];then # 배열 인덱스를 활용하여 비교한다.
 # printf "${old_fs[$i]} ${RED} doesn not match ${RESET} ${new_fs[$i]}\n"
 printf "${o} ${RED} doesn not match ${RESET} ${n}\n"
 else
 # printf "${old_fs[$i]} ${GREEN} matches ${RESET} ${new_fs[$i]}\n"
 printf "${o} ${GREEN} matches ${RESET} ${n}\n"
 fi
done
printf "=================================================================================================================\n"
}

old_fs_ $OLD_FILE_SYSTEM
new_fs_ $NEW_FILE_SYSTEM
print_result
