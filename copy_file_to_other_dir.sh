#!/bin/sh
# 복사할 파일 목록이 담긴 리스트 파일 위치
SOURCE_FILE_LIST="/home/SOURCE_FILE_LIST/apps/txt.txt"
# 복사할 디렉토리 위치
DEST_DIR="/home/DEST_DIR/apps/backup"

# 복사 시작 출력
echo -e "\033[40;37;7m  Start Copy to ${DEST_DIR} \033[0m"

# 복사 함수: 목록에서 한 줄 씩 읽어서 목적지 디렉토리에 복사한다.
start(){
cat ${SOURCE_FILE_LIST} | while read line
do
  sleep 2
  cp -arpv $line ${DEST_DIR}
done
}

# 복사 함수 호출
start

# 복사 끝 출력
echo -e "\033[40;37;7m  Done!!! \033[0m"
