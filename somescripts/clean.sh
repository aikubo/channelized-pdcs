#!/bin/bash 


# program removes extraneous files 
for D in ./*; do
    if [ -d "$D" ]; then
        cd $D
        
	echo $D
	#rm scr* 
        #rm slurm* 
	#find . -size 0 -delete
	
	cd ..
    fi
done
