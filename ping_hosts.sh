#!/bin/bash

# Check if a file path is provided as an argument
if [ "$#" -eq 0 ]; then
    echo "Error: Please provide a file path as an argument."
    exit 1
fi

# Check if the specified file exists
if [ ! -e "$1" ]; then
    echo "Error: The specified file does not exist."
    exit 1
fi

input_file="$1"

# Loop through hosts in the specified input file and perform ping tests
while read -r host; do
    # Check if the host name can be resolved
    if ! ping -c 1 "$host" &>/dev/null; then
        echo "$host: Host Offline"
    else
        # Perform ping test three times
        if ping -c 3 "$host" &>/dev/null; then
            echo "$host: Ping OK"
        else
            echo "$host: Ping is Inconsistent"
        fi
    fi

    echo "--------------------------------------"
done < "$input_file"

