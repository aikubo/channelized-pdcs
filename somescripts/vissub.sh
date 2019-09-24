#!/bin/bash

#SBATCH --partition=dufek     ### Partition/queue name specific to our group
#SBATCH --job-name=conv_AV4
#SBATCH --output=post.out   ### file in which to store job stdout, edit for a your case
#SBATCH --error=post.err    ### file in which to store job stderr, edit for your case
#SBATCH --time=03:00:00      ### WallTime (maximum running time)
#SBATCH --nodes=1           ### Number of Nodes
#SBATCH --ntasks-per-node=1 ### Number of tasks -- this is set for a single core executable
#SBATCH --mem-per-cpu=24G
#SBATCH -A dufeklab

### Put your executable name here
module load OpenDX 

onevis.sh

cut_man.sh

checkcompletepost.sh
