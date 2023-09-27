#!/bin/bash

COMMAND="$@"

if [ -z "$COMMAND" ]; then
    echo "Please provide a command to run."
    exit 1
fi

while true; do
    # Check if the program is running
    if ! pgrep -f "$COMMAND" > /dev/null; then
        # Start the program if not running
        $COMMAND &
    fi
    # Wait for a minute before checking again
    sleep 60
done
