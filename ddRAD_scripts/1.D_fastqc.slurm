#!/bin/bash

#SBATCH --partition=Orion
#SBATCH --job-name=qc
#SBATCH --nodes=1
#SBATCH --mem=400GB
##SBATCH --ntasks-per-node=12
#SBATCH --time=96:00:00

##Load modules
module load stacks/2.68 
module load fastqc
module load multiqc/

## Run fastqc
for sample in ./trimmomatic/*.fq.gz; do fastqc ${sample};done

## Generate report of all fastqc output 
multiqc trimmomatic/
