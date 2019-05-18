#!/bin/bash
# find 명령어를 이용하여 모든 파일과 디렉토리의 경로 locatedb에 저장한다.
# 특정 파일과 디렉토리 이름으로 찾을 때 이 locatedb에 인덱스된 경로를 찾아 화면에 출력한다.
# 주의해야 할 것은 cdn 관리 서버나, 각종 이미지들이 저장되어 있는 서버에서 이 스크립트를 실행하면
# 너무 많은 파일이나 디렉토리 때문에 시간이 오래걸릴 수 있다는 것이다.

#[1]locatedb 경로
locatedb="/var/locate.db"
#[2]root 사용자만 엑세스
chmod +x 100 $locatedb

#[3]스크립트를 액세스 하려는 사용자 확인
if [ "$(whoami)" != "root" ]; then
  echo "root 사용자만 실행할 수 있습니다." > &2
  exit 1
fi

find / -print > $locatedb

exit 0
