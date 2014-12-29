#!/bin/bash

url="$1"
string="$2"
changed=0

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
