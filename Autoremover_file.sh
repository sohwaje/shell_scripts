#!/bin/bash
### Name    : AutoRemover_file.sh
### Author  : sohwaje
### Version : 1.0
### Date    : 2021-12-09
#######################################################################################################
# - 삭제 가능한 파일을 찾아 자동으로 삭제하고 삭제 한 파일의 전체 크기, 개수를 Slack에 전송하는 스크립트 #
#######################################################################################################
 
# 백업 디렉토리 변수 설정
BACKUP_DIR_NAME="/var/log/AutoRemover"

# 찾아서 삭제해야 할 파일 확장자를 등록한다.
DELETE_TARGET=(
  "*.log"
  "*.txt"
  "*.tmp"
  "*.zip"
  "*.tar.gz"
  "*.7zip"
  "*.bak"
  "*.backup"
  "*.bmp"
  "*.gif"
)

# 삭제 대상이 되는 모든 파일을 배열에 추가한다.
all_find_function()
{
 for i in "${DELETE_TARGET[@]}";do
 find / -type f -name "${i}" 2>/dev/null
 done
}

# find로 찾은 파일의 사이즈의 합계를 구하는 함수
TOTAL_COMMAND_ARG() {
    awk 'BEGIN{result=0} {result += $5} END {print result}'| awk '{value = $1/1024; print value "KB"}'
}

# Slack 채널로 알림을 전송하는 함수
WEBHOOK_ADDRESS=""
slack_message() {
    curl -X POST -H 'Content-type: application/json' \
--data '{
    "attachments": [
        {
            "color": "'"$COLOR"'",
            "pretext": "*Alert Bot*",
            "author_name": "*Delete File Alert*",
            "author_icon": "https://cdn.icon-icons.com/icons2/623/PNG/512/sign-emergency-code-sos_131_icon-icons.com_57207.png",
            "fields": [
                {
                    "title": "Priority : *높음*",
                    "short": false
                }
            ],
            "image_url" : "",
            "thumb_url" : "",
            "footer" : "Slack API",
            "footer_icon" : "https://platform.slack-edge.com/img/default_application_icon.png",
            "text":"*HOST* : '"$HOSTNAME"' \n*Delete File list* : '"$filelist"' \n*Delete File Ext* : '"${DELETE_TARGET[i]}"' \n*Delete File Size* : '"${SIZES[i]}"' \n*Delete Files* : '"${FILES[i]}"'외 '"${NUMBERS[i]}"'개 '"$icon_emoji"'"
        }
    ]
}' $WEBHOOK_ADDRESS > /dev/null 2>&1
}

# 삭제하기 전 파일이 저장되는 디렉토리, 없으면 만든다.
if [[ ! -d "${BACKUP_DIR_NAME}" ]]; then
    mkdir "${BACKUP_DIR_NAME}"
fi

# 삭제할 파일들의 목록을 /var/log/AutoRemover에 저장한다.
all_find_function | while read filename
do 
  echo "$filename" >> "${BACKUP_DIR_NAME}"/AR-$(date '+%y%m%d').txt
done

# 삭제 대상 확장자의 총 사이즈, 총 개수, 첫 번째 파일의 이름을 배열에 저장
SIZES=()
NUMBERS=()
FILES=()
for i in "${!DELETE_TARGET[@]}";
do
    S=$(find / -type f -name "${DELETE_TARGET[$i]}" -not -path "/proc*" -exec ls -l {} \;| TOTAL_COMMAND_ARG) # 파일 사이즈 합계 "/proc 디렉토리는 제외한다"
    SIZES+=("$S")
    N=$(find / -type f -name "${DELETE_TARGET[$i]}" -not -path "/proc*" -exec ls -l {} \;|wc -l)              # 파일 개수
    NUMBERS+=("$N")
    F=$(basename $(find / -type f -name "${DELETE_TARGET[$i]}" -not -path "/proc*" | head -1) 2>/dev/null)    # 삭제 대상 파일 중 첫 번째 파일
    FILES+=("$F")
done

echo "삭제할 파일의 목록이 있는 텍스트 파일을 읽어서 각 파일을 차례로 /var/log/AutoRemover에 옮긴 뒤에 삭제한다."
while read file; 
do
    echo \cp -afvr "${file}" "${BACKUP_DIR_NAME}" # 실제 복사하지 않고 복사 명령어를 echo로 실행(테스트 용)
    echo rm -f "${file}" # 실제 삭제하지 않고 삭제 명령어를 echo로 출력(테스트 용)
done < "${BACKUP_DIR_NAME}"/AR-$(date '+%y%m%d').txt
clear

# alert 서버에 Json 포맷으로 전송하는 코드
for i in "${!FILES[@]}";
do
    filelist=AR-$(date '+%y%m%d').txt
    # echo -e "\033[1;35m 삭제 대상 파일 - "${DELETE_TARGET[i]}", 사이즈 - "${SIZES[i]}" \033[0m"
    slack_message "$filelist ${DELETE_TARGET[i]} ${SIZES[i]} ${FILES[i]} ${NUMBERS[i]}" true
done