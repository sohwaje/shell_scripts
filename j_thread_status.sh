#!/bin/bash
echo -e "INPUT PID: \c "
read PID  #JAVA INSTANCE PID

# PID의 스레드가 Sleep이 아닌 스레드를 화면에 출력
# LWP(Light Weight Process, is thread) : 스레드 고유아이디
# NLWP(Number Light Weight Process) : 해당 프로세스에서 동작하는 스레드의 총 갯수
start=0
while [ $start -ne 1 ]
do
  echo "RUNNING THREAD:"
        THREAD_RUNNING=`ps -Lf $PID | awk '{print $1" "$4" "$6" "$9" "$10" "$12}'|grep -v "UID LWP NLWP STAT TIME"|grep -v 'Sl'`
  echo "$THREAD_RUNNING"
        RUNNING_THREAD_COUNT=`ps -Lf $PID | awk '{print $1" "$4" "$6" "$9" "$10" "$12}'|grep -v "UID LWP NLWP STAT TIME"|grep -v 'Sl' |wc -l`
  sleep 0.5
if [ $RUNNING_THREAD_COUNT -eq 0 ]  # running thread가 0이면 루프 종료
then
  echo "not running thread..."
  break
fi
done
