#!/bin/bash

USER1="rveras1"
USER2="raul.veras"
HOSTFILE=~/inv.ini

for host in $(cat "$HOSTFILE"); do
    echo "🔗 Trying $USER1@$host..."
    ssh -o ConnectTimeout=5 -o BatchMode=no -o PreferredAuthentications=password -t "$USER1@$host" "whoami"

    # Check if SSH succeeded
    if [ $? -ne 0 ]; then
        echo "❌ Failed with $USER1, retrying with $USER2@$host..."
        ssh -o ConnectTimeout=5 -o BatchMode=no -o PreferredAuthentications=password -t "$USER2@$host" "free -h"
        if [ $? -ne 0 ]; then
            echo "❌ Both attempts failed for $host"
        fi
    fi

    echo "----------------------------------"
done

