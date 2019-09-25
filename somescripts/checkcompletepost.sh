#!/bin/bash
datum=$(date +"%D %R")
here=$(pwd)
label=${PWD##*/}

txtfiles=$(find *txt -type f ! -size 0 | wc -l)
tifffiles=$(find *tiff -type f ! -size 0 | wc -l)

if (( $txtfiles > 11 )); then 
		echo -e "$datum $label post process created $txtfiles txt files, $tifffiles tiff" >> status.txt
        	echo -e "$datum $label post process created $txtfiles txt files, $tifffiles tiff" >> /home/akubo/myprojects/channelized-pdcs/status_all.txt
		grep -qF "$label" /home/akubo/myprojects/channelized-pdcs/postran.txt || echo -e "$here" >> /home/akubo/myprojects/channelized-pdcs/postran.txt

		echo $status
		echo "completed!"
		echo ":-D"

		cp *.txt /home/akubo/myprojects/channelized-pdcs/graphs/processed/
		cp *.tiff /home/akubo/myprojects/channelized-pdcs/graphs/visualizations/

		echo "moved to /graphs/processed/"
else 
       echo -e "$datum $label error post process created $txtfiles txt files, $tifffiles tiff" >> status.txt
       echo -e "$datum $label error post process created $txtfiles txt files, $tifffiles tiff" >> /home/akubo/myprojects/channelized-pdcs/status_all.txt

fi

#clean up 
rm scr* 
rm core*
