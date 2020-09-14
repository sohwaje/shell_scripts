#!/bin/sh
## 로컬에서 SSH를 통해 원격지의 서버의 명령어를 실행시키고 그 결과값을 용도에 맞게 활용한다.
## 응용 : ./script_remote.sh | egrep '/home|IP' >> result.txt
## 'df -h'를 실행한 /home 디렉토리 사용량 부분과 서버의 IP를 result.txt에 저장한다.
# 출력결과 : IP = 10.10.10.10 ext4   197G  150G   37G  81% /home
USERNAME="USERNAME"
PASSWORD='PASSWORD'
COMMAND='df -hT'

for IP in 10.10.10.[10..20]
do
echo "IP = $IP"
sshpass -p$PASSWORD ssh $USERNAME@$IP $COMMAND
sleep 1
done
