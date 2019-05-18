#!/bin/bash
#사용법 : ./locate FILE_NAME or DIR_NAME
#TIP 정규표현식을 사용하여 찾으려는 대상을 좀 더 정확하게 출력할 수 있다. 아래 간단한 예제를 보자.
#loate find$
#locatedb에서 패턴의 마지막을 의미하는 "$" 메타문자를 이용할 수 있다. 이렇게 하면 마지막이 언제나 find로 끝나는 경로가 출력된다.
locatedb ="/var/locate.db"

#[2] 구축된 locatedb에서
exec grep -i "$@" $locatedb
