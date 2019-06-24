#!/bin/sh
#[1] find 경로에서 1년 이상 변경이 없는 모든 파일을 찾아 삭제한다.
#[2] 에러가 발생하지 않도록 -f옵션 사용, -v옵션을 사용하여 삭제한 파일명을 기록. 
#[3] 필요 시 삭제하지 않고, 파일명을 기록하는 용도로 사용할 수 있다.
TARGET_DIR="/home"

# delete
find $TARGET_DIR -name "*.*" -mtime +364 -print | xargs rm -fv

# archive
#find $TARGET_DIR -name "*.*" -mtime +364 -print >> no_use_file.txt
