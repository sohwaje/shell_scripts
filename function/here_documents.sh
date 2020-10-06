#!/bin/bash
str="Dumy"

cat << 'EOT'
여기서 $str은 변수 확장되지 않으며 `echo abc`도 명령어 치환되지 않는다.
EOT

cat << EOT
여기서 $str은 변수로 치환되며, `echo abc`도 명령어로 치환된다.
EOT

cat <<< "예제:
이것은 예제입니다.
$str
hello"
