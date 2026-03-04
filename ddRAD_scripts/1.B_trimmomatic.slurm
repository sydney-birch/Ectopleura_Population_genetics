#!/bin/bash

#SBATCH --partition=Orion
#SBATCH --job-name=trimm
#SBATCH --nodes=1
#SBATCH --mem=400GB
##SBATCH --ntasks-per-node=12
#SBATCH --time=96:00:00

##Load modules
module load stacks/2.68 
module load trimmomatic/

## Run trimmommatic

## run a loop to processes all samples for demultiplexing
for F in demultiplex_output/*.1.fq.gz; do 
    echo "current file:  $F"
    R="${F%.1.fq.gz}.2.fq.gz"
    echo "R: $R"
    
    BASE=${F##*/}
    BASE="${BASE%.1.fq.gz}"
    echo "Base: $BASE"
    OUT="${BASE}_filtered.fq.gz"

    echo "line of code: java -jar /apps/pkg/trimmomatic/0.39/trimmomatic-0.39.jar PE -phred33 -threads 4 $F $R -baseout $OUT ILLUMINACLIP:/apps/pkg/trimmomatic/0.39/adapters/TruSeq3-PE-2.fa:2:30:10  MINLEN:120"
    java -jar /apps/pkg/trimmomatic/0.39/trimmomatic-0.39.jar PE -phred33 -threads 4 $F $R -baseout $OUT ILLUMINACLIP:/apps/pkg/trimmomatic/0.39/adapters/TruSeq3-PE-2.fa:2:30:10  MINLEN:120
    echo "moving to next sample" &
done
