#!/bin/sh
BLANK_TIMEOUT=60
IDLE_TIME=0

# Loop continuously as long as Plymouth is managing the boot screen
while plymouth --ping 2>/dev/null; do
    # Check if a key has been pressed (non-blocking 1-second read)
    if read -t 1 -n 1 KEY 2>/dev/null; then
        # Key detected: Reset the idle timer and instantly wake the monitor if it was blanked
        IDLE_TIME=0
        setterm --blank poke --term linux > /dev/tty1 2>/dev/null
    else
        # No key pressed: Increment our idle counter by 1 second
        IDLE_TIME=$((IDLE_TIME + 1))
    fi

    # If the system has been idle for too long, blank the screen safely
    if [ "$IDLE_TIME" -ge "$BLANK_TIMEOUT" ]; then
        setterm --blank 1 --term linux > /dev/tty1 2>/dev/null
    fi
done
