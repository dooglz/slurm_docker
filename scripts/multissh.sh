#!/bin/bash
while read m
do
echo -e "\n${m}\n" 
ssh -n  -o ConnectTimeout=2 -o ConnectionAttempts=1 "ubuntu@${m}" "$@"
done < ips
