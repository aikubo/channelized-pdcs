#!/bin/bash 


filename='/home/akubo/myprojects/channelized-pdcs/selection.txt'


cat $filename
echo what script would you like to run in these directories
read scrpt 

while read line; do 
	echo $line
	cd $line
	$scrpt  


done < $filename

