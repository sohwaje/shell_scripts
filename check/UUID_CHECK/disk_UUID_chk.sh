#!/bin/sh
:
'
- 재부팅 후 디스크 disk의 device 명과 UUID가 서로 변경되는 현상을 체크하고자 만들었습니다.
- 재부팅 전에 반드시 기존 disk device 정보와 UUID를 저장하기 위해 이 스크립트를 1회 실행합니다.
'
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
RESET=$(tput sgr0)

# old 디바이스 정보를 /root/old_device.txt에 저장
if [[ ! -e /root/old_device.txt ]];then
    blkid|grep UUID| awk '{print $1 " " $2}' | grep -v "sr0" > /root/old_device.txt
fi

# 재부팅 전 디바이스 및 UUID 정보 가공
old_arrs=()
:
'
- old_device.txt의 $2번째 컬럼의 "UUID"를 $1 컬럼명으로 변경하고 그 변경된 형태에서 $2번째 컬럼을 출력한다.
'
for old in $(cat /root/old_device.txt | awk -F ':' '{sub("UUID", $1,$2); print}' |awk '{print $2}');do
            old_arrs+=("$old")
done
            # echo ${old_arrs[@]} => all value = device
            # echo ${!old_arrs[@]} => all key = UUID

# 재부팅 후 새로운 디바이스 및 UUID 정보 저장
blkid|grep UUID| awk '{print $1 " " $2}' | grep -v "sr0" > /root/new_device.txt
new_arrs=()
for new in $(cat /root/new_device.txt | awk -F ':' '{sub("UUID", $1,$2); print}' |awk '{print $2}');do
            new_arrs+=("$new")
done
            # echo ${new_arrs[@]} => all value = device
            # echo ${!new_arrs[@]} => all key = UUID

len=${#old_arrs[*]} # 배열 전체 길이 구하기
for ((i=0; i<$len; i++))
do
    if [[ ${old_arrs[$i]} != ${new_arrs[$i]} ]];then # 배열의 인덱스를 활용하여 비교한다
        printf "${old_arrs[$i]} ${RED} does not match ${RESET} ${new_arrs[$i]}\n"
    else
        printf "${old_arrs[$i]} ${GREEN} matches ${RESET} ${new_arrs[$i]}\n"
    fi
done