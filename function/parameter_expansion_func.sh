sample()
{
 local base=${1##*/}
 local pid_file=${2:-/var/run/$base.pid}
 local pid_dir=$(/usr/bin/dirname $pid_file)
 echo $base
 echo $pid_file
 echo $pid_dir
}
STR=/var/run/httpd # /#/#/*/ddd.file

## Usage
sample $STR
