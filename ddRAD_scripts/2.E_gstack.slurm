#!/bin/bash

#SBATCH --partition=Orion
#SBATCH --job-name=ustack
#SBATCH --nodes=1
#SBATCH --mem=400GB
##SBATCH --ntasks-per-node=12
#SBATCH --time=96:00:00

##Load modules
module load stacks/2.68 

## Run ustacks 
gstacks -P ./stack_outputs -M ./popmaps/popmap4 -t 8  
