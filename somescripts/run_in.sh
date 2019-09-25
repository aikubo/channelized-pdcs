#!/bin/bash 


filename='readyforpost.txt'


cat $filename
echo what script would you like to run in these directories
read scrpt 

while read line; do 
	echo $line
	cd $line
	$scrpt  

done < $filename

sleep 15m

while read line; do
        echo $line
        cd $line
	cp *.txt  /home/akubo/myprojects/channelized-pdcs/graphs/processed
done < $filename

cd /home/akubo/myprojects/channelized-pdcs/graphs/processed
rm EP_P*
rm U_G* 

git add *.txt
gitadd.sh
git commit -m "reran post"
git push

