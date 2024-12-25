#!/bin/bash

# دامنه مورد نظر را تعريف کنيد
domain="MY_DOMAIN"

# گيت‌وي مقصد را تعريف کنيد
gateway="MY_IP"

# تابعي براي تنظيم مسير به گيت‌وي
define_route() {
    local ip=$1
    local gw=$2

    # بررسي وجود مسير
    route_exists=$(ip route | grep "$ip via $gw")
    if [ -z "$route_exists" ]; then
        # مسير را اضافه کنيد
        ip route add $ip via $gw 2>/dev/null ||  ip route replace $ip via $gw
        echo "مسير به $ip از طريق $gw اضافه شد." 
    else
        echo "مسير به $ip از طريق $gw از قبل وجود دارد." 
    fi
}

# حلقه بي‌نهايت براي پينگ و بروزرساني IP
echo "شروع به پينگ $domain و انتقال IP به گيت‌وي $gateway..."
while true; do
    # گرفتن IP از طريق پينگ
    ip=$(ping -c 1 $domain | grep "PING" | awk -F'[()]' '{print $2}')

    if [[ -n "$ip" ]]; then
        echo "IP فعلي دامنه $domain: $ip"
        define_route $ip $gateway
    else
        echo "خطا در گرفتن IP براي دامنه $domain"
    fi

    # يک ثانيه صبر کنيد
    sleep 1
done
