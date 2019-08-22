#!/bin/bash

#SBATCH --partition=dufek     ### Partition/queue name specific to our group
#SBATCH --job-name=TEST  ### Job Name -- can make this specific to your program
#SBATCH --output=run.out   ### file in which to store job stdout, edit for a your case
#SBATCH --error=error.err    ### file in which to store job stderr, edit for your case
#SBATCH --time=120:00:00      ### WallTime (maximum running time)
#SBATCH --nodes=2           ### Number of Nodes
#SBATCH --ntasks-per-node=40         ### Number of Tasks
#SBATCH -A dufeklab

module load intel/17 intel-mpi mkl
unset I_MPI_PMI_LIBRARY
export SLURM_CPU_BIND=none

mpirun -IB -np 80 ./mfix.exe

checkcomplete.sh
