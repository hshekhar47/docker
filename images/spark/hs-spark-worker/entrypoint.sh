#!/bin/bash
error_and_exit() {
    echo "ERROR: ${1}"
    exit 1
}

. "${SPARK_HOME}/sbin/spark-config.sh"
. "${SPARK_HOME}/bin/load-spark-env.sh"

[[ -z "$SPARK_MASTER" ]] && error_and_exit "env SPARK_MASTER missing"

${SPARK_HOME}/bin/spark-class org.apache.spark.deploy.worker.Worker --webui-port ${SPARK_WORKER_WEBUI_PORT} ${SPARK_MASTER} >> /var/log/spark/spark-worker.out
