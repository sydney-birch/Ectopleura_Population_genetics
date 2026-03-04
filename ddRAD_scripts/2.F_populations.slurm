#!/bin/bash

#SBATCH --partition=Orion
#SBATCH --job-name=ustack
#SBATCH --nodes=1
#SBATCH --mem=400GB
##SBATCH --ntasks-per-node=12
#SBATCH --time=96:00:00

##Load modules
module load stacks/2.68 

## Run populations - making basic vcf file 
##populations -P ./stack_outputs -M ./popmaps/popmap4 -t 8 --vcf

##Output data for STRUCTURE and in the GenePop format. Only write the first SNP from any RAD locus, to prevent linked data from being processed by STRUCTURE:
##populations -P ./stack_outputs --popmap ./popmaps/popmap4 -p 3 -r 0.75 -f p_value -t 8 --structure --genepop --write-single-snp


## Based on Magris et al 2022 paper - snp filtering included
populations -P ./stack_outputs --popmap ./popmaps/popmap4 -p 3 -r 0.75 -f p_value -t 8 --max-obs-het 0.8 --structure --genepop --vcf --plink --treemix --hzar --write-single-snp
