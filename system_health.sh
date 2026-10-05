#!/bin/bash

LOG_DIR="logs"
LOG_FILE="$LOG_DIR/system_health.log"

mkdir -p "$LOG_DIR"

log_message() {
    TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
    echo "$TIMESTAMP - $1" >> "$LOG_FILE"
}

log_message "Health check started"

get_system_info() {
	HOSTNAME=$(hostname)
	OS_INFO=$(grep '^PRETTY_NAME=' /etc/os-release | cut -d= -f2- | tr -d '"')
	KERNEL=$(uname -r)
	UPTIME=$(uptime)

	echo "Linux System Information & Health Check"
	echo
	echo "System Information"
	echo "---------------------"
	echo "Hostname   : $HOSTNAME"
	echo "OS         : $OS_INFO"
	echo "Kernel     : $KERNEL"
	echo "Uptime     : $UPTIME"
}

get_cpu_info() {
	CPU_COUNT=$(nproc)
        CPU_MODEL=$(lscpu | grep 'Model name')

	echo
	echo "CPU"
	echo "---"
	echo "CPU Count : $CPU_COUNT"
	echo "CPU Model : $CPU_MODEL"

}

get_memory_info() {
    MEMORY_TOTAL=$(free -h | grep '^Mem:' | awk '{print $2}')
    MEMORY_USED=$(free -h | grep '^Mem:' | awk '{print $3}')
    MEMORY_AVAILABLE=$(free -h | grep '^Mem:' | awk '{print $7}')

    MEMORY_TOTAL_KB=$(free | awk '/^Mem:/ {print $2}')
    MEMORY_AVAILABLE_KB=$(free | awk '/^Mem:/ {print $7}')

    MEMORY_USED_KB=$((MEMORY_TOTAL_KB - MEMORY_AVAILABLE_KB))
    MEMORY_USAGE=$((MEMORY_USED_KB * 100 / MEMORY_TOTAL_KB))

    if [ "$MEMORY_USAGE" -lt 80 ]; then
        MEMORY_STATUS="OK"
    elif [ "$MEMORY_USAGE" -le 90 ]; then
        MEMORY_STATUS="WARNING"
    else
        MEMORY_STATUS="CRITICAL"
    fi

    echo
    echo "Memory"
    echo "------"
    echo "Total      : $MEMORY_TOTAL"
    echo "Used       : $MEMORY_USED"
    echo "Available  : $MEMORY_AVAILABLE"
    echo "Usage      : ${MEMORY_USAGE}%"
    echo "Status     : $MEMORY_STATUS"
    log_message "Memory status: $MEMORY_STATUS"
}

get_disk_info() {
	DISK_INFO=$(df -h / | tail -n 1)

	DISK_TOTAL=$(echo "$DISK_INFO" | awk '{print $2}')
	DISK_USED=$(echo "$DISK_INFO" | awk '{print $3}')
	DISK_AVAILABLE=$(echo "$DISK_INFO" | awk '{print $4}')
	DISK_USAGE=$(echo "$DISK_INFO" | awk '{print $5}')
	DISK_USAGE_NUM=${DISK_USAGE%\%}

	if [ "$DISK_USAGE_NUM" -lt 80 ]; then
	    DISK_STATUS="OK"
	elif [ "$DISK_USAGE_NUM" -le 90 ]; then
    	DISK_STATUS="WARNING"
	else
    	DISK_STATUS="CRITICAL"
	fi

	echo
	echo "Disk"
	echo "----"
	echo "Total     : $DISK_TOTAL"
	echo "Used      : $DISK_USED"
	echo "Available : $DISK_AVAILABLE"
	echo "Usage     : $DISK_USAGE"
	echo "Status	: $DISK_STATUS"
        log_message "Disk status: $DISK_STATUS"
}

get_network_info() {
    NETWORK_INTERFACE=$(ip -br addr | grep -v '^lo ' | awk 'NR==1 {print $1}')
    NETWORK_STATUS=$(ip -br addr | grep -v '^lo ' | awk 'NR==1 {print $2}')
    NETWORK_IP=$(ip -br addr | grep -v '^lo ' | awk 'NR==1 {print $3}')

    if [ -z "$NETWORK_INTERFACE" ]; then
        NETWORK_INTERFACE="N/A"
        NETWORK_STATUS="UNKNOWN"
        NETWORK_IP="N/A"
        CONNECTIVITY="FAILED"
    else
        if ping -c 1 8.8.8.8 > /dev/null 2>&1; then
            CONNECTIVITY="OK"
        else
            CONNECTIVITY="FAILED"
        fi
    fi

    echo
    echo "Network"
    echo "-------"
    echo "Interface    : $NETWORK_INTERFACE"
    echo "Status       : $NETWORK_STATUS"
    echo "IP           : $NETWORK_IP"
    echo "Connectivity : $CONNECTIVITY"
    log_message "Network status: $CONNECTIVITY"
}

get_overall_health() {
    CPU_STATUS="OK"

    if [ "$MEMORY_STATUS" = "CRITICAL" ] || [ "$DISK_STATUS" = "CRITICAL" ] || [ "$CONNECTIVITY" = "FAILED" ]; then
        OVERALL_STATUS="CRITICAL"
    elif [ "$MEMORY_STATUS" = "WARNING" ] || [ "$DISK_STATUS" = "WARNING" ]; then
        OVERALL_STATUS="WARNING"
    else
        OVERALL_STATUS="HEALTHY"
    fi

    echo
    echo "Overall Health"
    echo "--------------"
    echo "CPU       : $CPU_STATUS"
    echo "Memory    : $MEMORY_STATUS"
    echo "Disk      : $DISK_STATUS"
    echo "Network   : $CONNECTIVITY"
    echo
    echo "Overall   : $OVERALL_STATUS"
    log_message "Overall status: $OVERALL_STATUS"
}


get_system_info
get_cpu_info
get_memory_info
get_disk_info
get_network_info
get_overall_health
log_message "Health check completed"

