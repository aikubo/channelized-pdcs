#!/bin/bash 


filename='compsim.txt'


cat $filename
echo what script would you like to run in these directories
read scrpt 

while read line; do 
	echo $line
	#cd $line
	/home/akubo/myprojects/channelized-pdcs/somescripts/$scrpt "$line" 

done < $filename

