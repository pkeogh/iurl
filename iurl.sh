#!/bin/bash

url="$1"
string="$2"
changed=0

PROGNAME=${0##*/}
VERSION="0.1"

usage() {
  echo "Usage: ${PROGNAME} [-h|--help] [url] [string]"
}

help_message() {
  cat <<- _EOF_
  ${PROGNAME} ${VERSION}
  OSX-optimized URL change detector - retire your refresh button.

  $(usage)

  Options:

  -h, --help    Display this help message and exit.
  [url]         URL to target (follows redirects)_EOF_
  [string]      String that will disappear signaling change

_EOF_
}

while getopts "h?" opt; do
    case "$opt" in
    h|\?)
        help_message
        exit 0
        ;;
    esac
done

if [ "$#" -ne 2 ]; then
    echo "Illegal number of parameters:"
    usage
    exit 1
fi

regex='(https?|ftp|file)://[-A-Za-z0-9\+&@#/%?=~_|!:,.;]*[-A-Za-z0-9\+&@#/%=~_|]'
if [[ $url =~ $regex ]]
then
    echo "URL validated"
else
    echo "Invalid URL"
    usage
    exit 1
fi

while [ $changed -eq 0 ]; do
  string_present=`curl --silent -L $url | grep "$string" | wc -l`
  if [ $string_present -ge 1 ]; then
    echo String still present at $url - sleeping...
    sleep 30
  else
    timestamp=`date`
    terminal-notifier -message "Website $url has changed at $timestamp" -title "URL Content Changed"
    dialog --title 'URL Content Changed' --msgbox "Website $url has changed at $timestamp" 6 60
    changed=1
  fi
done
exit 0

