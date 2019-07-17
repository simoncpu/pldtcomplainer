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

Once your down, the final step is to edit `monitor.sh` and edit the following lines:

```
#################### EDIT HERE ####################

PLDT_ACCOUNT_NUMBER=123456789
LOG_FILE=/tmp/pldt_complaints.log
COMPLAINT_MESSAGE="DSL is disconnected. LED status is RED."

#################### EDIT HERE ####################
```

## Running

To execute once:

```
$ ./monitor.sh
```

To execute every minute:

```
$ while true; do ./monitor.sh; sleep 60; done
```

To run as a crontab, open the crontab file:

```
$ crontab -e
```

Paste this entry:

```
*	*	*	*	*	/path/to/monitor.sh
```

## Contributors
Simon Cornelius P. Umacob
