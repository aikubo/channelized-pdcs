#!/bin/bash

cd ~/myprojects/channelized-pdcs/
rm graphs/processed/EP_P_t08.txt
rm graphs/processed/U_G_t08.txt
rm graphs/processed/Richardson.txt

git add *.sh
git add *.txt 
git add postprocessing/adv_post/*.f90
git add somescripts/*.sh
git add topo/*.m
git add graphs/*.py 
