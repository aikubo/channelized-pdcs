#!/bin/bash 


filename='simulationsran.txt'


cat $filename
echo what script would you like to run in these directories
read scrpt 

while read line; do 
	echo $line
	cd $line
	$scrpt  

done < $filename

