#!/bin/bash 

runlength=$(wc -l run.out)
echo $runlength

length=${runlength:0:3}
echo $length
if [ $length -lt 699]; then
        scancel $jobid
fi

