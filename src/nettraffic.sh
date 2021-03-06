#!/bin/bash
# Ouput network I/O traffic in a human readable format
# Network interface name must be passed as Args

INTERVAL=5
LOG_MAXLINE=20
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
LOG_FILE=$DIR/traffic.csv

echo "Output traffic CSV file to : " $LOG_FILE

if [[ "$#" -eq 0 ]]; then
	echo "Usage: nettraffic [[Interface Name]..]"
	echo "eg: nettraffic eth0 wlan0"
	exit
fi

TIMESTAMP=$(date +%H:%M)

#tail the log file to LOG_MAXLINE
if [ ! -f $LOG_FILE ]; then
	touch $LOG_FILE
else
	tail -$LOG_MAXLINE $LOG_FILE > $DIR/tmp.log && mv $DIR/tmp.log $LOG_FILE
fi

for i in "$@"
do
	echo $TIMESTAMP,$i,$(awk -v interv=$INTERVAL '{if(l1){print ($2-l1)/1024/interv","($10-l2)/1024/interv} else{l1=$2; l2=$10;}}' <(grep $i /proc/net/dev) <(sleep $INTERVAL; grep $i /proc/net/dev)) >> $LOG_FILE
done

