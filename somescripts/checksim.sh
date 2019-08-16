#!/bin/bash 

runlength=$(wc -l run.out)
length=${runlength:0:3}

echo $length 

if [ "$length" -lt 699  ]; then 
	print "still in set up"
fi
