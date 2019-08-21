#!/bin/bash 

tline=$(grep "Time" run.out | tail -1)
tim=${tline%Dt*}
tim=${tim##*=}
echo "RUN TIME IN SECONDS $tim"
tim=${tim%.*}
steps=$(( $tim/ 5)) 
echo "TIMESTEPS $steps"

echo $steps 
