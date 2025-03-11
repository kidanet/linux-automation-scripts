#!/bin/bash

# Service Monitoring Script
# This script checks if a service is running, restarts it if it's not,
#      logs the event, and optionally sends an email notification.

SERVICE_NAME="apache2"  # Change to the service you want to monitor
                        #        (e.g., nginx, mysql, etc.)
LOG_FILE="/var/log/service-monitor.log"
EMAIL="your-email@example.com"  # Set to receive notifications (optional)
ENABLE_EMAIL=false  # Set to true if you want email notifications

# Function to log events
log_event() {
    local message="$1"
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $message" | tee -a "$LOG_FILE"
}

# Function to check if the service is running
is_service_running() {
    systemctl is-active --quiet "$SERVICE_NAME"
    return $?  # Returns 0 if running, 1 if not
}

# Function to restart the service
restart_service() {
    log_event "Service $SERVICE_NAME is not running. Restarting..."
    systemctl restart "$SERVICE_NAME"

    if is_service_running; then
        log_event "Service $SERVICE_NAME restarted successfully."
    else
        log_event "Failed to restart $SERVICE_NAME!"
        send_email "ALERT: Service $SERVICE_NAME failed to restart!"
    fi
}

# Function to send an email alert (optional)
send_email() {
    local subject="$1"
    if [ "$ENABLE_EMAIL" = true ]; then
        echo "$subject" | mail -s "$subject" "$EMAIL"
        log_event "Email notification sent: $subject"
    fi
}

# Main monitoring logic
if ! is_service_running; then
    restart_service
else
    log_event "Service $SERVICE_NAME is running."
fi
