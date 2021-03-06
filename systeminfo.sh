#!/bin/sh
#############################################################
#리눅스 시스템의 하드웨어 정보를 간략하게 확인할 수 있는 스크립트#
#############################################################

#[1]커널 정보 확인
echo -e "\e[32m[1]커널 정보\e[39m"
uname -a

#[2]하드웨어 밴더 확인
echo -e "\e[32m[2]하드웨어 BIOS, 밴더 정보 확인\e[39m"
HW_VENDOR=$(dmidecode -t bios | egrep '(Vendor|Version|Release Date)')
HW_VENDOR2=$(dmidecode -t system | egrep '(Manufacturer|Product Name)')
echo $HW_VENDOR
echo $HW_VENDOR2

#[3]CPU 정보 확인
echo -e "\e[32m[3]CPU 모델, 클럭 정보 확인\e[39m"
CPU=$(cat /proc/cpuinfo | grep -i 'model name' | sort -u | awk -F ":" '{print $2}')
echo $CPU

echo -e "\e[32m[3]CPU 개수, Core 개수 확인\e[39m"
p=$(grep "physical id" /proc/cpuinfo | sort -u | wc -l)
core=$(grep "cpu cores" /proc/cpuinfo | tail -1 | awk '{print $4}')
echo "$p P,$core core"

#[4]메모리 슬롯 정보 확인
echo -e "\e[32m[4]메모리 개수, 사이즈 정보 확인\e[39m"
mem=$(dmidecode -t memory | grep -i size: | grep -v 'No')
echo $mem

#[5]파티션 사이즈 확인
echo -e "\e[32m[5]디스크 사이즈 확인\e[39m"
fdisk -l |perl -ne 'print if /\/dev.+/'

#[6]NIC 정보 확인
echo -e "\e[32m[6]NIC 상태 정보 확인\e[39m"
nic_list=$(netstat -nr | awk '{print $NF}' | grep -v ^table | grep -v ^Iface)
for i in $nic_list
do
echo $i
echo `ethtool $i | egrep '(Speed|Duplex|Auto-negotiation|Link)'`
done

#[7]IP 리스트 확인
echo -e "\e[32m[6]IP 리스트 확인\e[39m"
# ifconfig -a | grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' => 정규식을 통해 IP리스트만 확인할 수 있음.
# '/^[a-z]'/ : 인터페이스명을 출력하기 위한 것. 소문자 알파벳으로 시작하는 줄의 첫 번째 컬럼
# "[" $1 "]" : 인터페이스명에 대괄호[eth0]를 추가함.
# arr[2] ":"로 분할한 컬럼 중에서 두 번째 컬럼
ifconfig | awk '/^[a-z]/ {print "[" $1 "]"} /inet / {split($2,arr,":"); print arr[2]}' | grep -v '127.0.0.1'

route -n | grep -e 'UG' | awk '{print "GW: " $2}'
