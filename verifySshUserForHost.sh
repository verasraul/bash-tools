#!/bin/bash

USER1="rveras1"
USER2="raul.veras"
HOSTFILE="$1"
PASSFILE="$2"
COMMAND='sudo dmidecode -s system-manufacturer'

if [ ! -f "$HOSTFILE" ]; then
    echo "❌ Host file not found: $HOSTFILE"
    exit 1
fi

if [ ! -f "$PASSFILE" ]; then
    echo "❌ Password file not found: $PASSFILE"
    exit 1
fi

while IFS= read -r host || [ -n "$host" ]; do
    host="${host//$'\r'/}"
    [ -z "$host" ] && continue

    echo "🔗 Trying $USER1@$host..."
    sshpass -f "$PASSFILE" ssh -tt \
        -o ConnectTimeout=5 \
        -o StrictHostKeyChecking=no \
        -o PreferredAuthentications=password \
        -o PubkeyAuthentication=no \
        "$USER1@$host" "$COMMAND" < /dev/null

    if [ $? -ne 0 ]; then
        echo "❌ Failed with $USER1, retrying with $USER2@$host..."
        sshpass -f "$PASSFILE" ssh -tt \
            -o ConnectTimeout=5 \
            -o StrictHostKeyChecking=no \
            -o PreferredAuthentications=password \
            -o PubkeyAuthentication=no \
            "$USER2@$host" "$COMMAND" < /dev/null

        if [ $? -ne 0 ]; then
            echo "❌ Both attempts failed for $host"
        else
            echo "✅ Success with $USER2@$host"
        fi
    else
        echo "✅ Success with $USER1@$host"
    fi

    echo "----------------------------------"
done < "$HOSTFILE"