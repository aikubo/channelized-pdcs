#!/bin/bash

jobid=$1

status=$(sacct -j $jobid --format=state)
status=${status##*-}

echo $status

