#!/bin/bash
function wait_until_shutdown_complete() {

  check=$(netstat -tnl | grep ${tomcat_port} | wc -l)
  if [ "${check}" == "0"  ]; then
    echo "톰캣 서버 정지 상태"
  else
    while [ "${check}" != "1" ]; do
      check=$(netstat -tnl | grep ${tomcat_port} | wc -l)

      echo "톰캣 서버 정지 중..."

      sleep 5s
    done

    echo "톰캣 서버 정지"
  fi
}
