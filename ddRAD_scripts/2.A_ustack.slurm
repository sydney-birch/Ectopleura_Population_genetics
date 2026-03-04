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
ustacks -o ./stack_outputs -m 3 -M 1 -i gzfastq -f ../1_demultiplex_QC/1.B_trimmomatic/CML_ddRAD_filtered_4.1.fq.gz -t 16 --force-diff-len
ustacks -o ./stack_outputs -m 3 -M 1 -i gzfastq -f ../1_demultiplex_QC/1.B_trimmomatic/CML_ddRAD_filtered_5.1.fq.gz -t 16 --force-diff-len
ustacks -o ./stack_outputs -m 3 -M 1 -i gzfastq -f ../1_demultiplex_QC/1.B_trimmomatic/York_ddRAD_filtered_14.1.fq.gz -t 16 --force-diff-len
ustacks -o ./stack_outputs -m 3 -M 1 -i gzfastq -f ../1_demultiplex_QC/1.B_trimmomatic/York_ddRAD_filtered_6.1.fq.gz -t 16 --force-diff-len
ustacks -o ./stack_outputs -m 3 -M 1 -i gzfastq -f ../1_demultiplex_QC/1.B_trimmomatic/Wells_ddRAD_filtered_12.1.fq.gz -t 16 --force-diff-len
ustacks -o ./stack_outputs -m 3 -M 1 -i gzfastq -f ../1_demultiplex_QC/1.B_trimmomatic/Wells_ddRAD_filtered_11.1.fq.gz -t 16 --force-diff-len
