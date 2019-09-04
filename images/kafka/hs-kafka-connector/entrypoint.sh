#!/bin/bash


error_and_exit() {
    echo "ERROR: ${1}"
    exit 1
}

[[ -z "$GROUP_ID" ]] && error_and_exit "env GROUP_ID missing"
[[ -z "$KAFKA_BROKERS" ]] && error_and_exit "env KAFKA_BROKERS missing"
[[ -z "$CONFIG_STORAGE_TOPIC" ]] && error_and_exit "env CONFIG_STORAGE_TOPIC missing"
[[ -z "$OFFSET_STORAGE_TOPIC" ]] && error_and_exit "env OFFSET_STORAGE_TOPIC missing"
[[ -z "$STATUS_STORAGE_TOPIC" ]] && error_and_exit "env STATUS_STORAGE_TOPIC missing"


BROKER_COUNT=1

if [[ "${KAFKA_BROKERS}" == *",*" ]]; then
    COUNT=$(echo $KAFKA_BROKERS| grep -o "," | wc -c)

    if [[ $COUNT > 1 ]]; then
       BROKER_COUNT=2 
    fi
fi


HOSTNAME=`hostname`

#Default Properties
echo "" >> $KAFKA_HOME/config/connect-distributed.properties
echo "rest.host.name=${HOSTNAME}" >> $KAFKA_HOME/config/connect-distributed.properties
echo "rest.port=8083" >> $KAFKA_HOME/config/connect-distributed.properties
# echo "rest.advertised.host.name=localhost" >> $KAFKA_HOME/config/connect-distributed.properties
# echo "rest.advertised.port=8083" >> $KAFKA_HOME/config/connect-distributed.properties
echo "offset.storage.replication.factor=1" >> $KAFKA_HOME/config/connect-distributed.properties
echo "config.storage.replication.factor=1" >> $KAFKA_HOME/config/connect-distributed.properties
echo "status.storage.replication.factor=1" >> $KAFKA_HOME/config/connect-distributed.properties
echo "offset.storage.partitions=${BROKER_COUNT}" >> $KAFKA_HOME/config/connect-distributed.properties
echo "config.storage.partitions=${BROKER_COUNT}" >> $KAFKA_HOME/config/connect-distributed.properties
echo "status.storage.partitions=${BROKER_COUNT}" >> $KAFKA_HOME/config/connect-distributed.properties
echo "key.converter.schemas.enable=true" >> $KAFKA_HOME/config/connect-distributed.properties
echo "value.converter.schemas.enable=true" >> $KAFKA_HOME/config/connect-distributed.properties
# echo "internal.key.converter=org.apache.kafka.connect.json.JsonConverter" >> $KAFKA_HOME/config/connect-distributed.properties
# echo "internal.value.converter=org.apache.kafka.connect.json.JsonConverter" >> $KAFKA_HOME/config/connect-distributed.properties 

#Custom Properties
echo "group.id=${GROUP_ID}" >> $KAFKA_HOME/config/connect-distributed.properties
echo "bootstrap.servers=${KAFKA_BROKERS}" >> $KAFKA_HOME/config/connect-distributed.properties
echo "offset.storage.topic=${OFFSET_STORAGE_TOPIC}" >> $KAFKA_HOME/config/connect-distributed.properties
echo "config.storage.topic=${CONFIG_STORAGE_TOPIC}" >> $KAFKA_HOME/config/connect-distributed.properties
echo "status.storage.topic=${STATUS_STORAGE_TOPIC}" >> $KAFKA_HOME/config/connect-distributed.properties
echo "plugin.path=${KAFKA_CONNECT_PLUGINS_DIR}" >> $KAFKA_HOME/config/connect-distributed.properties
echo "key.converter=org.apache.kafka.connect.json.JsonConverter" >> $KAFKA_HOME/config/connect-distributed.properties
echo "value.converter=org.apache.kafka.connect.json.JsonConverter" >> $KAFKA_HOME/config/connect-distributed.properties

echo "Staring connect distributed....."
exec $KAFKA_HOME/bin/connect-distributed.sh $KAFKA_HOME/config/connect-distributed.properties

exit $?