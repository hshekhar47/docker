#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

BUILD_DIR=$(dirname "$(readlink -fm "$0")")
pig_version=0.17.0
export PIG_HOME=/opt/pig-0.17.0

echo $PIG_HOME

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

download_and_install() {
    download_url="http://www-us.apache.org/dist/pig/pig-${pig_version}/pig-${pig_version}.tar.gz"
    if [ ! -d "${PIG_HOME}" ];then
        if [ ! -f "" ];then
            curl "${download_url}" -o /tmp/pig-${pig_version}.tar.gz 
        fi
        tar -xvf /tmp/pig-${pig_version}.tar.gz -C /opt/
        rm -r /tmp/pig-${pig_version}.tar.gz 
        ${PIG_HOME}/bin/pig -version || { log "ERROR" "Failed to installed Pig"; exit 1;}
        echo "export PIG_HOME=${PIG_HOME}" >> ~/.bashrc
        echo 'export PATH=${PATH}:${PIG_HOME}/bin' >> ~/.bashrc
        log "SUCCESS" "PIG installed successfully. Please reload the environments `source ~/.bashrc`"
    else
        log "INFO" "PIG is already installed"
    fi
}

show_help() {
    echo "`basename "$0"` [help|install]"
}

case "$1" in 
    install)
        log "INFO" "Installing Pig"
        download_and_install
        ;;
    help)
        show_help
        ;;
    *)
        log "ERROR" "Invalid command"
        show_help
        ;;
esac


exit $?;