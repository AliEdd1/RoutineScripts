#!/bin/bash


if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <CIDR>"
    echo "Example: $0 192.168.1.0/24"
    exit 1
fi


ip_range="$1"
ip_address=$(echo "$ip_range" | cut -d'/' -f1)
subnet_mask=$(echo "$ip_range" | cut -d'/' -f2)


num_ips=$((2**(32 - $subnet_mask)))


for ((i=1; i<$num_ips; i++)); do
    ip=$(printf "%s.%s\n" $(echo "$ip_address" | cut -d'.' -f1-3) $((i)))
    echo "$ip"
done


