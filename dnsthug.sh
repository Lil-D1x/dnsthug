#!/bin/bash
if [ "$1" == "" ]
then
	echo "########### LIL DIX - DNS ENUMERATOR  ###########"
	echo "- - - - - -  - - -  - - - - - - - - - - - - -"
	echo "Example: $0 target.com wordlist.txt"
	echo "- - - - - -  - - -  - - - - - - - - - - - - -"
else
echo "########################################################"
echo "	Server Info"
echo "########################################################"
host -t hinfo $1
echo "########################################################"
echo "	Finding the names servers"
echo "########################################################"
host -t ns $1 | cut -d " " -f4
echo "########################################################"
echo "	Finding the mail servers"
echo "########################################################"
host -t mx $1 | cut -d " " -f7
echo "########################################################"
echo "	Analyzing SPF"
echo "########################################################"
host -t txt $1
echo "########################################################"
echo "	Trying to transfer the zone"
echo "########################################################"
for server in $(host -t ns $1 | cut -d " " -f4);do host -l $1 $server |grep "has address";done
echo "########################################################"
echo "	Realizing brute force of subdomains"
echo "########################################################"
for url in $(cat $2);do host $url.$1;done | grep -v "NXDOMAIN"
echo "########################################################"
echo "	Realizing subdomains TakeOver"
echo "########################################################"
for url in $(cat $2);do host -t cname $url.$1;done | grep "alias for"
fi
