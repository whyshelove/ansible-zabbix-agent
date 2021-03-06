#!/bin/bash

# function:monitor php-fpm status from zabbix
# License: GPL
# mail:admin@itnihao.com
# date:2016-01-06

source /etc/bashrc >/dev/null 2>&1
source /etc/profile  >/dev/null 2>&1

PHPFPM_FILE=/var/log/zabbix/phpfpmstatus.tmp
CMD () {
     curl http://127.0.0.1/phpfpmstatus >${PHPFPM_FILE} 2>&1
}

if [ -e ${PHPFPM_FILE} ]; then    
    TIMEFROM=`stat -c %Y ${TMP_MYSQL_STATUS}`
    TIMENOW=`date +%s`            
    if [ `expr $TIMENOW - $TIMEFROM` -gt 60 ]; then 
        rm -f ${PHPFPM_FILE} 
        CMD                       
    fi                            
else                              
    CMD                           
fi

pool(){
     awk '/pool/ {print $NF}' ${PHPFPM_FILE}
}        
process_manager() {        
     awk '/process manager/ {print $NF}' ${PHPFPM_FILE}
}  

start_since(){
    awk '/^start since:/ {print $NF}' ${PHPFPM_FILE}
}
accepted_conn(){
    awk '/^accepted conn:/ {print $NF}' ${PHPFPM_FILE}
}
listen_queue(){     
    awk '/^listen queue:/ {print $NF}' ${PHPFPM_FILE}
}
max_listen_queue(){
    awk '/^max listen queue:/ {print $NF}' ${PHPFPM_FILE}
}
listen_queue_len(){  
    awk '/^listen queue len:/ {print $NF}' ${PHPFPM_FILE}
}
idle_processes(){
    awk '/^idle processes:/ {print $NF}' ${PHPFPM_FILE}
}
active_processes(){
    awk '/^active processes:/ {print $NF}' ${PHPFPM_FILE}
}
total_processes(){
    awk '/^total processes:/ {print $NF}' ${PHPFPM_FILE}
}
max_active_processes(){
    awk '/^max active processes:/ {print $NF}' ${PHPFPM_FILE}
}
max_children_reached(){
    awk '/^max children reached:/ {print $NF}' ${PHPFPM_FILE}
}

case "$1" in
pool)
    pool
    ;;
process_manager)
    process_manager
    ;;
start_since)
    start_since
    ;;
accepted_conn)
    accepted_conn
    ;;
listen_queue)
    listen_queue
    ;;
max_listen_queue)
    max_listen_queue
    ;;
listen_queue_len)
    listen_queue_len
    ;;
idle_processes)
    idle_processes
    ;;
active_processes)
    active_processes
    ;;
total_processes)
    total_processes
    ;;
max_active_processes)
    max_active_processes
    ;;
max_children_reached)
    max_children_reached
    ;;
*)
    echo "Usage: $0 {pool|process_manager|start_since|accepted_conn| listen_queue|max_listen_queue|listen_queue_len|idle_processes|active_processes|total_processes|max_active_processes|max_children_reached}"
esac
