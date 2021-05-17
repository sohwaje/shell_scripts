#!/bin/bash
#
# Startup script for a spring boot project
#
# chkconfig: - 84 16
# description: spring boot project



JAVA_HOME="/usr/lib/jvm/java-1.8.0-openjdk"
# PROFILE=production
SERVER_NO=2
SERVER_PORT=9090
# base directory for the spring boot jar
SPRINGBOOTAPP_HOME=/data/was/memo-crawler
# export SPRINGBOOTAPP_HOME

# Source function library.
[ -f "/etc/rc.d/init.d/functions" ] && . /etc/rc.d/init.d/functions
[ -z "$JAVA_HOME" -a -x /etc/profile.d/java.sh ] && . /etc/profile.d/java.sh


# the name of the project, will also be used for the war file, log file, ...
PROJECT_NAME=memo-crawler
# the user which should run the service
SERVICE_USER=memo_crawler

# Resolve the location of the 'id' command
IDEXE="/usr/xpg4/bin/id"
if [ ! -x "$IDEXE" ]
  then
     IDEXE="/usr/bin/id"
     if [ ! -x "$IDEXE" ]
       then
            echo "Unable to locate 'id'."
            echo "Please report this message along with the location of the command on your system."
            exit 1
        fi
    fi

    # Check the configured user.  If necessary rerun this script as the desired user.
 if [ "X$RUN_AS_USER" != "X" ]
    then
        if [ "`$IDEXE -u -n`" != "$RUN_AS_USER" ]
        then
            # If LOCKPROP and $RUN_AS_USER are defined then the new user will most likely not be
            # able to create the lock file.  The Wrapper will be able to update this file once it
            # is created but will not be able to delete it on shutdown.  If $2 is defined then
            # the lock file should be created for the current command
            if [ "X$LOCKPROP" != "X" ]
            then
                if [ "X$1" != "X" ]
                then
                    # Resolve the primary group 
                    RUN_AS_GROUP=`groups $RUN_AS_USER | awk '{print $3}' | tail -1`
                    if [ "X$RUN_AS_GROUP" = "X" ]
                    then
                        RUN_AS_GROUP=$RUN_AS_USER
                    fi
                    touch $LOCKFILE
                    chown $RUN_AS_USER:$RUN_AS_GROUP $LOCKFILE
                fi
            fi
    
            # Still want to change users, recurse.  This means that the user will only be
            #  prompted for a password once. Variables shifted by 1
            su - $RUN_AS_USER -c "\"$REALPATH\" $2"
    
            # Now that we are the original user again, we may need to clean up the lock file.
            if [ "X$LOCKPROP" != "X" ]
            then
                getpid
                if [ "X$pid" = "X" ]
                then
                    # Wrapper is not running so make sure the lock file is deleted.
                    if [ -f "$LOCKFILE" ]
                    then
                        rm "$LOCKFILE"
                    fi
                fi
            fi
    
            exit 0
        fi
 fi
 
 # Check that script is not run as root
LUID=`$IDEXE -u`
if [ $LUID -eq 0 ]
    then
        echo "****************************************"
        echo "WARNING - NOT RECOMMENDED TO RUN AS ROOT"
        echo "****************************************"
        if [ ! "`$IDEXE -u -n`" = "$RUN_AS_USER" ]
        then
            echo "If you insist running as root, then set the environment variable RUN_AS_USER=root before running this script."
            exit 1
        fi
fi
 

# JAVA_OPTS="-server -Dspring.profiles.active=production -Dspring.config.location=./config/application.properties -Dlogging.config=config/logback.xml"
# JAVA_OPTS="-server -Dspring.profiles.active=$PROFILE -Dserver.no=$SERVER_NO -Dserver.port=$SERVER_PORT"
JAVA_OPTS="-server -Dserver.no=$SERVER_NO -Dserver.port=$SERVER_PORT"
JAVA_OPTS="$JAVA_OPTS -Djava.net.preferIPv4Stack=true"
JAVA_OPTS="$JAVA_OPTS -Xms6114m -Xmx6114m -XX:MaxGCPauseMillis=100  -XX:+ParallelRefProcEnabled -XX:-ResizePLAB -XX:ParallelGCThreads=16 -XX:+DisableExplicitGC -verbose:gc -XX:+PrintGCTimeStamps -XX:+PrintGCDetails"
JAVA_OPTS="$JAVA_OPTS -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=$SPRINGBOOTAPP_HOME/dump/heapdump.log"

# the spring boot war-file
SPRINGBOOTAPP_WAR="$SPRINGBOOTAPP_HOME/$PROJECT_NAME.war"

# java executable for spring boot app, change if you have multiple jdks installed
SPRINGBOOTAPP_JAVA=$JAVA_HOME/bin/java

# spring boot log-file
LOG="$SPRINGBOOTAPP_HOME/logs/$PROJECT_NAME.log"
LOCK="$SPRINGBOOTAPP_HOME/lock/$PROJECT_NAME"

RETVAL=0

pid_of_spring_boot() {
        pgrep -f "java.*$SPRINGBOOTAPP_HOME/$PROJECT_NAME.war"
}

start() {
    [ -e "$LOG" ] && cnt=`wc -l "$LOG" | awk '{ print $1 }'` || cnt=1

    echo -n $"Starting $PROJECT_NAME "

    cd "$SPRINGBOOTAPP_HOME"
    nohup $SPRINGBOOTAPP_JAVA -jar $JAVA_OPTS "$SPRINGBOOTAPP_WAR"  >> "$LOG" 2>&1 &

    while { pid_of_spring_boot > /dev/null ; } &&
        ! { tail --lines=+$cnt "$LOG" | grep -q ' started\s*on' ; } ; do
        sleep 1
        printf "."
    done

    pid_of_spring_boot > /dev/null
    RETVAL=$?
    [ $RETVAL = 0 ] && success $"$STRING" || failure $"$STRING"
    echo

    [ $RETVAL = 0 ] && touch "$LOCK"
}

stop() {
    echo -n "Stopping $PROJECT_NAME "

    pid=`pid_of_spring_boot`
    [ -n "$pid" ] && kill $pid
    RETVAL=$?
    cnt=10
    while [ $RETVAL = 0 -a $cnt -gt 0 ] &&
        { pid_of_spring_boot > /dev/null ; } ; do
            sleep 1
            ((cnt--))
    done

    [ $RETVAL = 0 ] && rm -f "$LOCK"
    [ $RETVAL = 0 ] && success $"$STRING" || failure $"$STRING"
    echo
}

status() {
    pid=`pid_of_spring_boot`
    if [ -n "$pid" ]; then
        echo "$PROJECT_NAME (pid $pid) is running..."
        return 0
    fi
    if [ -f "$LOCK" ]; then
        echo $"${base} dead but subsys locked"
        return 2
    fi
    echo "$PROJECT_NAME is stopped"
    return 3
}

# See how we were called.
case "$1" in
    start)
        start
        ;;
    stop)
        stop
        ;;
    status)
        status
        ;;
    restart)
        stop
        start
        ;;
    *)
        echo $"Usage: $0 {start|stop|restart|status}"
        exit 1
esac

exit $RETVAL