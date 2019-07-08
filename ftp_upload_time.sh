#!/bin/sh
# FTP URL(IP), USER ID, PASSWORD 변수
URL="10.10.10.10"
USER="USER_ID"
PASSWORD="PASSWORD"

# 파일 사이즈 변수(KB)
filesize=1024

# 파일명
tmpdata="tmpdata.tmp"
timefile="timecount.tmp"

# 파일 생성 명령줄(bs는 기본 블록사이즈)
dd if=/dev/urandom of="$tmpdata" count=$filesize bs=1024 2> /dev/null

echo "FileSize: $filesize (kb)"
echo "FTP Server: $URL"

# time 명령어를 통해 시간을 기록하면서 FTP로 데이터를 전송한다.
(time -p ftp -i -n "$URL") << __EOT__ 2> $timefile
user $USER $PASSWORD
binary
hash
prompt
put $tmpdata
__EOT__

# 전송 결과 중 소요시간에 관한 문자열 캡쳐
realtime=$(awk '/^real / {print $2}' "$timefile")

# 파일사이즈/소요시간으로 속도를 구한다.
speed=$(echo "${filesize}/${realtime}" | bc)
echo "Transfer Speed : $speed (KB/sec)"

# 스크립트에 의해 생성된 임시 파일을 삭제
rm -f "$tmpdata" "$timefile"
