#!/usr/bin/env bash

LOGFILE="./log.txt"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

timestamp() {
    date '+%Y-%m-%d %H:%M:%S'
}

log() {
    local level="$1"
    local color="$2"
    local message="$3"
    local ts
    ts="$(timestamp)"

    # Console (with color)
    printf "%b\n" "${color}${ts} [$level] ${message}${NC}"

    # File (no color)
    printf "%s [%s] %s\n" "$ts" "$level" "$message" >> "$LOGFILE"
}

log_info() {
    log "INFO" "$CYAN" "$1"
}

log_success() {
    log "SUCCESS" "$GREEN" "$1"
}

log_warn() {
    log "WARN" "$YELLOW" "$1"
}

log_error() {
    local ts
    ts="$(timestamp)"

    # stderr for errors
    printf "%b\n" "${RED}${ts} [ERROR] $1${NC}" >&2
    printf "%s [ERROR] %s\n" "$ts" "$1" >> "$LOGFILE"
}