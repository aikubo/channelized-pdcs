#!/bin/bash
sims='readyforpost.txt'

declare -a files=( "KE" "KEbyx" "PE " "PEbyx " "average_all" "average_medium" \
> "average_dense" "cross_stream" "dpu_peak" "edge_vel1" "edge_vel2" "entrainment" "froude" "intmass" "massbyxx" \
> "massinchannel" "nose" "perpvel" "perpvelbyx" "slice_3quarter_100m" "slice_halfl" "slice_middle" "slice_onel")

cat $sims 
while read line; do 
    echo $line  
    cd /home/akubo/myprojects/channelized-pdcs/graphs/processed
    label=${PWD##*/}

    for name in "${StringArray[@]}"; do
        filename="{$label}"
        filename+="_"
        filename+="{$name}"
        filename+=".txt"
        print $filename

        if [ -s "$filename" ] then
            echo " $filename file exists and is not empty "
        else
            echo "$filename missing"
            echo -e "$filename" >> /home/akubo/myprojects/channelized-pdcs/missing.txt
        fi 

    done 
done


