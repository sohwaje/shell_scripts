#!/bin/bash
planets=("Mercury 36" "Venus 67" "Earth 93" "Mars 142" "Jupiter 483")
for planet in "${planets[@]}"
do
  set -- $planet  # "planet" 변수를 파싱해서 위치 매개변수로 세팅.
  # "--" 를 쓰면 $planet 이 널이거나 대쉬 문자로 시작하는 등의 까다로운 상황을 처리해 줍니다.

  # 원래의 위치 매개변수는 덮어써지기 때문에 다른 곳에 저장해 놓아야 할지도 모릅니다.
  # 배열을 써서 해 볼 수 있겠네요.
  #        original_params=("$@")

  echo "$1     해까지 거리 $2,000,000 마일"
done
exit 0
