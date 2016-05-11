#!/bin/bash
# BASH 4 only

declare -A settings

settings_files=$(find /sys/class/net/bond0/bonding/ -type f)
for i in $settings_files
do
        value=$(cat $i)
        echo "$i = $value"
        settings[$i]=$value
done

