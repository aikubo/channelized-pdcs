#!/bin/bash 

while true; do

	echo what directory should I look into?
	echo respond /home/akubo/myprojects/...
			
	read response

	response2="/home/akubo/myprojects/$response"

	echo $response2
	
	echo confirm /...
	read response1 

	echo $response1
	
	file1="average_all_$response1"

	cp $response2/average_all.txt ~/myprojects/collected/$file1

	file2="average_dense_$response1"
	cp $response2/average_dense.txt ~/myprojects/collected/$file2

	file3="average_medium_$response1"
	cp $response2/average_medium.txt ~/myprojects/collected/$file3

	file4="massinchannel_$response1"
	cp $response2/massinchannel.txt ~/myprojects/collected/$file4

	file5="EP_G_sum1_$response1"
	cp $response2/EP_G_sum1 ~/myprojects/collected/$file5

	file6="EP_G_sum2_$response1"
	cp $response2/EP_G_sum2 ~/myprojects/collected/$file6

	file7="EP_G_sum3_$response1"
	cp $response2/EP_G_sum3 ~/myprojects/collected/$file7

	echo anymore files to transfer? Y/N
	read response2
	if [ "$response2" == 'N' ];then
		break
	fi 
done
