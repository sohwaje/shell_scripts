#!/bin/sh
#[1] TOMCAT V7에 최적화
DATE=`date +%Y%m%d%H%M%S`

#[2] TOMCAT Port & values
export JAVA_OPTS="$JAVA_OPTS -Dtomcat.port.shutdown=8005"
export JAVA_OPTS="$JAVA_OPTS -Dtomcat.port.http=8080"
export JAVA_OPTS="$JAVA_OPTS -Dtomcat.port.https=8443"
export JAVA_OPTS="$JAVA_OPTS -Dtomcat.port.ajp=8009"
export JAVA_OPTS="$JAVA_OPTS -DmaxThreads=300"
export JAVA_OPTS="$JAVA_OPTS -DminSpareThreads=50"
export JAVA_OPTS="$JAVA_OPTS -DacceptCount=10"
export JAVA_OPTS="$JAVA_OPTS -DmaxKeepAliveRequests=-1"
export JAVA_OPTS="$JAVA_OPTS -DconnectionTimeout=30000"
#export JAVA_OPTS="$JAVA_OPTS -Djava.net.preferIPv4Stack=true"
#export JAVA_OPTS="$JAVA_OPTS -Djava.net.preferIPv4Addresses=true"

#[3] JMX monitoring
#export JAVA_OPTS="$JAVA_OPTS -Djava.rmi.server.hostname=$IPADDRESS" #Service IP Address
#export JAVA_OPTS="$JAVA_OPTS -Dcom.sun.management.jmxremote=true"
#export JAVA_OPTS="$JAVA_OPTS -Dcom.sun.management.jmxremote.port=18888"
#export JAVA_OPTS="$JAVA_OPTS -Dcom.sun.management.jmxremote.rmi.port=18888"
#export JAVA_OPTS="$JAVA_OPTS -Dcom.sun.management.jmxremote.ssl=false"
#export JAVA_OPTS="$JAVA_OPTS -Dcom.sun.management.jmxremote.authenticate=true"
#export JAVA_OPTS="$JAVA_OPTS -Dcom.sun.management.jmxremote.access.file=$CATALINA_BASE/conf/jmxremote.access"
#export JAVA_OPTS="$JAVA_OPTS -Dcom.sun.management.jmxremote.password.file=$CATALINA_BASE/conf/jmxremote.password"


#[4] Directory Setup #####
export SERVER_NAME=icms
export JAVA_OPTS="$JAVA_OPTS -Dserver=eletter"
export CATALINA_HOME="/home/sigongweb/tomcat7"
export CATALINA_BASE="/home/sigongweb/tomcat7"
export JAVA_HOME="/home/sigongweb/jdk1.7.0_79"
export LOG_HOME=$CATALINA_BASE/logs
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$CATALINA_HOME/lib
#export SCOUTER_AGENT_DIR="/home/sigongweb/scouter/agent.java"

#[5] JVM Options : Memory
export JAVA_OPTS="$JAVA_OPTS -Xms2048m"
export JAVA_OPTS="$JAVA_OPTS -Xmx2048m"
export JAVA_OPTS="$JAVA_OPTS -XX:NewSize=256m"
export JAVA_OPTS="$JAVA_OPTS -Xss512k"

#[6] Parallel GC OPTIONS ###
export JAVA_OPTS="$JAVA_OPTS -XX:+UseParallelOldGC "

#[7] JVM Option GCi log, Stack Trace, Dump
export JAVA_OPTS="$JAVA_OPTS -verbose:gc"
export JAVA_OPTS="$JAVA_OPTS -XX:+PrintGCTimeStamps"
export JAVA_OPTS="$JAVA_OPTS -XX:+PrintGCDetails "
export JAVA_OPTS="$JAVA_OPTS -Xloggc:$LOG_HOME/gclog/gc_$DATE.log"
export JAVA_OPTS="$JAVA_OPTS -XX:+HeapDumpOnOutOfMemoryError"
export JAVA_OPTS="$JAVA_OPTS -XX:HeapDumpPath=$LOG_HOME/gclog/java_pid.hprof"
export JAVA_OPTS="$JAVA_OPTS -XX:+DisableExplicitGC"
export CATALINA_OPTS="$CATALINA_OPTS -Djava.security.egd=file:/dev/./urandom"

#[8] Scouter
#export JAVA_OPTS="$JAVA_OPTS -javaagent:${SCOUTER_AGENT_DIR}/scouter.agent.jar"
#export JAVA_OPTS="$JAVA_OPTS -Dscouter.config=${SCOUTER_AGENT_DIR}/conf/messenger_ws.conf"
#export JAVA_OPTS="$JAVA_OPTS -Dobj_name=sigongweb"
