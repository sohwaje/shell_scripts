#!/bin/sh
### Name    : fdisk.sh
### Author  : sohwaje
### Version : 1.0
### Date    : 2021-11-22
################################################################################
# - 새 디스크가 설치되었을 때 이를 파티셔닝 하는 스크립트
# - 현재 설치된 디스크(신규 디스크 포함)과 마운트 된 디스크를 비교하여 신규 디스크를 찾는다
# - 신규 디스크에 파티셔닝과 포맷을 진행한 후에 OS에 자동 마운트 한다.
################################################################################
###[0] 변수(디바이스 타입, 마운트 포인트)
DEVICE="sd" # sda, sdb, sdc ...

MOUNTPOINT_ARRAY=( ## 마운트 포인트 배열 ( array1 array2 )
    /data3

)
###[1] 디스크 찾기
# OS의 모든 디스크 찾기(신규 디스크가 보임)
DISK=$(lsblk -o NAME,HCTL,SIZE,MOUNTPOINT | grep -i ${DEVICE} | awk '{print $1}' | sed 's/[^a-z,A-Z,0-9]//g')

# 마운트된 디스크 찾기(신규 디스크는 안 보임)
MOUNT=$(mount | grep -i "/dev/${DEVICE}" | awk '{print $1}' | cut -f 3 -d '/' | sed 's/[^a-z]//g')

# 파티셔닝 된 디스크를 배열로 저장.(ex: sda, sdb 등)
DISK_ARRAY=() # 빈 배열 생성
for i in ${DISK[@]};
do
    if [[ $i == ${DEVICE}[a-z] ]]; then
    DISK_ARRAY+=("$i") # DISK_ARRAY에 하나씩 추가 됨.
    fi
done
echo ${DISK_ARRAY[@]}

## 두 배열을 비교하여 중복되지 않는 배열의 요소를 출력(그것이 파티셔닝 대상이 될 디스크)하여 변수에 저장
TARGETDISK=$(echo ${DISK_ARRAY[@]} ${MOUNT[@]} | tr ' ' '\n' | sort | uniq -u)

###[2] 타겟디스크 array에 담긴 요소를 가져와서 디스크 포멧
for i in ${TARGETDISK[@]};
do
    sudo parted /dev/${i} --script mklabel gpt mkpart xfspart xfs 0% 100%
    sudo mkfs.xfs /dev/${i}1
    sudo partprobe /dev/${i}1
done
echo ${TARGETDISK[@]}
###[3] 마운트 포인트 array에 담긴 요소를 가져와서 생성
for i in ${MOUNTPOINT_ARRAY[@]};
do
    sudo mkdir $i
done

###[4] 디스크 UUID를 배열에 추가
UUID_ARRAY=() # 디스크 UUID 배열
for i in ${TARGETDISK[@]};
do
    UUID=$(sudo blkid | grep -i /dev/${i}1| awk '{print $2}')
    UUID_ARRAY+=($UUID) #배열에 추가
done
echo ${UUID_ARRAY[@]}

###[5] !UUID_ARRAY[@]는 array 전체 원소의 인덱스 값만 추출한다. 이것으로 각 Array의 인덱스 값에 매칭되는 string을 가져온다.
# ex) UUID_ARRAY의 array에 요소가 두 개면 인덱스는 0, 1이 된다. 먼저 인덱스 0이 첫번째 array 변수 ${UUID_ARRAY[$i]}와 ${MOUNTPOINT_ARRAY[$i]}에 매칭되고 
# 각 array의 0번 인덱스에 해당하는 string을 가져오게 되는 것이다.
# ref : https://stackoverflow.com/questions/17403498/iterate-over-two-arrays-simultaneously-in-bash
for i in "${!UUID_ARRAY[@]}"; do
    echo "${UUID_ARRAY[$i]}    ${MOUNTPOINT_ARRAY[$i]}  xfs defaults    0 0" | sudo tee -a /etc/fstab
done


# ###[6] mount
sudo mount -a