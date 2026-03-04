#!/bin/bash

#SBATCH --partition=Orion
#SBATCH --job-name=demultip
#SBATCH --nodes=1
#SBATCH --mem=400GB
##SBATCH --ntasks-per-node=12
#SBATCH --time=96:00:00

##Load modules
module load stacks/2.68 

## Run process_radtags from Stacks
##process_radtags -i gzfastq -P -1 CML_ddRAD_4_S1_L002_R1_001.fastq.gz -2 CML_ddRAD_4_S1_L002_R2_001.fastq.gz -o . -b barcodes.txt -r -c -q --index_index --renz_1 sphI --renz_2 ecoRI

## run a loop to processes all samples for demultiplexing
##for F in ../raw_reads_2-19-26/*.1.fq.gz; do 
##    echo "current file:  $F"
##    R="${F%.1.fq.gz}.2.fq.gz"
##    echo "R: $R"
##    BASE=${F##*/}
##    echo "Base: $BASE"
##    SAMPLE=${BASE%_*}
##    echo "Sample: $SAMPLE"
##    echo "line of code: process_radtags -i gzfastq -P -1 $F -2 $R -o . -b barcodes.txt -r -c -q --index_index --renz_1 sphI --renz_2 ecoRI"
##    process_radtags -i gzfastq -P -1 $F -2 $R -o . -b barcodes.txt -r -c -q --index_index --renz_1 sphI --renz_2 ecoRI
##    echo "moving to next sample" &
##done

## Run py script for process_radtags
##./1.A_demutliplex_stacks.py -b ../raw_reads_2-19-26


## Run the individual code - output from 1.A_demutliplex_stacks_v2.py

##process_radtags -i gzfastq -P -1 ../raw_reads_2-19-26/CML_ddRAD_S4.1.fq.gz -2 ../raw_reads_2-19-26/CML_ddRAD_S4.2.fq.gz -o ./demultiplex_output -b barcodes.txt -r -c -q --index_index --renz_1 sphI --renz_2 ecoRI
##mv demultiplex_output/process_radtags.log demultiplex_output/CML_ddRAD_S4-process_radtags.log

##process_radtags -i gzfastq -P -1 ../raw_reads_2-19-26/CML_ddRAD_S5.1.fq.gz -2 ../raw_reads_2-19-26/CML_ddRAD_S5.2.fq.gz -o ./demultiplex_output -b barcodes.txt -r -c -q --index_index --renz_1 sphI --renz_2 ecoRI
##mv demultiplex_output/process_radtags.log demultiplex_output/CML_ddRAD_S5-process_radtags.log

##process_radtags -i gzfastq -P -1 ../raw_reads_2-19-26/Wells_ddRAD_S11.1.fq.gz -2 ../raw_reads_2-19-26/Wells_ddRAD_S11.2.fq.gz -o ./demultiplex_output -b barcodes.txt -r -c -q --index_index --renz_1 sphI --renz_2 ecoRI
##mv demultiplex_output/process_radtags.log demultiplex_output/Wells_ddRAD_S11-process_radtags.log

##process_radtags -i gzfastq -P -1 ../raw_reads_2-19-26/Wells_ddRAD_S12.1.fq.gz -2 ../raw_reads_2-19-26/Wells_ddRAD_S12.2.fq.gz -o ./demultiplex_output -b barcodes.txt -r -c -q --index_index --renz_1 sphI --renz_2 ecoRI
##mv demultiplex_output/process_radtags.log demultiplex_output/Wells_ddRAD_S12-process_radtags.log

##process_radtags -i gzfastq -P -1 ../raw_reads_2-19-26/York_ddRAD_S14.1.fq.gz -2 ../raw_reads_2-19-26/York_ddRAD_S14.2.fq.gz -o ./demultiplex_output -b barcodes.txt -r -c -q --index_index --renz_1 sphI --renz_2 ecoRI
##mv demultiplex_output/process_radtags.log demultiplex_output/York_ddRAD_S14-process_radtags.log

##process_radtags -i gzfastq -P -1 ../raw_reads_2-19-26/York_ddRAD_S6.1.fq.gz -2 ../raw_reads_2-19-26/York_ddRAD_S6.2.fq.gz -o ./demultiplex_output -b barcodes.txt -r -c -q --index_index --renz_1 sphI --renz_2 ecoRI
##mv demultiplex_output/process_radtags.log demultiplex_output/York_ddRAD_S6-process_radtags.log

## Try running one line of code
process_radtags -P -p ../../Ecto_ddRAD_raw_reads_2-19-26 -o ./demultiplex_output -b barcodes.txt -r -c -q --index-index --renz-1 sphI --renz-2 ecoRI
