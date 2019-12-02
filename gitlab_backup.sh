#!/bin/sh
#[1] 백업 파일 위치(FROM_DRI), 백업 파일을 저장할 위치(TO_DIR)
FROM_DIR=/var/opt/gitlab/backups
TO_DIR=/gitlab_backup

#[2] 만료된 백업 파일 삭제
find $TO_DIR -type f -mtime +6 | sort | xargs rm -f

#[3] gitlab 백업 시작
gitlab-rake gitlab:backup:create

#[3] gitlab 백업이 성공하면 FROM_DIR에서 TO_DIR에 백업 파일을 저장한다.
if [ $? -eq 0 ];then
    mv $FROM_DIR/*.tar $TO_DIR/
    yes|cp -arpf /etc/gitlab/gitlab.rb /gitlab_backup/
    yes|cp -arpf /etc/gitlab/gitlab-secrets.json /gitlab_backup/
else
    exit 9
fi
