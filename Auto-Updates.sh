#!/bin/bash

# Log file location
log_file="/var/log/system_updates.log"

# Update package lists from repositories
echo "Updating package lists from repositories..." | tee -a "$log_file"
sudo apt-get update -y 2>&1 | tee -a "$log_file"

# Check for errors
if [ $? -ne 0 ]; then
    echo "Error updating package lists, exiting..." | tee -a "$log_file"
    exit 1
fi

# Upgrade all packages to the latest version
echo "Upgrading all packages to the latest version..." | tee -a "$log_file"
sudo apt-get upgrade -y 2>&1 | tee -a "$log_file"

# Check for errors
if [ $? -ne 0 ]; then
    echo "Error upgrading packages, exiting..." | tee -a "$log_file"
    exit 1
fi

# Install any available security updates
echo "Installing any available security updates..." | tee -a "$log_file"
sudo apt-get dist-upgrade -y 2>&1 | tee -a "$log_file"

# Check for errors
if [ $? -ne 0 ]; then
    echo "Error installing security updates, exiting..." | tee -a "$log_file"
    exit 1
fi

# Check if reboot is required
if [ -f /var/run/reboot-required ]; then
    echo "Reboot is required, please reboot the system." | tee -a "$
