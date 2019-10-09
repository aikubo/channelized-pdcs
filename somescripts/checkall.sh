#!/bin/bash
checkdir () {
	for D in *; do
    		if [ -d "${D}" ]; then
        		echo "${D}"   # your processing here
			cd ${D} 
			checkcomplete.sh
			#echo -e "${D}" >> /home/akubo/myprojects/channelized-pdcs/readyforpost.txt
    			cd ../
		fi
	done
}


cd /home/akubo/myprojects 

cd /home/akubo/myprojects/4_INFLOW/
checkdir

cd /home/akubo/myprojects/7_INFLOW/
checkdir

