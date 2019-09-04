#!/bin/bash

log_error() {
    echo "WARN ${1}"
}

log_error_and_exit() {
    log_error "$1"
    exit 1;
}

[[ -z "$KAFKA_BROKER_ID" ]] && log_error_and_exit "env KAFKA_BROKER_ID is missing"
[[ -z "$ZOOKEEPER_HOSTNAME" ]] && log_error_and_exit "env ZOOKEEPER_HOSTNAME is missing"
[[ -z "$KAFKA_ADVERT_LISTENER_HOST" ]] && log_error "env KAFKA_ADVERT_LISTANERS is missing, Required for external client connectivity <KAFKA_ADVERT_LISTENER_HOST>:<KAFKA_ADVERT_LISTENER_PORT>."
[[ -z "$KAFKA_ADVERT_LISTENER_PORT" ]] && log_error "env KAFKA_ADVERT_LISTANERS is missing, Required for external client connectivity <KAFKA_ADVERT_LISTENER_HOST>:<KAFKA_ADVERT_LISTENER_PORT>."

HOSTNAME=`hostname`

#Basic config
echo "" > $KAFKA_HOME/config/server.properties
echo "num.network.threads=3" >> $KAFKA_HOME/config/server.properties
echo "num.io.threads=8" >> $KAFKA_HOME/config/server.properties
echo "socket.send.buffer.bytes=102400" >> $KAFKA_HOME/config/server.properties
echo "socket.receive.buffer.bytes=102400" >> $KAFKA_HOME/config/server.properties
echo "socket.request.max.bytes=104857600" >> $KAFKA_HOME/config/server.properties
echo "num.recovery.threads.per.data.dir=1" >> $KAFKA_HOME/config/server.properties
echo "offsets.topic.replication.factor=1" >> $KAFKA_HOME/config/server.properties
echo "offsets.topic.num.partitions=5" >> $KAFKA_HOME/config/server.properties
echo "transaction.state.log.replication.factor=1" >> $KAFKA_HOME/config/server.properties
echo "transaction.state.log.min.isr=1" >> $KAFKA_HOME/config/server.properties
echo "log.retention.hours=168" >> $KAFKA_HOME/config/server.properties
echo "log.segment.bytes=1073741824" >> $KAFKA_HOME/config/server.properties
echo "log.retention.check.interval.ms=300000" >> $KAFKA_HOME/config/server.properties
echo "zookeeper.connection.timeout.ms=6000" >>  $KAFKA_HOME/config/server.properties
echo "group.initial.rebalance.delay.ms=0" >> $KAFKA_HOME/config/server.properties
echo "log.dirs=/var/log/kafka" >> $KAFKA_HOME/config/server.properties

#Custom Config
echo "broker.id=${KAFKA_BROKER_ID}" >> $KAFKA_HOME/config/server.properties
echo "zookeeper.connect=${ZOOKEEPER_HOSTNAME}:2181" >>  $KAFKA_HOME/config/server.properties

if [[ ! -z "${KAFKA_ADVERT_LISTENER_HOST}" && ! -z "${KAFKA_ADVERT_LISTENER_PORT}" ]]; then
    echo "listeners=LISTENER_INTERNAL://${HOSTNAME}:29092,LISTENER_EXTERNAL://${HOSTNAME}:${KAFKA_ADVERT_LISTENER_PORT}" >> $KAFKA_HOME/config/server.properties
    echo "advertised.listeners=LISTENER_INTERNAL://${HOSTNAME}:29092,LISTENER_EXTERNAL://${KAFKA_ADVERT_LISTENER_HOST}:${KAFKA_ADVERT_LISTENER_PORT}" >> $KAFKA_HOME/config/server.properties
    echo "listener.security.protocol.map=LISTENER_INTERNAL:PLAINTEXT,LISTENER_EXTERNAL:PLAINTEXT" >> $KAFKA_HOME/config/server.properties
    echo "inter.broker.listener.name=LISTENER_INTERNAL" >> $KAFKA_HOME/config/server.properties
else
    echo "listeners=PLAINTEXT://${HOSTNAME}:9092" >> $KAFKA_HOME/config/server.properties
fi


if [[ ! -z "$KAFKA_TOPICS" ]]; then
    BROKER_PORT=9092
    if [ ! -z "$KAFKA_ADVERT_LISTENER_HOST" ];then 
        BROKER_PORT=29092
    fi 
    echo "Will be creating topics once broker ready"
    (
        #while ss -n | awk '$5 ~ /:"${BROKER_PORT}"$/ {exit 1}'; do sleep 1; done
        while ss -n | awk '{print $5}' | cut -d':' -f 2 | awk '$1 == 29092 {exit 1}';  do sleep 1; done
        echo "Found running Kafka broker on port ${BROKER_PORT}, so creating topics ..."
        IFS=','; for topic in $KAFKA_TOPICS; do
            echo "${topic}"
            IFS=':'; read -a topic_cfg <<< "${topic}"
            echo "Creating ${topic_cfg[0]} with replication-factor=${topic_cfg[1]} and partitions=${topic_cfg[2]}"
            $KAFKA_HOME/bin/kafka-topics.sh --create --bootstrap-server ${HOSTNAME}:${BROKER_PORT} --replication-factor "${topic_cfg[1]}" --partitions "${topic_cfg[2]}" --topic "${topic_cfg[0]}"
        done
    )&
fi
exec $KAFKA_HOME/bin/kafka-server-start.sh $KAFKA_HOME/config/server.properties

exec "$?"