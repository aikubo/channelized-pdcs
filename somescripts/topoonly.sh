#!/bin/bash 


ifort -c -convert big_endian postmod.f90
ifort -c -convert big_endian constants.f90 
ifort -c -convert big_endian openbin.f90 
ifort -c -convert big_endian allocate_arrays.f90
ifort -c -convert big_endian handletopo.f90 
ifort -c -convert big_endian openascii.f90
ifort -c -convert big_endian var_3d.f90
ifort -c -convert big_endian formatmod.f90

ifort formatmod.o postmod.o constants.o openascii.o allocate_arrays.o handletopo.o topoonly.f90  -convert big_endian -o topo.exe 

