# *Ectopleura* Population Genetic Study - Overview
This repository contains the ddRAD analysis of three *Ectopleura* populations for my NSF PRFB study. This repository also includes the code for the behavioral analysis and the  correlational analysis. 

## Study Info and Sample structure
The overarching hypothesis of my PRFB work is: Distinct populations of E. crocea are larvae are locally adapted to specfic biofilms, where larvae are cueing in on adult-associated microbes. 

This ddRAD study is apart of Aim 2 which is assessing the population genomics of E.crocea to assess if genetic variation is present across populations and if its consitent with local adaptation. 

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
