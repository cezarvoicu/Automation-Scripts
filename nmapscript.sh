#!/bin/bash

# Set the target IP or hostname
target="0.0.0.0/24"

# Set the date and time format
date=$(date +"%Y-%m-%d_%H-%M-%S")

# Set the location to save the scan results
location="/path/to/file"

# Set the email address to send the report to
email_address="cezarvoicu@acme.com"

# Check if the location to save the scan results exists
if [ ! -d "$location" ]; then
    mkdir "$location"
fi

# Run the nmap scan and save the results to a file
sudo nmap -sS -T4 -oA "$location/nmap_scan_$date" $target

# Send the scan results via email
cat "$location/nmap_scan_$date.nmap" | mail -s "Nmap scan results for $date" $email_address

# Schedule the script to run on the 25th of every month using cron
echo "0 0 25 * * /path/to/file/nmapscan.sh" | crontab -
