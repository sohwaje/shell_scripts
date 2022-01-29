#!/bin/sh
### Name : rsync_go.sh
### Author : YuSung Lee
### Version : 1.0
### Date : 2022-01-24

# 스크립트는 원본 서버에서 실행하며, 데이터는 원본 서버에서 사본 서버로 복사된다.
# 원본 서버에서 다음과 같이 실행 : ./rsync_go.sh -s <소스디렉토리> -d <사본 서버IP>
 
## 도움말 출력
print_help()
{
 # 사용법: ./rsync_go.sh -s <Src dir> -d <데이터를 쏠 IP>
 echo "usage : $0 -s <Src dir> -d <Dst Ipaddress>"
 exit 1
}
 
## 인자값이 3개 미만이면 print_help 함수 호출하고 프로그램 종료
if [[ $# -lt 2 ]]; then
 print_help
fi
 
## Main task code
while getopts s:d:h opt
do
 case $opt in
 s)
 S=$OPTARG;;
 d)
 D=$OPTARG;;
 h)
 print_help;;
 *)
 print_help;;
 esac
done
 
if [[ -z ${S}] || -z ${D} ]]; then
 echo "Invalid arguments"
 print_help
fi
 
## 소스 디렉토리 마지막에 "/"로 끝나는지 확인해서 없으면 추가
if [[ $(echo ${S:(-1)}) == "/" ]]; then
 SRC_DIR=${S}
 echo $SRC_DIR
elif [[ $(echo ${S:(-1)}) != "/" ]]; then
 SRC_DIR=${S}/
 echo $SRC_DIR
fi
 
## 스크립트 실행 시작 시간
StartTime=$(date +%s)
 
## 멀티스레드 방식으로 스크립트를 실행시키는 옵션
put_multi_thread_rsync()
{
 echo "ls -d ${dir} | xargs -I {} -P 5 -n 1 rsync ${OPTION} --size-only {} ${D}::R${dir}"
 ls -d ${dir} | xargs -I {} -P 5 -n 1 rsync ${OPTION} --size-only {} ${D}::R${dir}
}
 
rsync_go()
{
## 0 depth : 최초 0depth 디렉토리 내용을 가져옴
for i in $(ls -d ${SRC_DIR} 2> /dev/null); do
 echo "0 depth"
 dir=${i}
 OPTION="-lptgoDqd"
 put_multi_thread_rsync
 
 ## 1 depth : 1depth 디렉토리 내용을 가져옴
 for j in $(ls -d ${i}*/ 2> /dev/null); do
 echo "1 depth #"
 dir=${j}
 OPTION="-lptgoDqd"
 put_multi_thread_rsync
 
 ## 2 depth : 2depth 디렉토리 내용을 가져옴
 for k in $(ls -d ${j}*/ 2> /dev/null); do
 echo "2 depth ##"
 dir=${k}
 OPTION="-lptgoDqd"
 put_multi_thread_rsync
  
 ## 3 depth : 3depth 이하는 -av로 모두 가져옴
 for l in $(ls -d ${k}*/ 2> /dev/null); do
 echo "3 depth ##"
 dir=${l}
 OPTION="-av"
 put_multi_thread_rsync
 done
 done
 done
done
}
 
rsync_go
 
EndTime=$(date +%s)
echo "It takes $(($EndTime - $StartTime)) seconds to complete this task."
#
