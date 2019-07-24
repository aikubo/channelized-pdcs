#!/bin/bash 


ifort -c postmod.f90
ifort -c constants.f90 

ifort postmod.o constants.o advtest.f90 -o test.exe


./test.exe
