#!/bin/bash
good_bird="./good_bird.txt"
missing_bird="./missing_bird.txt"
good=$(cat $good_bird | grep -v -e ready -e bfd -e Timeout)
missing=$(cat $missing_bird | grep -v -e ready -e bfd -e Timeout)

link0=0
link1=0
# bird=$(timeout 10 birdc show bfd sessions | grep -v -e ready -e bfd -e Timeout)
ecode=0
while IFS= read -r line; do
        session_state=$(echo "$line" | awk '{print $3}')
        down_session=$(echo "$line" | grep -v Up)
        session_IP=$(echo "$line" | awk '{print $1}')
        session_interface=$(echo "$line" | awk '{print $2}')
        if [[ -n "$down_session" ]] ; then
                echo "CRITICAL: BFD session IP $session_IP on interface $session_interface is in $session_state state."
                ecode=2
        fi
        if [[ "$session_interface" == "trans0" ]] ; then
                ((link0++))
        fi
        if [[ "$session_interface" == "trans1" ]] ; then
                ((link1++))
        fi
        # if [[ "$session_interface" != "$link1" ]] ; then
        #         echo "CRITICAL: BFD session interface $link1 is missing."
        #         ecode=2
        # fi
done <<< "$missing"
if [[ $link0 -eq 0 ]] ; then
        echo "$missing"
        echo "CRITICAL: BFD interface \"trans0\" is missing."
        ecode=2
fi
if [[ $link1 -eq 0 ]] ; then
        echo "$missing"
        echo "CRITICAL: BFD interface \"trans1\" is missing."
        ecode=2
fi
if [[ $ecode -eq 0 ]]; then
        echo "OK: Bird BFD sessions are in a healthy state."
fi
exit $ecode