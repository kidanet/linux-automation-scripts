#!/bin/bash

# Log Cleaner Script
# Deletes log files older than a specified number of days

# Default values
LOG_DIR="/var/log"
RETENTION_DAYS=7
DRY_RUN=false
LOG_FILE="/var/log/log-cleaner.log"

# Usage function
usage() {
    echo "Usage: $0 [-d <log_directory>] [-r <retention_days>] [-n]"
    echo "  -d <log_directory>  : Directory containing log files (default: /var/log)"
    echo "  -r <retention_days> : Number of days to keep logs (default: 7)"
    echo "  -n                  : Dry run mode (show what will be deleted, no actual deletion)"
    exit 1
}

# Parse command-line arguments
while getopts "d:r:n" opt; do
    case ${opt} in
        d ) LOG_DIR="$OPTARG" ;;
        r ) RETENTION_DAYS="$OPTARG" ;;
        n ) DRY_RUN=true ;;
        * ) usage ;;
    esac
done

# Validate retention days
if ! [[ "$RETENTION_DAYS" =~ ^[0-9]+$ ]]; then
    echo "Error: Retention days must be a positive number."
    exit 1
fi

# Ensure log directory exists
if [[ ! -d "$LOG_DIR" ]]; then
    echo "Error: Directory $LOG_DIR does not exist."
    exit 1
fi

# Log cleanup action
log_action() {
    local message="$1"
    echo "$(date +'%Y-%m-%d %H:%M:%S') - $message" | tee -a "$LOG_FILE"
}

# Find and delete old log files
log_action "Starting log cleanup in $LOG_DIR (Retention: $RETENTION_DAYS days)"

if $DRY_RUN; then
    find "$LOG_DIR" -type f -name "*.log" -mtime +$RETENTION_DAYS -print | tee -a "$LOG_FILE"
    log_action "Dry run mode enabled: No files deleted."
else
    find "$LOG_DIR" -type f -name "*.log" -mtime +$RETENTION_DAYS -exec rm -f {} \; -print | tee -a "$LOG_FILE"
    log_action "Log cleanup completed."
fi
