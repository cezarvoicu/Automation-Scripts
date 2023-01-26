#!/bin/bash

# Define the directory to be monitored
dir="/var/www/html"

# Take a snapshot of the current state of the system
snapshot_file="/tmp/snapshot.txt"
find "$dir" -type f -exec md5sum {} \; > "$snapshot_file"

# Sleep for 60 seconds
sleep 60

# Take a new snapshot of the system
new_snapshot_file="/tmp/new_snapshot.txt"
find "$dir" -type f -exec md5sum {} \; > "$new_snapshot_file"

# Compare the current and new snapshots
changes=$(diff "$snapshot_file" "$new_snapshot_file")
if [ -n "$changes" ]; then
    # Send an email notification of the changes
    echo "Changes detected in $dir on $(date)" | mail -s "Intrusion detection" admin@example.com
    echo "Changes:"
    echo "$changes"
else
    echo "No changes detected"
fi

# Clean up the snapshot files
rm "$snapshot_file" "$new_snapshot_file"
