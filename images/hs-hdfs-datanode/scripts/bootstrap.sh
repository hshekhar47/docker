#!/bin/bash
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color


log_as_colored_text() {
    case "$1" in
        "RED")
            printf "${RED}$2 ${NC}";;
        "GREEN")
            printf "${GREEN}$2 ${NC}";;
        *)
            printf "${CYAN}$2 ${NC}";;
    esac
}

log() {
    timestamp=`date '+%Y-%m-%d %H:%M:%S'`
    case "$1" in
        "SUCCESS")
            log_as_colored_text "GREEN" "${timestamp} [INFO ] $2";;
        "ERROR")
            log_as_colored_text "RED" "${timestamp} [ERROR ] $2";;
        "INFO")
            log_as_colored_text "CYAN" "${timestamp} [INFO ] $2";;
        *)
            log_as_colored_text "CYAN" "${timestamp} [INFO ] $2";;
    esac
    echo ""
}

figlet "HDFS Datanode"

echo $PATH | grep -q "${HADOOP_HOME}"
if [ $? -ne 0 ]; then
    PATH=${PATH}:${HADOOP_HOME}/bin
    export PATH
fi

echo $PATH | grep -q "${SPARK_HOME}"
if [ $? -ne 0 ]; then
    PATH=${PATH}:${SPARK_HOME}/bin
    export PATH
fi

echo "export PATH=${PATH}" >> ~/.bashrc

log "INFO" "Starting the SSH daemon..."
sudo service ssh restart || { log "ERROR" "Could not start ssh service."; exit 1;}
log "SUCCESS" "Started SSH daemon successfully."

[ -z "${HADOOP_NAMENODE_HOSTNAME}" ] && { log "ERROR" "Environment variable HADOOP_NAMENODE_HOSTNAME is missing."; exit 1;}
sed -i "s#localhost#$HADOOP_NAMENODE_HOSTNAME#g" ${HADOOP_HOME}/etc/hadoop/core-site.xml
sed -i "s#localhost#$HADOOP_NAMENODE_HOSTNAME#g" ${HADOOP_HOME}/etc/hadoop/yarn-site.xml

log "SUCCESS" "All services on Datanode started successfully."

exit $?;