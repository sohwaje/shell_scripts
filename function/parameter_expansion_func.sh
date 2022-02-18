sample()
{
 local base=${1##*/}
 local pid_file=${2:-/var/run/$base.pid}    # 왼쪽 변수(2)가 비어 있으면 오른쪽 값(/var/run/$base.pid)을 출력
 local HOME_DIR=${HOME:-/var/run/$base.pid}
 local pid_dir=$(/usr/bin/dirname $pid_file)
 echo $base
 echo $pid_file
 echo $pid_dir
}
STR=/var/run/httpd # /#/#/*/ddd.file

## Usage
sample $STR
