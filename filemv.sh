#!/bin/sh
# 소스 디렉토리에서 2018년도에 생성된 모든 로그를 타겟 디렉토리의 2018년도의 디렉토리로 파일을 복사하거나 옮긴다.
# 이때 타겟 디렉토리에 2018년도 디렉토리가 없으면 생성한다.

# 변수를 설정한다.
TARGETDIR="/test/test/"
YEAR="2018"

# 디렉토리가 없으면 생성한다.
if ! [ -d $TARGETDIR$YEAR ]
then
  mkdir -p -m 776 $TARGETDIR$YEAR
fi

# 파일을 복사한다.
  echo "Starting File copy or move"
for file in `ls -l --time-style full-iso | awk '{print $6" "$9}' | grep $YEAR | awk '{print $2}'`
do
  cp -arpv $file $TARGETDIR$YEAR
done
