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

check_node_alive() {
    attempts=0
    while [ $attempts -lt 5 ]; do
        ping -c 1 "$1" > /dev/null 2>&1
        if [ $? -eq 0 ]; then
            return 0
        else
            ((attempts++))
            #log "ERROR" "No hostname $1 found. Searched ${attempts} time(s)."
            sleep 5
        fi
    done
    return 3;
}


figlet "HDFS Edgenode"

log "INFO" "Starting the SSH daemon..."
sudo service ssh restart || { log "ERROR" "Could not start ssh service."; exit 1;}
log "SUCCESS" "Started SSH daemon successfully."

[ -z "${HADOOP_NAMENODE_HOSTNAME}" ] && { log "ERROR" "Environment variable HADOOP_NAMENODE_HOSTNAME is missing."; exit 1;}
sed -i "s#NAMENODE_HOSTNAME#$HADOOP_NAMENODE_HOSTNAME#g" ${HADOOP_HOME}/etc/hadoop/core-site.xml
sed -i "s#NAMENODE_HOSTNAME#$HADOOP_NAMENODE_HOSTNAME#g" ${HADOOP_HOME}/etc/hadoop/yarn-site.xml
sed -i "s#NAMENODE_HOSTNAME#$HADOOP_NAMENODE_HOSTNAME#g" ${HADOOP_HOME}/etc/hadoop/mapred-site.xml
sed -i "s#NAMENODE_HOSTNAME#$HADOOP_NAMENODE_HOSTNAME#g" ${HIVE_HOME}/conf/hive-site-derby.xml 
sed -i "s#NAMENODE_HOSTNAME#$HADOOP_NAMENODE_HOSTNAME#g" ${HIVE_HOME}/conf/hive-site-mysql.xml 

export HOSTNAME=`hostname`
sed -i "s#localhost#$HOSTNAME#g" ${HIVE_HOME}/conf/hive-site-derby.xml 
sed -i "s#localhost#$HOSTNAME#g" ${HIVE_HOME}/conf/hive-site-mysql.xml 

if [ "${HIVE_SCHEMA_TYPE:-'derby'}" == "mysql" ];then
    [ -z "HIVE_MYSQL_HOSTNAME" ] && { log "ERROR" "Missing environment HIVE_MYSQL_HOSTNAME"; exit 1;}
    [ -z "HIVE_MYSQL_USER" ] && { log "ERROR" "Missing environment HIVE_MYSQL_USER"; exit 1;}
    [ -z "HIVE_MYSQL_PASSWORD" ] && { log "ERROR" "Missing environment HIVE_MYSQL_PASSWORD"; exit 1;}
    
    sed -i "s#HIVE_MYSQL_HOSTNAME#${HIVE_MYSQL_HOSTNAME}#g" ${HIVE_HOME}/conf/hive-site-mysql.xml 
    sed -i "s#HIVE_MYSQL_USER#${HIVE_MYSQL_USER}#g" ${HIVE_HOME}/conf/hive-site-mysql.xml 
    sed -i "s#HIVE_MYSQL_PASSWORD#${HIVE_MYSQL_PASSWORD}#g" ${HIVE_HOME}/conf/hive-site-mysql.xml 
fi
	
schema_type=${HIVE_SCHEMA_TYPE:-"derby"}	
case "${schema_type}" in
    "derby")
        mv ${HIVE_HOME}/conf/hive-site-derby.xml ${HADOOP_HOME}/etc/hadoop/hive-site.xml
        ;;
    "mysql")
        mv ${HIVE_HOME}/conf/hive-site-mysql.xml ${HADOOP_HOME}/etc/hadoop/hive-site.xml
        ;;
esac

ln -s ${HADOOP_HOME}/etc/hadoop/hive-site.xml ${HIVE_HOME}/conf/hive-site.xml
log "SUCCESS" "${HIVE_HOME}/conf/hive-site.xml is created."


log "INFO" "Adding hive Jar"
ln -s ${HIVE_HOME}/lib/hive-exec*jar ${SQOOP_HOME}/lib/hive-exec.jar || { log "ERROR" "Could not add ${HIVE_HOME}/lib/hive-exec*jar to SQOOP library"; }

sleep ${NAMENODE_TIMEOUT:-60}
#until hdfs dfs -test -e /user/deployer > /dev/null 2>&1; do echo -n '.'; sleep 1; done;

log "INFO" "Creating filesystems"
${HADOOP_HOME}/bin/hdfs dfs -mkdir -p /tmp/hive
${HADOOP_HOME}/bin/hdfs dfs -chmod -R 777 /tmp
if [ $? -eq 0 ];then log "SUCCESS" "Created /tmp"; fi;

${HADOOP_HOME}/bin/hdfs dfs -mkdir -p /user/hive/warehouse
${HADOOP_HOME}/bin/hdfs dfs -chmod -R 777 /user/hive/warehouse
if [ $? -eq 0 ]; then log "SUCCESS" "Created /user/hive/warehouse"; fi;


mkdir -p ${HIVE_HOME}/hive_work
cd ${HIVE_HOME}/hive_work
${HIVE_HOME}/bin/schematool -dbType ${schema_type} -userName ${HIVE_MYSQL_USER} -passWord ${HIVE_MYSQL_PASSWORD} -initSchema
cd -
${HIVE_HOME}/bin/hive --service metastore &
if [ $? -eq 0 ];then 
    log "SUCCESS" "Schema with type ${schema_type} is created."
fi


cd ${HIVE_HOME}
log "INFO" "Starting HiveServer"
${HIVE_HOME}/bin/hive --service hiveserver2 & 
cd -
log "SUCCESS" "HiveServer Started successfully."

log "INFO" "+------------------------------------------------------+"
log "INFO" "| beeline -u jdbc:hive2://hdfs-namenode:10000          |"
log "INFO" "+------------------------------------------------------+"

log "SUCCESS" "All services on NameNode ${HOSTNAME} started successfully."


exit $?;
