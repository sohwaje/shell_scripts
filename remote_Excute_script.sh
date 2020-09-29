#!/bin/sh
## 로컬에서 SSH를 통해 원격지의 서버의 명령어를 실행시키고 그 결과값을 용도에 맞게 활용한다.
## 응용 : ./script_remote.sh | egrep '/home|IP' >> result.txt
## 'df -h'를 실행한 /home 디렉토리 사용량 부분과 서버의 IP를 result.txt에 저장한다.
# 출력결과 : IP = 10.10.10.10 ext4   197G  150G   37G  81% /home
USERNAME="sigongweb"
PASSWORD='!#SI0aleldj*)'
COMMAND='chmod +x /home/sigongweb/apps/alert/api-alert.sh'

IPADDRESS=("10.1.0.5" "10.1.0.15" "10.1.0.6" "10.1.0.17" "10.1.0.18" "10.1.0.8" "10.1.0.9" "10.1.0.26" "10.1.0.27"
"10.1.0.11" "10.1.0.12" "10.1.0.13" "10.1.0.14" "10.1.0.23" "10.1.0.24" "10.1.0.200")
for IP in ${IPADDRESS[@]}
do
echo "IP = $IP"
sshpass -p$PASSWORD ssh -p 16215 -o StrictHostKeyChecking=no $USERNAME@$IP $COMMAND
sleep 1
done
