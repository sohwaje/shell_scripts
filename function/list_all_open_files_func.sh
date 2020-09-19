#!/bin/sh
# 열려 있는 모든 파일을 찾는다.
# %l : 심볼릭 링크 포함
_find_all_open_file()
{
find /proc/*/fd -xtype f -printf "%l\n" 2>/dev/null | grep -v "(deleted)$"|sort -u| grep -v '/proc'|grep -v '/opt'
}
