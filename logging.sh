#!/usr/bin/env bash

LOGFILE="./log.txt"

YELLOW='\033[1;33m'
NC='\033[0m' # No Color
RED='\033[0;31m'
GREEN='\033[0;32m'
DATE=$(date '+%Y-%m-%d-%H-%M-%S')

write_log() {
    local message="$1"
    local local_message="${DATE} $message"
    echo -e "${GREEN}${DATE} $message ${NC}"
    echo "$local_message" >> "$LOGFILE"
}

write_error() {
    local message="$1"
    local local_message="${DATE} $message"
    echo -e "${RED}${DATE} $message ${NC}"
    echo "$local_message" >> "$LOGFILE"
}

