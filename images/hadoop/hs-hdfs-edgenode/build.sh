#!/bin/bash
NAME=hshekhar47/hdfs-edgenode
VERSION=0.1

BUILD_DIR=$(dirname "$(readlink -fm "$0")")

BUILD_RESOURCES=("apache-hive-2.3.3-bin.tar.gz spark-2.3.0-bin-hadoop2.7.tgz sqoop-1.4.7.bin__hadoop-2.6.0.tar.gz") 

pre_build() {
    RESOURCES_DIR=$(dirname "${BUILD_DIR}")/resources

    for resource in ${BUILD_RESOURCES[@]}; do
        if [ ! -f "${BUILD_DIR}/${resource}" ];then 
            cp ${RESOURCES_DIR}/${resource} ${BUILD_DIR}
        fi
    done 
}

post_build() {
    for resource in ${BUILD_RESOURCES[@]}; do
        rm -rf ${BUILD_DIR}/${resource}
    done 
}

clean() {
    echo "Cleaning ${NAME}:${VERSION}";
    docker image rm ${NAME}:${VERSION}
    if [ "$?" == "0" ]; then
        echo "[INFO ]: Removed image ${NAME}:${VERSION} successfully."; return 0;
    fi
    return 1
}

build() {
    pre_build
    docker build -t ${NAME}:${VERSION} ${BUILD_DIR}
    if [ "$?" == "0" ];then
        echo "[INFO ]: ${NAME}:${VERSION} created successfully." 
        post_build
        return 0;
    fi
    return 1
}

case "$1" in
    "clean") 
        clean;;
    "build")
        build;;
    *) 
        clean; build;;
esac

exit $?;