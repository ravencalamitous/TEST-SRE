#!/bin/bash

log_directory=`pwd`

current_time=$(date +"%Y-%m-%d %H:%M:%S")
ten_minutes_ago=$(date -d '10 minutes ago' +"%s")

for log_file in "$log_directory"/*.log; do
    file_modification_time=$(stat -c %Y "$log_file" 2>/dev/null) # Suppress error output if timestamp is invalid

    if [ -n "$file_modification_time" ] && [ "$file_modification_time" -ge "$ten_minutes_ago" ]; then
        http_500_count=$(grep "HTTP/1.1\" 500" "$log_file" | wc -l)

        echo "There were $http_500_count HTTP 500 errors in $log_file modified within the last 10 minutes."
    fi
done
