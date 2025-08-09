#!/bin/bash

ip_file="ip_list.txt"

if [ ! -f "$ip_file" ]; then
    echo "Error: File '$ip_file' not found."
    exit 1
fi

echo "Reading IPs from file..."

while IFS= read -r ip; do
    echo "Pinging $ip..."
    result=$(ping -c 4 "$ip" 2>&1)
    

    packet_loss=$(echo "$result" | grep -oP '\d+(?=% packet loss)')

    if [[ $result == *"Destination Host Unreachable"* || $result == *"Request timed out"* || $packet_loss == "100" ]]; then
        echo "Ping unsuccessful for $ip with $packet_loss% packet loss"
    else
        echo "Ping successful for $ip with $packet_loss% packet loss"
    fi

    echo
done < "$ip_file"

