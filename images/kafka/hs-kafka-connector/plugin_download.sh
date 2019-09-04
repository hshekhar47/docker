#!/bin/bash
set -e
MAVEN_REPO_CENTRAL=${MAVEN_REPO_CENTRAL:-"https://repo1.maven.org/maven2"}
MAVEN_REPO_CONFLUENT=${MAVEN_REPO_CONFLUENT:-"https://packages.confluent.io/maven"}
MAVEN_DEP_DESTINATION=${KAFKA_CONNECT_PLUGINS_DIR}

maven_dep() {
    local REPO="$1"
    local GROUP="$2"
    local PACKAGE="$3"
    local VERSION="$4"
    local FILE="$5"
    local MD5_CHECKSUM="$6"

    DOWNLOAD_FILE_TMP_PATH="/tmp/maven_dep/${PACKAGE}"
    DOWNLOAD_FILE="$DOWNLOAD_FILE_TMP_PATH/$FILE"
    test -d $DOWNLOAD_FILE_TMP_PATH || mkdir -p $DOWNLOAD_FILE_TMP_PATH

    echo "[dowloading]: $REPO/$GROUP/$PACKAGE/$VERSION/$FILE"
    curl -sfSL -o "$DOWNLOAD_FILE" "$REPO/$GROUP/$PACKAGE/$VERSION/$FILE"

    if [ "x$MD5_CHECKSUM" != "x"  ]; then
        echo "$MD5_CHECKSUM  $DOWNLOAD_FILE" | md5sum -c -
    fi
}

maven_central_dep() {
    maven_dep $MAVEN_REPO_CENTRAL $1 $2 $3 "$2-$3.jar" $4
    mv "$DOWNLOAD_FILE" $KAFKA_HOME/libs/
}

maven_confluent_dep() {
    maven_dep $MAVEN_REPO_CONFLUENT "io/confluent" $1 $2 "$1-$2.jar" $3
    mkdir -p $MAVEN_DEP_DESTINATION/$1 && mv "$DOWNLOAD_FILE" $MAVEN_DEP_DESTINATION/$1
}

maven_debezium_plugin() {
    maven_dep $MAVEN_REPO_CENTRAL "io/debezium" "debezium-connector-$1" $2 "debezium-connector-$1-$2-plugin.tar.gz" $3
    tar -xzf "$DOWNLOAD_FILE" -C "$MAVEN_DEP_DESTINATION" && rm "$DOWNLOAD_FILE"
}

case $1 in
    "central" ) shift
            maven_central_dep ${@}
            ;;
    "confluent" ) shift
            maven_confluent_dep ${@}
            ;;
    "debezium" ) shift
            maven_debezium_plugin ${@}
            ;;
esac