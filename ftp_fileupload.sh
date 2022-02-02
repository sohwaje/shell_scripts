#!/bin/bash

# 기본 변수
HOST="127.0.0.1"
PORT=""
ID="ftpuser"
PW="passw0rd"

# 도움말 함수
print_helper() 
{
        echo '  -h: 도움말'
        echo '  -r: -u 업로드디렉토리'
        echo '  -l: -l 로컬디렉토리'

        exit
}

# 스크립트 사용법 출력 함수
print_try()
{
        echo "Usage: $0 -r REMOTEDIR -l LOCALDIR"
        echo "example1: ./ftpupload.sh -r data -l /home/centos"
        exit 1
}

# Remote 디렉토리, Local 디렉토리 옵션
while getopts r:l:f:h opt
do
        case $opt in
            r)
                REMOTEDIR=$OPTARG;;
            l)
                LOCALDIR=$OPTARG;;
            h)
                print_helper;;
            *)
                print_try;;
        esac
done

# FTP로 파일 전송 함수
send_data() {
        echo ""
        echo "################ FTP 업로드 시작 ################"
        sleep 2
        ncftp -u $ID -p $PW -P $PORT $HOST 1> /dev/null <<END_SCRIPT

cd $REMOTEDIR
put -R $1
END_SCRIPT
        echo "send data = ${LOCALDIR}/$i"
        echo "################ FTP 업로드 완료 ################"
}


# ncftp가 설치되어 있는지 확인
check_ncftp()
{
        if [[ ! -f $(which ncftp 2>/dev/null) ]];then
        echo "Not install ftp client. Need to install ftp package."
        echo "COMMAND: yum install -y ftp"
        exit 9
        fi
}

# 파라미터 체크
parameter_check()
{
        if [[ -z $REMOTEDIR || -z $LOCALDIR ]];then
        print_try
        exit 1
        fi

        # 포트 변수가 비어 있으면 기본 포트(21) 사용.
        if [[ -z $PORT ]];then 
        echo "Set default port(21)"
        PORT="21"
        fi
}

parameter_check
# FTP 파일 전송 메인 스크립트
for i in $(ls ${LOCALDIR} 2> /dev/null)
do
        send_data "${LOCALDIR}/$i"
done

exit 0
