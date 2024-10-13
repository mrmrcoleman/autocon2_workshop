#!/bin/bash

# Wait for eth1 to appear (check every second for up to 10 seconds)
for i in {1..10}; do
    if ip link show eth1 &> /dev/null; then
        echo "eth1 is up, configuring IP address..."
        # Configure the network interface and route
        ip addr add 192.168.2.0/31 dev eth1
        ip route add 192.168.1.0/31 via 192.168.2.1 dev eth1
        break
    else
        echo "Waiting for eth1 to be available..."
        sleep 1
    fi
done

# Check if eth1 wasn't found
if ! ip link show eth1 &> /dev/null; then
    echo "eth1 did not become available, exiting..."
    exit 1
fi

# Start the Flask web server
python3 app.py