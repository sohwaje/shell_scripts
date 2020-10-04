#!/bin/bash
# # 스크립트 이름을 포함한 절대 경로, e.g. /home/user/bin/foo.sh
Absolute_path_to_script()
{
  SCRIPT=$(readlink -f "$0")
  echo $SCRIPT
}

# 스크립트 디렉토리의 절대 경로, e.g. /home/user/bin
Absolute_path_to_dir()
{
  SCRIPT=$(readlink -f "$0")
  BASENAME=$(dirname "$SCRIPT")
  echo $BASENAME
}
