#! /bin/sh
FILE=mysql_processlist.txt
DT=$(date +%Y%m%d%H%M)
QUERY="select next_val as id_val from hibernate_sequence for update%"
# 특정 쿼리의 thread id 가져오기
if [ -f /tmp/$FILE ]; then
        echo "mv $FILE $DT"
        mv $FILE $DT
        /usr/local/mysql/bin/mysql -uroot -p'PASSWORD' -e "SELECT CONCAT('KILL ',id,';') from information_schema.processlist where INFO like '$QUERY' into outfile '/tmp/$DT.txt';"
fi

# 실행 시간 기준 thread id 가져오기(예: 300초)
if [ -f /tmp/$FILE ]; then
        echo -e "\033[1;32m mv $FILE $DT \033[0m"
                sleep 1
                 mv $FILE $DT
      /mysql/bin/mysql -uroot -p'PASSWORD' -e "SELECT CONCAT('KILL ',id,';') AS run_this FROM information_schema.processlist WHERE Command='$COMMAND' AND user='$USER' AND time >= 300 order by time DESC INTO OUTFILE '/tmp/$DT.txt';"
fi

#[3] Descriptions
 echo -e "\033[1;32m 1) 300초 이상의 프로세스 ID가 /tmp/$DT.txtt에 저장됨  \033[0m"

 echo -e "\033[1;32m 2) 해당 process ID를 강제 종료하려면, MySQL에 접속해서 mysql> source /tmp/$DT.txt를 입력 \033[0m"
