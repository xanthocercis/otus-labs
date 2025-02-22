#!/bin/bash

printf "%-6s %-4s %s\n" "PID" "STAT" "COMMAND"

for pid in /proc/[0-9]*; do
    pid_num=$(basename "$pid")
    
    if [ -r "$pid/stat" ]; then
        stat_info=$(cat "$pid/stat")
        pid_field=$(echo "$stat_info" | awk '{print $1}')
        stat_field=$(echo "$stat_info" | awk '{print $3}')
    fi

    if [ -r "$pid/cmdline" ]; then
        cmdline=$(tr '\0' ' ' < "$pid/cmdline")
    fi

    if [ -z "$cmdline" ]; then
        cmdline=$(echo "$stat_info" | awk '{print $2}' | tr -d '()')
    fi

    printf "%-6s %-4s %s\n" "$pid_field" "$stat_field" "$cmdline"
done
