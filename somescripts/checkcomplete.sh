#!/bin/bash

datum=$(date +"%D %R")
runline=$(grep "job" status.txt | tail -1)
runline=${runline%for*}
job=${runline##*job}

echo $runline 

status=$(sh ifcomplete.sh $job)

if [ "$status" == 'COMPLETED COMPLETED COMPLETED' ]; then 
	echo $status
	echo ":-D"
           
	echo -e "$datum Batch job $job $status" >> status.txt 
	echo -e "$datum Batch job $job $status" >> /home/akubo/myprojects/channelized-pdcs/status_all.txt
else 
	echo "incomplete check output" 
	echo ":-0"
	echo -e "$datum completion issue with batch job $job :: $status" >> status.txt
	echo -e "$datum completion issue with batch job $job :: $status" >> /home/akubo/myprojects/channelized-pdcs/status_all.txt
fi

echo $status

echo ":-D"
