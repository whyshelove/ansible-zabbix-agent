#!/bin/bash

# function:monitor nginx  from zabbix
# License: GPL
# mail: itnihao@qq.com
# version 1.0 date:2012-12-09
# version 1.0 date:2013-01-15
# version 1.1 date:2014-09-05

source /etc/bashrc >/dev/null 2>&1
source /etc/profile  >/dev/null 2>&1
nginxstatus=http://127.0.0.1/nginx-status

# Functions to return nginx stats
function checkavailable {
    code=$(curl -o /dev/null -s -w %{http_code} ${nginxstatus})
    if [ "${code}" == "200" ];then
        return 1
    else
        echo  0
    fi
}
function active {
    checkavailable|| curl -s "${nginxstatus}" | grep 'Active' | awk '{print $3}'
}
function reading {
    checkavailable|| curl -s "${nginxstatus}" | grep 'Reading' | awk '{print $2}'
}
function writing {
    checkavailable|| curl -s "${nginxstatus}" | grep 'Writing' | awk '{print $4}'
}
function waiting {
    checkavailable|| curl -s "${nginxstatus}" | grep 'Waiting' | awk '{print $6}'
}
function accepts {
    checkavailable|| curl -s "${nginxstatus}" | awk NR==3 | awk '{print $1}'
}
function handled {
    checkavailable|| curl -s "${nginxstatus}" | awk NR==3 | awk '{print $2}'
}
function requests {
    checkavailable|| curl -s "${nginxstatus}" | awk NR==3 | awk '{print $3}'
}

case "$1" in
    active)
        active
        ;;
    reading)
        reading
        ;;
    writing)
        writing
        ;;
    waiting)
        waiting
        ;;
    accepts)
        accepts
       ;;
    handled)
        handled
        ;;
    requests)
        requests
        ;;
    *)
        echo "Usage: $0 {active |reading |writing |waiting |accepts |handled |requests }"
esac
