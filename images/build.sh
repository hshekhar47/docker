#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

BUILD_DIR=$(dirname "$(readlink -fm "$0")")

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

images=("hs-debian" "hs-debian-jre8" "hs-hdfs-core" "hs-hdfs-namenode")

show_image_list() {
    choice=0
    log "INFO" "Select Image:"
    index=0
    for image in ${images[@]}; do
        ((index++))
        log "INFO" "\t${index}. ${image}"
    done
}

clean() {
    log "INFO" "Cleaning ${1}"
    eval "${BUILD_DIR}/${1}/build.sh clean"
}

build() {
    log "INFO" "Building ${1}"
    eval "${BUILD_DIR}/${1}/build.sh build"
}

clean_actions() {
    if [ -z "$1" ]; then
        for image in ${images[@]}; do
            clean ${image}
        done 
    else
       clean $1
    fi
}

build_actions() {
    if [ -z "$1" ]; then
        for image in ${images[@]}; do
            build ${image}
        done 
    else
       build $1 
    fi
}

show_help() {
    echo "`basename "$0"` <clean|build> [name]"
}

case "$1" in
    clean)
        clean_actions $2;;
    build)
        build_actions $2;;
    *)
        log "ERROR" "Invalid action $1"; show_help;;
esac

