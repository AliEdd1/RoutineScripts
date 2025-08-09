#!/bin/bash

ip_file="ip_list.txt"

if [ ! -f "$ip_file" ]; then
    echo "Error: File '$ip_file' not found."
    exit 1
fi

echo "Reading IPs from file..."

while IFS= read -r ip; do
    echo "Trying to connect to $ip on port 22..."
    

    if timeout 5 telnet "$ip" 22 > /dev/null 2>&1; then
        echo "Telnet connection to $ip on port 22 successful"
    else
        echo "Telnet connection to $ip on port 22 unsuccessful"
    fi

    echo
done < "$ip_file"

