#!/bin/bash

USER1=$(grep -i "user1" .env | awk '{print $2}')
USER2=$(grep -i "user2" .env | awk '{print $2}')
HOSTFILE="$1"
PASSFILE="$2"
COMMAND='sudo dmidecode -s system-serial-number'

# Handle Ctrl+C
trap 'echo -e "\n🛑 Script interrupted. Exiting..."; exit 1' INT

if [ ! -f "$HOSTFILE" ]; then
    echo "❌ Host file not found: $HOSTFILE"
    exit 1
fi

if [ ! -f "$PASSFILE" ]; then
    echo "❌ Password file not found: $PASSFILE"
    exit 1
fi

while IFS= read -r host <&3 || [ -n "$host" ]; do
    host="${host//$'\r'/}"
    [ -z "$host" ] && continue

    echo "🔗 Trying $USER1@$host..."
    sshpass -f "$PASSFILE" ssh -tt \
        -o ConnectTimeout=5 \
        -o StrictHostKeyChecking=no \
        -o PreferredAuthentications=password \
        -o PubkeyAuthentication=no \
        "$USER1@$host" "$COMMAND"

    if [ $? -ne 0 ]; then
        echo "❌ Failed with $USER1, retrying with $USER2@$host..."
        sshpass -f "$PASSFILE" ssh -tt \
            -o ConnectTimeout=5 \
            -o StrictHostKeyChecking=no \
            -o PreferredAuthentications=password \
            -o PubkeyAuthentication=no \
            "$USER2@$host" "$COMMAND"

        if [ $? -ne 0 ]; then
            echo "❌ Both attempts failed for $host"
        else
            echo "✅ Success with $USER2@$host"
        fi
    else
        echo "✅ Success with $USER1@$host"
    fi

    echo "----------------------------------"
done 3< "$HOSTFILE"
