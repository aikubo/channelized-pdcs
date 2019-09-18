#!/bin/bash

datum=$(date +"%D %R")
here=$(pwd)
label=${PWD##*/}


#runline=$(grep "job" status.txt | tail -1)
#runline=${runline%for*}
#job=${runline##*job}

#echo $runline 

status=$(checktime2.sh)

if (( $status > 7 )); then 
	echo $status
	echo ":-D"
           
	echo -e "$datum $label completed $status timesteps" >> status.txt 
	echo -e "$datum $label completed $status timesteps" >> /home/akubo/myprojects/channelized-pdcs/status_all.txt
	grep -qF "$here" /home/akubo/myprojects/channelized-pdcs/readyforpost.txt || echo -e "$here" >> /home/akubo/myprojects/channelized-pdcs/readyforpost.txt

else 
	echo "incomplete check output" 
	echo ":-0"
	echo -e "$datum $label ISSUE only $status timesteps" >> status.txt
	echo -e "$datum $label ISSUE only  $status timesteps" >> /home/akubo/myprojects/channelized-pdcs/status_all.txt
fi

echo $status
echo "completed!"
echo ":-D"
