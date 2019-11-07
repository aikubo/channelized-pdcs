#!/bin/bash 

#here=$(pwd)

#cp test.f90 /home/akubo/myprojects/channelized-pdcs/postprocessing/adv_post

#cd /home/akubo/myprojects/channelized-pdcs/postprocessing/adv_post
ifort -c -convert big_endian headermod.f90
ifort -c -convert big_endian richardson.f90
ifort -c -convert big_endian formatmod.f90
ifort -c -convert big_endian postmod.f90
ifort -c -convert big_endian constants.f90
ifort -c -convert big_endian openbin.f90
ifort -c -convert big_endian allocate_arrays.f90
ifort -c -convert big_endian handletopo.f90
ifort -c -convert big_endian openascii.f90
ifort -c -convert big_endian var_3d.f90
ifort -c -convert big_endian findhead.f90
ifort -c -convert big_endian entrainment.f90
ifort -c -convert big_endian massinchannel.f90
ifort -c -convert big_endian column.f90
ifort -c -convert big_endian average.f90
ifort -c -convert big_endian track.f90

ifort var_3d.o postmod.o formatmod.o headermod.o average.o column.o richardson.o massinchannel.o entrainment.o findhead.o constants.o openbin.o openascii.o allocate_arrays.o handletopo.o test.f90  -convert big_endian -o test.exe





