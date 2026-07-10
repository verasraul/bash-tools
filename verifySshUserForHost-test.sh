#!/bin/bash

USER1=$(grep -i "user1" .env | awk '{print $2}')
USER2=$(grep -i "user2" .env | awk '{print $2}')
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
    # skip blank lines
    [ -z "$host" ] && continue

    echo "🔗 Trying $USER1@$host..."
    sshpass -f "$PASSFILE" ssh \
        -o ConnectTimeout=5 \
        -o StrictHostKeyChecking=no \
        -o PreferredAuthentications=password \
        -o PubkeyAuthentication=no \
        -t "$USER1@$host" "$COMMAND"

    if [ $? -ne 0 ]; then
        echo "❌ Failed with $USER1, retrying with $USER2@$host..."
        sshpass -f "$PASSFILE" ssh \
            -o ConnectTimeout=5 \
            -o StrictHostKeyChecking=no \
            -o PreferredAuthentications=password \
            -o PubkeyAuthentication=no \
            -t "$USER2@$host" "$COMMAND"

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
