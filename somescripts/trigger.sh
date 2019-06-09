#!/bin/bash

# Notify the administrator of the failure using by e-mail

datum=$(date -u)
#echo "timelimit reached" | mail -s 'TALAPAS TIMELIMIT' akubo@uoregon.edu 
echo "in trigger"

echo "$datum finished run" > status.txt
