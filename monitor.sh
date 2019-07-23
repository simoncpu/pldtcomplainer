#!/bin/bash


if [ ! -f 'monitor.config' ]; then
    echo ERROR: You need to copy monitor.config.example to monitor.config and edit the file.

    exit 1
else
    . monitor.config
fi

# ping -c 3 -q 8.8.8.8 > /dev/null
ping -c 3 8.8.8.8

if [ $? -eq 0 ]; then
    echo 'PLDT is online.'

    if [ -f '/tmp/pldt_complaint_twitter' ]; then
        echo 'PLDT complaint for Twitter exists. Sending...';

        twurl -A 'Content-type: application/json' -X POST /1.1/direct_messages/events/new.json -d "`cat /tmp/pldt_complaint_twitter`"

        rm /tmp/pldt_complaint_twitter
        rm /tmp/pldt_complaint_lastip
    fi

#    They renamed or deleted their Zendesk account name
#    after flooding their ticketing system through their API.
#
#    if [ -f '/tmp/pldt_complaint_zendesk' ]; then
#        echo 'PLDT complaint for Zendesk exists. Sending...';
#
#        curl https://pldt.zendesk.com/api/v2/requests.json  -X POST -H 'Content-Type: application/json' -d "`cat /tmp/pldt_complaint_zendesk`"
#
#        rm /tmp/pldt_complaint_zendesk
#        rm -f /tmp/pldt_complaint_lastip
#    fi

    if [ ! -f '/tmp/pldt_complaint_lastip' ]; then
        curl -s https://ifconfig.co/ip | tr -d '\n' > /tmp/pldt_complaint_lastip
        echo "Saving last known IPv4 address: `cat /tmp/pldt_complaint_lastip`"
    fi

else
    echo 'PLDT is offline.'
    if [ ! -f '/tmp/pldt_complaint_twitter' ]; then
        echo 'Creating complaint...'
        timestamp=`date '+%a %B %d, %Y %I:%M %p'`
        lastip=`cat /tmp/pldt_complaint_lastip`
        msg='Date of experience: '$timestamp'\n'$COMPLAINT_MESSAGE'\nLast known IPv4 address: '$lastip'\nAccount number: '$PLDT_ACCOUNT_NUMBER'\n'

        msg_twitter='{"event":{"type":"message_create","message_create":{"target":{"recipient_id":"1526439727"},"message_data":{"text":"'$msg'"}}}}'
        msg_zendesk='{"request": {"requester": {"name": "'$EMAIL_ADDRESS'"}, "subject": "Frequent disconnection - Account number '$PLDT_ACCOUNT_NUMBER'", "comment": {"body": "'$msg'" }}}'

        echo $timestamp >> $LOG_FILE
        echo -n $msg_twitter > /tmp/pldt_complaint_twitter
        echo -n $msg_zendesk > /tmp/pldt_complaint_zendesk
    else
        echo 'Complaint already created. Waiting to be online to send...'
    fi
fi
