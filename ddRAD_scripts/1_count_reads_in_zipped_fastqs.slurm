#!/bin/bash

#SBATCH --partition=Orion
#SBATCH --job-name=count_reads
#SBATCH --nodes=1
#SBATCH --mem=400GB
##SBATCH --ntasks-per-node=12
#SBATCH --time=96:00:00

##Load modules

## Run count reads script 

## 1.A demultiplexed reads
##./1_count_reads_in_zipped_fastqs.py -a demultiplex_output

## 1.B trimmed reads
./1_count_reads_in_zipped_fastqs.py -a trimmomatic

