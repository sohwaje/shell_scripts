#!/bin/bash
# 파일에 자주 접근하고, 디렉토리의 생성/삭제가 빈번한 시스템이라면 Slab 메모리가 높아질 수 있으며, 그 중에서도 dentry, inode_cache가 높아질 수 있다.
while true
do
  slabtop -o | grep -i dentry
  sleep 2
done
