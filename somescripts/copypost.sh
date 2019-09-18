#!/bin/bash 


filename='/home/akubo/myprojects/channelized-pdcs/readyforpost.txt'


cat $filename
echo 

while read line; do 
	echo $line
	cd $line
	cp *txt /home/akubo/myprojects/channelized-pdcs/graphs/processed/  
	cp *tiff /home/akubo/myprojects/channelized-pdcs/graphs/processed/

done < $filename

