#!/bin/bash
LED_PATH="/sys/class/leds/input1::scrolllock/brightness"

while true; do
    val=$(cat "$LED_PATH" 2>/dev/null)
    if [ "$val" != "1" ]; then
        echo 1 > "$LED_PATH"
    fi
    sleep 5
done
