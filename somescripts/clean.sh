#!bin/bash 


# program removes extraneous files 
for D in ./*; do
    if [ -d "$D" ]; then
        cd "$D"
        rm scr* 
	
	
        cd ..
    fi
done
