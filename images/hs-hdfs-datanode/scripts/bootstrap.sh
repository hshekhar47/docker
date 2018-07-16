#!/bin/bash
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

source ~/.bashrc --source-only

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

log "INFO" "Starting the SSH daemon..."
sudo service ssh restart || { log "ERROR" "Could not start ssh service."; exit 1;}
log "SUCCESS" "Started SSH daemon successfully."

[ -z "${HADOOP_NAMENODE_HOSTNAME}" ] && { log "ERROR" "Environment variable HADOOP_NAMENODE_HOSTNAME is missing."; exit 1;}
sed -i "s#NAMENODE_HOSTNAME#$HADOOP_NAMENODE_HOSTNAME#g" ${HADOOP_HOME}/etc/hadoop/core-site.xml
sed -i "s#NAMENODE_HOSTNAME#$HADOOP_NAMENODE_HOSTNAME#g" ${HADOOP_HOME}/etc/hadoop/yarn-site.xml
sed -i "s#NAMENODE_HOSTNAME#$HADOOP_NAMENODE_HOSTNAME#g" ${HADOOP_HOME}/etc/hadoop/mapred-site.xml
sed -i "s#NAMENODE_HOSTNAME#$HADOOP_NAMENODE_HOSTNAME#g" ${SPARK_HOME}/conf/spark-defaults.conf
sed -i "s#NAMENODE_HOSTNAME#$HADOOP_NAMENODE_HOSTNAME#g" ${HBASE_HOME}/conf/hbase-site.xml

log "SUCCESS" "All services on Datanode started successfully."

exit $?;