#!/bin/bash


read -p "Enter the target IP address: " TARGET_IP


if [[ -z "$TARGET_IP" ]]; then
    echo "❌ No IP address entered. Exiting..."
    exit 1
fi

echo "🔍 Scanning $TARGET_IP for open ports (1-10000)..."


OPEN_PORTS=$(nmap -p 1-10000 --open -oG - "$TARGET_IP" | awk -F'Ports: ' '{print $2}' | tr ',' '\n' | awk -F '/' '{print $1}')


if [[ -z "$OPEN_PORTS" ]]; then
    echo "❌ No open ports found on $TARGET_IP."
    exit 1
fi

echo "✅ Open ports found: $OPEN_PORTS"
echo "🔍 Checking which port runs SSH using Netcat (nc)..."


for PORT in $OPEN_PORTS; do
    echo "🛠️  Checking port $PORT..."
    

    SSH_BANNER=$(echo -e "\n" | timeout 7 nc -w 5 "$TARGET_IP" "$PORT" 2>/dev/null || echo "")


    if [[ -n "$SSH_BANNER" ]]; then
        echo "🔹 Response from port $PORT: $SSH_BANNER"
    else
        echo "⚠️ No response from port $PORT"
    fi


    if [[ "$SSH_BANNER" == *"OpenSSH"* ]]; then
        echo "✅ SSH detected on port $PORT!"
        echo "🔹 Banner: $SSH_BANNER"
        exit 0
    else
        echo "❌ Port $PORT is not OpenSSH"
    fi
done

echo "❌ No OpenSSH service found on the scanned ports."
exit 1

