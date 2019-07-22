# pldtcomplainer
Detects downtime on your local PC and sends an automated complaint to PLDT. It currently sends a complaint to Twitter only. FB messenger may be supported in the future as the need arises. I might directly hook into their ticketing system if their customer support ignores me.

## Installation
This requires bash on a standard Linux/Unix environment. It depends on [curl](https://curl.haxx.se/) and [twurl](https://github.com/twitter/twurl).

If you're using Ubuntu:

```
$ sudo apt-get install curl
```
Refer to your OS' docs on the specific steps to install curl on your system.

Install twurl:

```
$ sudo apt-get install ruby
$ sudo gem install twurl
```

Authorize twurl:

First, apply for a developer account to access the Twitter APIs:

```
https://developer.twitter.com/en/apply-for-access
```

Then, go to the [Twitter Developer Page](https://developer.twitter.com/en/apps), and create an app. Once you've created an app, generate your Consumer API keys and authorize your account:

```
$ twurl authorize --consumer-key <key> \
                  --consumer-secret <secret>
```

After you've finished installing the prerequisites, the final step is to copy `monitor.config.example` to `monitor.config` and edit the following lines:

```
#################### EDIT HERE ####################

PLDT_ACCOUNT_NUMBER=1234567890
EMAIL_ADDRESS=simoncpu@example.org
COMPLAINT_MESSAGE="DSL is disconnected. LED status is RED."
LOG_FILE=/var/log/pldtcomplaints.log

#################### EDIT HERE ####################
```

## Running

To execute once:

```
$ ./monitor.sh
```

To execute every 30 seconds:

```
$ while true; do ./monitor.sh; sleep 30; done
```

To execute every minute via crontab, open the crontab file:

```
$ crontab -e
```

Paste this entry:

```
*	*	*	*	*	/path/to/monitor.sh
```

## Contributors
Simon Cornelius P. Umacob
