#!/bin/bash 
for i in BV*
do
    mv "$i" "${i/BV/EV}"
done
