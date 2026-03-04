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
plink --bfile snps --maf 0.01 --geno 0.02 --mind 0.02 --hwe 1e-6 --indep-pairwise 50 5 0.2 --out plink_results --allow-extra-chr
