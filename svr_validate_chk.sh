#!/bin/sh
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
RESET=$(tput sgr0)

# 프로세스 이름으로 PID를 가져오고 그 PID로 프로세스 이름을 다시 반환하는 함수
get_process()
{
    local value=$(ps aux | grep $1 | grep -v grep | awk '{print $2}'| head -1)
    cat /proc/$value/cmdline | grep -ao $1 |head -1 2>/dev/null
}

# 확인해야 할 프로세스를 추가
PROCESS=(
    "Pusher"
    "scc_agentd"
    "httpd"
    "sshd"
    "zabbix_agentd"
    "xinetd"
    "nginx"
    "php-fpm"
)

# 데몬 확인
DAEMON_CHK()
{
    echo "데몬 확인"
    echo "========"
    for i in ${PROCESS[@]};do
        if [[ -z $(get_process $i) ]];then
            # echo -e "$RED Not Active $RESET [$i]"
            printf "%20s %3s\n" "${RED} Not Active ${RESET}" "[$i]"

        else
            # echo -e "$GREEN Active $RESET [$i]"
            printf "%20s %3s\n" "${GREEN} Active ${RESET}" "[$i]"
        fi
    done
echo ""
}

# NIC 확인
NIC_CHK()
{
    echo "NIC 확인"
    echo "========"
    NIC=$(ip addr |grep "inet"|sed 's/^ *//')
    echo -e "$GREEN${NIC}$RESET"
echo ""
}


# NIC 목록 및 NIC 스피드 확인
NIC_SPEED_CHK()
{
    echo "NIC Speed 확인"
    echo "=============="
    NIC_LIST=$(ifconfig -a | sed 's/[ \t].*//;/^$/d' | cut -d ':' -f 1)
    for i in ${NIC_LIST};do
        SPEED=$(ethtool $i |grep 'Speed'|awk '{print $2}')
        if [[ "$SPEED" == "1000Mb/s" ]];then
            echo -e "$i $GREEN $(ethtool $i | grep Speed) $RESET"
        elif [[ "$SPEED" == "100Mb/s" ]];then
            echo -e "$i $RED $(ethtool $i | grep Speed) $RESET"
        elif [[ -z "$SPEED" ]] && [[ "$i" == "lo" ]];then
            echo "$i Loopback Interface"
        else
            echo -e "$i $RED Is this a Virtual Host Interface? Empty Speed $RESET"
            echo ""
            return
        fi
    done
echo ""
}


# NFS 확인
NFS_CHK()
{
    echo "NFS 확인"
    echo "#======="
    NFS=$(df -hT | grep -Po '^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}')
    if [[ -z "${NFS}" ]];then
        echo "No mounted as NFS"
    else
        df -hT | grep "${NFS}"
    fi
echo ""
}

clear
# 스크립트 실행
DAEMON_CHK
NIC_CHK
NIC_SPEED_CHK
NFS_CHK