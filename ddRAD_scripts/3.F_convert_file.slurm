#!/bin/bash

#SBATCH --partition=Orion
#SBATCH --job-name=plink
#SBATCH --nodes=1
#SBATCH --mem=400GB
##SBATCH --ntasks-per-node=12
#SBATCH --time=6:00:00

##Load modules
module load stacks/2.68 
module load admixture/
module load plink/

## Run plink missing rate
plink --bfile snps --extract ./plink_results/plink_results.prune.in --make-bed --out plink_pruned --allow-extra-chr
