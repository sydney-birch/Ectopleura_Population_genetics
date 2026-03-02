# Ectopleura_Population_genetics
This repository contains the ddRAD analysis of three *Ectopleura* populations for my NSF PRFB study. This repository also includes the code for the behavioral analysis and the  correlational analysis. 

## Study Info and Sample structure

## Overview of Pipeline: 
1. Download data and prep work (count reads)
2. Demultiplex reads using Stacks2
3. Trimm Adapters using Trimmommatic
4. Run FastQC to assess quality of reads
5. Run MASH to assess genetic distances between samples
6. Run Stacks2 Core pipeline with de novo assembly (ustacks, cstacks, sstacks, tsv2bam, gstacks)
7. Run populations from Stacks2 to export genotype data to vcf and plink formats
8. Run PLINK to QC the genotype data
   - calc missing rate
   - calculate allele frequency
   - HWE
   - Filter out low quality SNPS and LD SNPs
   - Calculate Heterozygosity
9. Generate a PCA 
