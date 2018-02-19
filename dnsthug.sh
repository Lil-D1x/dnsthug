#!/bin/bash
if [ "$1" == "" ]
then
echo "DNS Enumerator - Lil D1x "
echo "$0 target.com.br wordlist.txt"
else
echo "	########################################################"
echo "	Finding the names servers"
echo "	########################################################"
host -t ns $1 | cut -d " " -f4
echo "	########################################################"
echo "	Finding the mail servers"
echo "	########################################################"
host -t mx $1 | cut -d " " -f7
echo "	########################################################"
echo "	Trying to transfer the zone"
echo "	########################################################"
for server in $(host -t ns $1 | cut -d " " -f4);do host -l $1 $server |grep "has address";done
echo "	########################################################"
echo "	Realizing brute force of subdomains"
echo "	########################################################"
for url in $(cat $2);do host $url.$1;done | grep "has address"
fi
