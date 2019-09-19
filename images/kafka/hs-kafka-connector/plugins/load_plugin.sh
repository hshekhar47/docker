#!/bin/bash

PLUGIN_NAME=""

function download_elasticsearch_plugins() {
    plugin_download.sh confluent kafka-connect-elasticsearch "${CONFLUENT_VERSION}" \
        && plugin_download.sh central io/searchbox jest 2.0.0 \
        && plugin_download.sh central io/searchbox jest-common 2.0.0 \
        && plugin_download.sh central org/apache/httpcomponents httpcore-nio 4.4.4 \
        && plugin_download.sh central org/apache/httpcomponents httpcore 4.4.4 \
        && plugin_download.sh central org/apache/httpcomponents httpclient 4.5.2 \
        && plugin_download.sh central org/apache/httpcomponents httpasyncclient 4.1.1 \
        && plugin_download.sh central commons-codec commons-codec 1.9 \
        && plugin_download.sh central commons-logging commons-logging 1.2 \
        && plugin_download.sh central com/google/code/gson gson 2.6.2 
}

function download_oracle_plugin() {
    plugin_download.sh debezium oracle "$DEBEZIUM_VERSION" \
        && plugin_download central com/oracle/jdbc ojdbc8 12.2.0.1
}

function download_mysql_plugin() {
    plugin_download.sh debezium mysql "$DEBEZIUM_VERSION" \
        && plugin_download central mysql mysql-connector-java 5.1.45
}

function download_plugin() {
    echo "Downloading Plugin: $1"
    case "$PLUGIN_NAME" in 
        elasticsearch)
            download_elasticsearch_plugins && echo "Successfully downloaded" || echo "Failed"
            ;;
        mysql)
            download_mysql_plugin && echo "Successfully downloaded" || echo "Failed"
            ;;
        oracle)
            download_oracle_plugin && echo "Successfully downloaded" || echo "Failed"
            ;;
        *)
            echo "Invalid plugin name: $PLUGIN_NAME"
            ;;
    esac
    
}

function usage_details() {
    script_name=`basename "$0"`
    echo "[Usage] ${script_name} --plugin=<name>"
    echo "example:"
    echo "${script_name} kafka-connect-elasticsearch"
}


if [[ $# -lt 1 ]]; then
    log_error "Invalid invocation, Please see the usage below"
    usage_details
    exit 1;
fi

while test $# -gt 0
do
    key=`echo "$1" | cut -d'=' -f 1`
    value=`echo "$1" | cut -d'=' -f 2`
    #debug "Key = $key , Value = $value"
    case "$key" in
        --plugin)
                PLUGIN_NAME=$value
                echo "Preparing download for ${PLUGIN_NAME}";
            ;;
        *)
            log_error "Invalid arguments, Please see the usage below"
            usage_details
            exit 1;
            ;;
    esac
    shift
done

download_plugin "${PLUGIN_NAME}"

exit $?;