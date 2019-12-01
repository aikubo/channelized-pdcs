#!/bin/bash

#SBATCH --partition=dufek     ### Partition/queue name specific to our group
#SBATCH --job-name=conversion0  ### Job Name -- can make this specific to your program
#SBATCH --output=post.out   ### file in which to store job stdout, edit for a your case
#SBATCH --error=post.err    ### file in which to store job stderr, edit for your case
#SBATCH --time=03:00:00      ### WallTime (maximum running time)
#SBATCH --nodes=1           ### Number of Nodes
#SBATCH --ntasks-per-node=1 ### Number of tasks -- this is set for a single core executable
#SBATCH --mem-per-cpu=20G
#SBATCH -A dufeklab

./wo.exe   ### Put your executable name here



#checkcompletepost.sh
