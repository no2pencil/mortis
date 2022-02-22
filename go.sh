#!/bin/bash

function help() {
  echo "$0 <fqdn> <1>"
  exit 1
}

fqdn=mortis.com

if [ $1 ]; then
  fqdn=$(echo $1)
fi

if [ $2 ]; then
  if [ $2 -eq 1 ]; then
    echo "Purging old wordlist..."
    rm wordlist.txt 2> /dev/null
  else
    help
  fi
fi

# Before we can start checking, lets validate (or fetch) the wordlist
if [ ! -f wordlist.txt ]; then
  echo "Fetching Wordlist..."
  wget --quiet https://raw.githubusercontent.com/guelfoweb/knock/master/knockpy/wordlist.txt -O wordlist.txt

fi

if [ -f results.txt ]; then
  mv results.txt results.$(date +%m%d%Y).txt
fi

for sub in $(cat wordlist.txt)
do
  echo ${sub}.${fqdn}
  dig @1.1.1.1 +short ${sub}.${fqdn} >> results.txt
  sleep 2
done
