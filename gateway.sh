#!/bin/bash

while true; do
    # Your script logic here
    if ping -c 1 8.8.8.8 > /dev/null 2>&1; then
        ip route del default
        ip route add default via 192.168.0.98 dev ens192
    else
        ip route del default
        ip route add default via 192.168.0.133 dev ens192
    fi
    sleep 10  # Adjust the sleep interval as needed
done