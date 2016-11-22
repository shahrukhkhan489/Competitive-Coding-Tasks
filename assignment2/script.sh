#!/bin/bash

# single prompt for user command
read command

# iterating through comma seperated hostnames listed in hostslist.csv file
for i in $(cat $1 | sed "s/,/ /g")
do
        # executing the command on each host
        ssh -t $i $command
done
