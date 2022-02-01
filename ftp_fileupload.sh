#!/bin/bash
# Using ncftp as ftp
# usage : ./ftp_fileupload.sh -file=*
HOST="www.example.com"
PORT="21"
ID="exampleid"
PASSWD="examplepassword"
UPLOADDIR="/data"
FILE_LIST="*"

print_helper() {
        # 이 스크립트를 사용하는데 필요한 도움말을 출력합니다.
        echo '  -h              : 도움말'
        echo '  -addr=<address> : IP or URL'
        echo '  -port=<port>    : 접속할 포트 번호 (default:21)'
        echo '  -id=<user id>   : id'
        echo '  -pw=<password>  : password'
        echo "  -uppath=<path>  : upload path (default : $UPLOADDIR)"
        echo '  -file=<"file1,file2,file3 ...">' : file list

        exit
}

set_paramter() {
        if [ $1 == '-h' ]   # 인자값이 -h면 도움말을 출력한다.
        then
                print_helper
        fi

        # 입력받은 파라미터러부터 key와 value를 구한다.
        # key=value로 파라미터가 구성된다.
        # print_helper 참고

        arr=$(echo $1 | tr "=" "\n") # 배열의 첫번째 인자값($1)이 "="면 줄바꿈으로 변경한다.

        declare -i count=0
        local key="none"
        local value="none"

        # Key 값과 Value 값을 추출합니다.
        for x in $arr
        do
                if [ $count -eq 0 ]
                then
                        key=$x

                elif [ $count -eq 1 ]
                then
                        value=$x
                fi

                count=$count+1
        done

        # 추출된 key, value를 가지고
        # $key와 문자열을 비교해서 같으면 True
        if [ $key == "-addr" ]
        then
                IP=$value

        elif [ $key == "-port" ]
        then
                PORT=$value

        elif [ $key == "-id" ]
        then
                ID=$value

        elif [ $key == "-pw" ]
        then
                PW=$value

        elif [ $key == "-file" ]
        then
                FILE_LIST=$(echo $value | tr "," "\n")
        else
                print_helper
                exit
        fi
}

function print_parameter_info() {
        echo 'HOST =' $HOST
        echo 'PORT =' $PORT
        echo 'ID =' $ID
        echo 'PW =' $PASSWD
        echo 'FILE_LIST=' $FILE_LIST

        local x
        for x in $FILE_LIST
        do
                echo "file_list='$x'"
        done
}

send_file() {
        echo "################ FTP 업로드 시작 ################"
        echo $UPLOADDIR
        sleep 2

        ncftp -u $ID -p $PASSWD $HOST  <<END_SCRIPT

cd $UPLOADDIR
put -R $1

quit
END_SCRIPT

        echo "################ FTP 업로드 완료 ################"
}

# ncftp가 설치되어 있는지 확인
file=$(which ncftp 2>/dev/null)
if [[ ! -f $file ]];then
#   echo "echo"
# else
  echo "Not install ncftp. Need to install ncftp package."
  echo "COMMAND: yum install -y ncftp"
  exit 9
fi

# 인자값이 없으면 print_helper 함수 호출
if [ $# -eq 0 ]
then
        print_helper
fi

# 인자값이 0보다 많을 때 loop
while [ $# -gt 0 ]
do
        key=$1
        value=$2

        set_paramter ${key} ${value}
        # shift를 이용하면 입력받은 파라미터가 1개씩 제거됩니다.
        shift
done

print_parameter_info

for x in $FILE_LIST
do
        echo "send file = $x"
        send_file $x
done

exit 0
