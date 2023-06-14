#!/bin/bash
# by https://github.com/spiritLHLS/lxc

file="/etc/iptables/rules.v6"
array=()

while IFS= read -r line; do
    if [[ $line == "-A PREROUTING -d"* ]]; then
        parameter="${line#*-d }"
        parameter="${parameter%%/*}"
        array+=("$parameter")
    fi
done < "$file"

if [ ${#array[@]} -eq 0 ]; then
    echo "Empty IPV6 array"
else
    interface=$(lshw -C network | awk '/logical name:/{print $3}' | head -1)
    for parameter in "${array[@]}"; do
        ip addr add "$parameter"/64 dev "$interface"
    done
fi