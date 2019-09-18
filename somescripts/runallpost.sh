#!/bin/bash 


filename='/home/akubo/myprojects/channelized-pdcs/readyforpost.txt'


cat $filename
echo 

while read line; do 
	echo $line
	cd $line
	makepost.sh  

done < $filename

