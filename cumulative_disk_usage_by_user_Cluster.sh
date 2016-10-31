#!/bin/bash

path="/local"

hostlist=$1
ssh_user=$2
ssh_private_key=$3

> filelist.txt

for i in `cat $hostlist` ; do ssh -t -i $ssh_private_key $ssh_user@$i "sudo find $path -type f | xargs -I{} sudo ls -l {} | awk '{print \$3, \$5, \$9}'"  ; done  >> filelist.txt

for i in `cat filelist.txt | awk '{print $1}' | sort | uniq`; do cat filelist.txt | awk -v i="$i" '{if ($1 == i) print $0;}' | awk '{sum = sum + $2} END {print $1, sum}' ; done > totalspace.txt

sort -n -k 2,2 totalspace.txt | tail -10 | awk '{print $1}'
