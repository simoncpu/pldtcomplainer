#!/bin/bash


#################### EDIT HERE ####################

PLDT_ACCOUNT_NUMBER=123456789
LOG_FILE=/tmp/pldt_complaints.log
COMPLAINT_MESSAGE="DSL is disconnected. LED status is RED."

#################### EDIT HERE ####################

ping -c 3 -q 8.8.8.8 > /dev/null

if [ $? -eq 0 ]; then
    echo 'PLDT is online.'

    if [ -f '/tmp/pldt_complaint' ]; then
        echo 'PLDT complaint exists. Sending...';
        twurl -A 'Content-type: application/json' -X POST /1.1/direct_messages/events/new.json -d "`cat /tmp/pldt_complaint`"
        rm /tmp/pldt_complaint
        rm /tmp/lastip
    fi

    if [ ! -f '/tmp/lastip' ]; then
        curl -s https://ifconfig.co/ip | tr -d '\n' > /tmp/lastip
        echo "Saving last known IPv4 address: `cat /tmp/lastip`"
    fi

else
    echo 'PLDT is offline.'
    if [ ! -f '/tmp/pldt_complaint' ]; then
        echo 'Creating complaint...'
        timestamp=`date '+%a %B %d, %Y %I:%M %p'`
        lastip=`cat /tmp/lastip`
        msg='{"event":{"type":"message_create","message_create":{"target":{"recipient_id":"1526439727"},"message_data":{"text":"Date of experience: '$timestamp'\n'$COMPLAINT_MESSAGE'\nLast known IPv4 address: '$lastip'\nAccount number: '$PLDT_ACCOUNT_NUMBER'\n"}}}}'

        echo $timestamp >> $LOG_FILE
        echo -n $msg > /tmp/pldt_complaint
    else
        echo 'Complaint already created. Waiting to be online to send...'
    fi
fi

