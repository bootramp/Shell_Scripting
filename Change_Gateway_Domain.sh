#!/bin/bash

# Define Domain
domain="MY_DOMAIN"

# Define Gateway
gateway="MY_IP"

# Change route Func
define_route() {
    local ip=$1
    local gw=$2

    # Check Existing Path
    route_exists=$(ip route | grep "$ip via $gw")
    if [ -z "$route_exists" ]; then
        # Add Path
        ip route add $ip via $gw 2>/dev/null ||  ip route replace $ip via $gw
        echo "Add Route to $ip via $gw" 
    else
        echo "Already exist $ip via $gw" 
    fi
}

# Ultimate Loop for Check
echo "Start ping $domain and route IP to $gateway"
while true; do
    # Take IP from Ping
    ip=$(ping -c 1 $domain | grep "PING" | awk -F'[()]' '{print $2}')

    if [[ -n "$ip" ]]; then
        echo "Current IP $domain: $ip "
        define_route $ip $gateway
    else
        echo "Error when take IP from $domain"
    fi

    # Wait a 1 Sec
    sleep 1
done
