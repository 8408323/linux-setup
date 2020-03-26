#!/bin/bash

p() {
pacmd list-sinks |\
awk '/^\s+name: /{indefault = $2 == "<'"$(pacmd stat |\
awk -F": " '/^Default sink name: /{print $2}')"'>"} /^\s+volume: / && indefault {print $5; exit}' 
}

p

pactl subscribe |\
sed -u '/sink /!d' |\
while read -r; do
    p
done
