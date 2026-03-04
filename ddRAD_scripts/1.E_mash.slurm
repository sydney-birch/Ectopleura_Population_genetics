#!/bin/bash

#SBATCH --partition=Orion
#SBATCH --job-name=mash
#SBATCH --nodes=1
#SBATCH --mem=400GB
##SBATCH --ntasks-per-node=12
#SBATCH --time=2:00:00

##Load modules
module load stacks/2.68 

## Run mash - make a sketch
##for sample in ./1.B_trimmomatic/*.fq.gz; do ./mash-Linux64-v2.3/mash  sketch -r -m 4 -s 1000 ${sample};done


## get distances between each pair of sketches 
for sample_x in ./1.B_trimmomatic/*.1.fq.gz.msh; do  
    for sample_y in ./1.B_trimmomatic/*.1.fq.gz.msh; do  
        ./mash-Linux64-v2.3/mash  dist ${sample_x} ${sample_y}  
    done  
done > All_Distances.txt
