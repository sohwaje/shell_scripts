#!/bin/sh
# 원본 디렉토리
SOURCE_FILE_LIST="/home/source"
# 목적지 디렉토리(파일이 복사될 디렉토리)
DEST_DIR="/home/dest"
# 복사할 파일 목록
FILE="copy_list.txt"

# 목록에서 한 줄 씩 읽어서 목적지 디렉토리에 복사한다.
main(){
cat ${SOURCE_FILE_LIST} | while read line
do
  echo "Start Copy to ${DEST_DIR}"
  sleep 2
  cp -arpv $SOURCE/$line ${DEST_DIR}  # cp -arpv /home/source/$line /home/dest
done
echo "Done"
}

# 복사 함수 호출
main
