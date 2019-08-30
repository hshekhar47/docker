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

figlet "HDFS Namenode"

log "INFO" "Starting the SSH daemon..."
sudo service ssh restart || { log "ERROR" "Could not start ssh service."; exit 1;}
log "SUCCESS" "Started SSH daemon successfully."

export HOSTNAME=`hostname`
sed -i "s#NAMENODE_HOSTNAME#$HOSTNAME#g" ${HADOOP_HOME}/etc/hadoop/core-site.xml
sed -i "s#NAMENODE_HOSTNAME#$HOSTNAME#g" ${HADOOP_HOME}/etc/hadoop/yarn-site.xml
sed -i "s#NAMENODE_HOSTNAME#0.0.0.0#g"   ${HADOOP_HOME}/etc/hadoop/mapred-site.xml
sed -i "s#NAMENODE_HOSTNAME#$HOSTNAME#g" ${SPARK_HOME}/conf/spark-defaults.conf
sed -i "s#NAMENODE_HOSTNAME#$HOSTNAME#g" ${HBASE_HOME}/conf/hbase-site.xml

log "INFO" "Formatting NameNode data directory..."
${HADOOP_HOME}/bin/hdfs namenode -format -force || { log "ERROR" "Could not format namenode data directory."; exit 1;}
log "SUCCESS" "Formatted NameNode data directory successfully."

[ -z "${HADOOP_DATANODES}" ] && { log "ERROR" "Environment variable HS_DATANODES is missing.";}
echo "" > ${HADOOP_HOME}/etc/hadoop/slaves
echo "" > ${SPARK_HOME}/conf/slaves
echo "" > ${HBASE_HOME}/conf/regionservers

log "INFO" "Finding datanodes in network"
for nodename in ${HADOOP_DATANODES} 
do
    log_as_colored_text "CYAN" "\t${nodename}: Searching "; echo -n "";
    if check_node_alive ${nodename}; then
        log_as_colored_text "GREEN" "FOUND"
        echo "${nodename}" >> ${HADOOP_HOME}/etc/hadoop/slaves
        echo "${nodename}" >> ${SPARK_HOME}/conf/slaves
        echo "${nodename}" >> ${HBASE_HOME}/conf/regionservers
    else
        log_as_colored_text "RED" "NOT FOUND"
    fi  
    echo ""
done 
echo ""


log "INFO" "Starting HDFS"
${HADOOP_HOME}/sbin/start-dfs.sh || { log "ERROR" "Could not start HDFS."; exit 1;}
log "SUCCESS" "HDFS Started successfully."

log "INFO" "Creating filesystems"
${HADOOP_HOME}/bin/hdfs dfs -mkdir -p /tmp
${HADOOP_HOME}/bin/hdfs dfs -chmod -R 1777 /tmp
if [ $? -eq 0 ];then log "SUCCESS" "Created hdfs://tmp"; fi;

${HADOOP_HOME}/bin/hdfs dfs -mkdir -p /var/log/yarn/apps
${HADOOP_HOME}/bin/hdfs dfs -chmod -R 1777 /var/log/yarn
if [ $? -eq 0 ];then log "SUCCESS" "Created hdfs://var/log/yarn"; fi;

${HADOOP_HOME}/bin/hdfs dfs -mkdir -p /mr-history/temp
${HADOOP_HOME}/bin/hdfs dfs -mkdir -p /mr-history/done
${HADOOP_HOME}/bin/hdfs dfs -chmod -R 1777 /mr-history/
if [ $? -eq 0 ];then log "SUCCESS" "Created hdfs://mr-history"; fi;

${HADOOP_HOME}/bin/hdfs dfs -mkdir -p /spark-logs
${HADOOP_HOME}/bin/hdfs dfs -chmod -R 1777 /spark-logs
if [ $? -eq 0 ];then log "SUCCESS" "Created hdfs://spark-logs"; fi;

${HADOOP_HOME}/bin/hdfs dfs -mkdir -p /user/deployer 
if [ $? -eq 0 ]; then log "SUCCESS" "Created hdfs://user/deployer"; fi; 

log "INFO" "Starting YARN"
${HADOOP_HOME}/sbin/start-yarn.sh || { log "ERROR" "Could not start YARN."; exit 1;}
log "SUCCESS" "YARN started successfully."

log "INFO" "Starting Map Reduce Job-History server"
sed -i "s#USER#UNAME#g" ${HADOOP_HOME}/sbin/mr-jobhistory-daemon.sh
${HADOOP_HOME}/sbin/mr-jobhistory-daemon.sh start historyserver || { log "ERROR" "Could not start Job-History server."; exit 1;}
log "SUCCESS" "Job-History server started successfully."

#log "INFO" "Starting Spark"
#$SPARK_HOME/sbin/start-all.sh
#log "SUCCESS" "Spark started successfully."

#log "INFO" "Starting hbase"
#$HBASE_HOME/bin/start-hbase.sh || { log "ERROR" "Could not start Job-History server.";}
#log "SUCCESS" "HBASE started successfully"

log "SUCCESS" "All services on NameNode ${HOSTNAME} started successfully."
${HADOOP_HOME}/bin/hdfs dfsadmin -report

exit $?;
