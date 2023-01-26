#!/bin/bash

# Define the log file location
log_file="/var/log/auth.log"

# Search for failed login attempts in the log file
failed_logins=$(grep -i "Failed" "$log_file")

# Check if there were any failed login attempts
if [ -n "$failed_logins" ]; then
    # Send an email notification of the failed login attempts
    echo "$failed_logins" | mail -s "Failed login attempts" admin@acme.com

    # IP address and number of failed login attempts
    declare -A ip_attempts
    # Parse the log file to extract IP address and count failed login attempts
    while read -r line; do
        ip=$(echo "$line" | awk '{print $11}')
        if [[ ${ip_attempts[$ip]} ]]; then
            ((ip_attempts[$ip]++))
        else
            ip_attempts[$ip]=1
        fi
    done <<< "$failed_logins"

    # Maximum number of failed login attempts before blocking IP
    max_attempts=5
    # Loop through the IPs and their attempts
    for ip in "${!ip_attempts[@]}"; do
        if [[ ${ip_attempts[$ip]} -ge $max_attempts ]]; then
            # Block the IP address
            iptables -A INPUT -s $ip -j DROP
            echo "IP address $ip has been blocked due to excessive failed login attempts" | mail -s "Blocked IP" admin@acme.com
        fi
    done
else
    echo "No failed login attempts found"
fi
