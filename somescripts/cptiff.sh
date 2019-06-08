#!/bin/sh

###ifort convert_KIL.f90 -convert big_endian -o converter.exe
###./converter.exe

module load OpenDX

#echo sim name 
cd $1

#mkdir ~/myprojects/graphics/visuals/$name
cp *tif* ~/myprojects/graphics/visuals/$name


