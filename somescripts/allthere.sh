#!/bin/bash
sims='/home/akubo/myprojects/channelized-pdcs/readyforpost.txt'

declare -a files=("KE" "KEbyx" "PE" "PEbyx" "average_all" "average_medium" "average_dense" "cross_stream" "dpu_peak" "edge_vel1" "edge_vel2" "entrainment" "froude" "intmass" "massbyxxx" "massinchannel" "nose" "perpvel" "perpvelbyx" "slice_3quarter_100m" "slice_halfl" "slice_middle" "slice_onel")

cat $sims 
while read line; do 
    echo $line  

    label=${line:32} 
    echo $label 

    for name in "${files[@]}"; do
        filename=$label
        filename+="_"
        filename+=$name
        filename+=".txt"
       

	cd /home/akubo/myprojects/channelized-pdcs/graphs/processed
        if [ -s "$filename" ]; then
            echo " $filename file exists and is not empty "
        else
            echo "$filename missing"
            echo -e "$filename" >> /home/akubo/myprojects/channelized-pdcs/missing.txt
        fi 

    done 
done < $sims


