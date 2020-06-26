#!/bin/bash

echo "which files would you like to rename"
read files

label=${PWD##*/}
echo $label
for f in $files
do
    mv "$f" "$label$f"
done
