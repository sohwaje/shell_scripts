#!/bin/sh

#[1]커널 정보 확인
echo -e "\e[42m 커널 정보 확인 \e[0m"
uname -a

#[2]하드웨어 밴더 확인
echo -e "\e[42m 하드웨어 BIOS, 밴더 정보 확인 \e[0m"
dmidecode -t bios | egrep '(Vendor|Version|Release Date)'
dmidecode -t system | egrep '(Manufacturer|Product Name)'

#[3]CPU 정보 확인
echo -e "\e[42m CPU 개수, Core 개수 확인 \e[0m"
p=$(grep "physical id" /proc/cpuinfo | sort -u | wc -l)
core=$(dmidecode -t processor| grep 'Core Count' | awk '{print $3}')
echo "$p P,$core core"

#[4]메모리 슬롯 정보 확인
echo -e "\e[42m  메모리 슬롯, 사이즈 정보 확인 \e[0m"
dmidecode -t memory | grep -i size:

#[5]파티션 사이즈 확인
echo -e "\e[42m 파티션 사이즈 확인 \e[0m"
df -hT

#[6]NIC 정보 확인
echo -e "\e[42m NIC 상태 정보 확인 \e[0m"
nic_list=$(netstat -nr | awk '{print $NF}')
for i in $nic_list
do
echo $i
echo `ethtool $i | egrep '(Speed|Duplex|Auto-negotiation|Link)'`
done
