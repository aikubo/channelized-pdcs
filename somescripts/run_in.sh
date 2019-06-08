#!/bin/bash 


filename='finishedsimulations.txt'

cat ~/somescripts/$filename
echo what script would you like to run in these directories
read scrpt 

while read line; do 
	echo $line
	#cd $line
	/home/akubo/somescripts/$scrpt "$line" 

done < $filename

