#!/bin/bash

# ÏÇãäå ãæÑÏ äÙÑ ÑÇ ÊÚÑíİ ˜äíÏ
domain="MY_DOMAIN"

# íÊæí ãŞÕÏ ÑÇ ÊÚÑíİ ˜äíÏ
gateway="MY_IP"

# ÊÇÈÚí ÈÑÇí ÊäÙíã ãÓíÑ Èå íÊæí
define_route() {
    local ip=$1
    local gw=$2

    # ÈÑÑÓí æÌæÏ ãÓíÑ
    route_exists=$(ip route | grep "$ip via $gw")
    if [ -z "$route_exists" ]; then
        # ãÓíÑ ÑÇ ÇÖÇİå ˜äíÏ
        ip route add $ip via $gw 2>/dev/null ||  ip route replace $ip via $gw
        echo "ãÓíÑ Èå $ip ÇÒ ØÑíŞ $gw ÇÖÇİå ÔÏ." 
    else
        echo "ãÓíÑ Èå $ip ÇÒ ØÑíŞ $gw ÇÒ ŞÈá æÌæÏ ÏÇÑÏ." 
    fi
}

# ÍáŞå ÈíäåÇíÊ ÈÑÇí íä æ ÈÑæÒÑÓÇäí IP
echo "ÔÑæÚ Èå íä $domain æ ÇäÊŞÇá IP Èå íÊæí $gateway..."
while true; do
    # ÑİÊä IP ÇÒ ØÑíŞ íä
    ip=$(ping -c 1 $domain | grep "PING" | awk -F'[()]' '{print $2}')

    if [[ -n "$ip" ]]; then
        echo "IP İÚáí ÏÇãäå $domain: $ip"
        define_route $ip $gateway
    else
        echo "ÎØÇ ÏÑ ÑİÊä IP ÈÑÇí ÏÇãäå $domain"
    fi

    # í˜ ËÇäíå ÕÈÑ ˜äíÏ
    sleep 1
done
