#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

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

log_info() { log "INFO" "$1";  }
log_success() { log "SUCCESS" "$1";  }
log_error() { log "ERROR" "$1"; }