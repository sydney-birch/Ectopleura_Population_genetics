# Workflow for Ectopleura ddRAD analysis

For the stacks work, I'm using two tutorials: https://github.com/ascheben/RAD_analysis_workflow/tree/master  
https://catchenlab.life.illinois.edu/stacks/comp/process_radtags.php   

## Prep work: 
  A) Download data and count the number of reads in the fastq files 
  `sbatch 0_count_reads_in_zipped_fastqs.slurm` This runs --> `./0_count_reads_in_zipped_fastqs.py -a raw_reads_2-19-26`
  *Side Note: don't chage the name of the fastq files - Stacks will use the raw read names during demultiplexing and will adjust read names*

## 1. Demultiplex and Quality Check reads using Stacks 2 

  A) Demultiplex
  - We used SphI-EcoRI enzyme pairs for our double digest and the data is paired-end with indexed barcodes on the single and paired-ends    
  - Make a barcodes.txt file of your sample names to barcodes:
    ```
    ATTAC	ACTCGCTA	CML_ddRAD_4
    CATAT	ACTCGCTA	CML_ddRAD_5
    CGAAT	ACTCGCTA	York_ddRAD_14
    CGGCT	ACTCGCTA	York_ddRAD_6
    CGGTA	ACTCGCTA	Wells_ddRAD_12
    CGTAC	ACTCGCTA	Wells_ddRAD_11
    ```
 - Run demultiplex script:  
  `sbatch 1.A_demutliplex_stacks.slurm` This runs --> `process_radtags -P -p ../../Ecto_ddRAD_raw_reads_2-19-26 -o ./demultiplex_output -b barcodes.txt -r -c -q --index-index --renz-1 sphI --renz-2 ecoRI`   
 - Get counts on demultiplexed reads:
 `sbatch 1_count_reads_in_zipped_fastqs.slurm` this runs --> `./1_count_reads_in_zipped_fastqs.py -a demultiplex_output`

B) Trimmomatic - Remove adapters
- Submit the slurm script which will run a bash loop to submitt all samples to trimmomatic
  `sbatch 1.B_trimmomatic.slurm` this runs -->
```
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
```
- Change the names of the trimmed reads so its easier to work with:
  `./1.C_change_trimm_fq_names.py -b trimmomatic/` 
- Then move unneeded files to a new dir
  ```
  mkdir trimm_files_not_needed
  mv *U.fq.gz trimm_files_not_needed/
  mv *.rem_* trimm_files_not_needed/
  ```
- Get counts of trimmed reads
  `sbatch 1_count_reads_in_zipped_fastqs.slurm` this runs --> `./1_count_reads_in_zipped_fastqs.py -a 1.B_trimmomatic`

C) Run FastQC and multiQC to check quality of trimmed reads
- Submit the slurm to loop through the trimmed reads and then generatate a report of all fastqc results
  `sbatch 1.D_fastqc.slurm`
  
D) Run Mash - a kmer based analysis of genetic distance between samples (a QC step)  
(Download: `wget https://github.com/marbl/Mash/releases/download/v2.3/mash-Linux64-v2.3.tar`)
- First make a sketch for each sample
  1.E_mash.slurm: `for sample in ./1.B_trimmomatic/*.fq; do ./mash-Linux64-v2.3/mash sketch -r -m 4 -s 1000 ${sample};done`
- Next estimate the distance between each pair of sketches
  ```
  for sample_x in ./1.B_trimmomatic/*.1.fq.gz.msh; do  
    for sample_y in ./1.B_trimmomatic/*.1.fq.gz.msh; do  
        ./mash-Linux64-v2.3/mash  dist ${sample_x} ${sample_y}  
    done  
  done > All_Distances.txt
  ```
- Then check pvalues and remove columns not needed for R input
  `cut -f1-3 All_Distances.txt > Distances.txt`
- In R plot a tree based on the mash distance matrix:
  ```
  #load library
  library("phangorn")
   
  a <- read.table("Distances.txt", stringsAsFactors=F, sep="\t")  
  matrix <- reshape(a, direction="wide", idvar="V2", timevar="V1")  
  distance <- as.dist(matrix[,-1], upper=F, diag=F)  
  attr(distance, "Labels") <- matrix[,1]  
  plot(upgma(distance),cex = 0.5)  
  add.scale.bar(ask = TRUE)
  ```

## 2. De novo assembly and SNP calling using stacks
In this section we will work through the core pipeline of Stacks    

A) Cluster reads into unique stacks with ustack 
  - First run script to generate individual lines of code to submit:
    `./2.A_make_ustack_line.py -b ../1_demultiplex_QC/1.B_trimmomatic`
  - Then sbach slurm:  
2.A_ustack.slurm:
```
ustacks -o ./stack_outputs -m 3 -M 1 -i gzfastq -f ../1_demultiplex_QC/1.B_trimmomatic/CML_ddRAD_filtered_4.1.fq.gz -t 16 --force-diff-len
ustacks -o ./stack_outputs -m 3 -M 1 -i gzfastq -f ../1_demultiplex_QC/1.B_trimmomatic/CML_ddRAD_filtered_5.1.fq.gz -t 16 --force-diff-len
ustacks -o ./stack_outputs -m 3 -M 1 -i gzfastq -f ../1_demultiplex_QC/1.B_trimmomatic/York_ddRAD_filtered_14.1.fq.gz -t 16 --force-diff-len
ustacks -o ./stack_outputs -m 3 -M 1 -i gzfastq -f ../1_demultiplex_QC/1.B_trimmomatic/York_ddRAD_filtered_6.1.fq.gz -t 16 --force-diff-len
ustacks -o ./stack_outputs -m 3 -M 1 -i gzfastq -f ../1_demultiplex_QC/1.B_trimmomatic/Wells_ddRAD_filtered_12.1.fq.gz -t 16 --force-diff-len
ustacks -o ./stack_outputs -m 3 -M 1 -i gzfastq -f ../1_demultiplex_QC/1.B_trimmomatic/Wells_ddRAD_filtered_11.1.fq.gz -t 16 --force-diff-len
```

  - Next run script to fix the names of the output files so it will match the popmap file:
`./2.A.2_fix_output_names.py -b stack_outputs/`

B) Run cstack slurm with popmap file
  - pop map file:
    ```
    CML_ddRAD_filtered_4    pop1
    CML_ddRAD_filtered_5    pop1
    York_ddRAD_filtered_14  pop2
    York_ddRAD_filtered_6   pop2
    Wells_ddRAD_filtered_12 pop3
    Wells_ddRAD_filtered_11 pop3
    ```
- Submit slurm script: 2.B_cstack.slurm
  `cstacks -P ./stack_outputs -M ./popmaps/popmap4 -t 8 `

C) Run sstack slurm with popmap file 
2.C_sstack.slurm: `sstacks -P ./stack_outputs -M ./popmaps/popmap4 -t 8 `   

D) Run tsv2bam with popmap file
2.D_tsv2bam.slurm: `tsv2bam -P ./stack_outputs --pe-reads-dir ../1_demultiplex_QC/1.B_trimmomatic -M ./popmaps/popmap4 -t 8`   

E) Run gstack with popmap file
2.E_gstack.slurm: `gstacks -P ./stack_outputs -M ./popmaps/popmap4 -t 8`

F) Export genotype data into standard formts to filter in next step
2.F_populations.slurm: `populations -P ./stack_outputs -M ./popmaps/popmap4 -t 8 --vcf`
  - output dir: populations_standard

testing other things (filtering snps): 
```
#Output data for STRUCTURE and in the GenePop format. Only write the first SNP from any RAD locus, to prevent linked data from being processed by STRUCTURE:
populations -P ./stack_outputs --popmap ./popmaps/popmap4 -p 3 -r 0.75 -f p_value -t 8 --structure --genepop --write-single-snp
    ## Output dir = populations_structure

## Based on Magris et al 2022 paper - snp filtering included
populations -P ./stack_outputs --popmap ./popmaps/popmap4 -p 3 -r 0.75 -f p_value -t 8 --max-obs-het 0.8 --structure --genepop --vcf --plink --treemix --hzar --write-single-snp
   ## Output dir = populations_filt_magris
```

## 3. Use PLINK for SNP QC 
following plink tutorial: https://cloufield.github.io/GWASTutorial/04_Data_QC/#qc-step-summary

A) Calculate sample missing rate and SNP missing rate:  
  - 3.A_plink_missing_rate.slurm `plink --bfile snps --missing --out plink_results --allow-extra-chr` 

B) Calculate allele frequency 
  - 3.B_MAF.slurm `plink --bfile snps --freq --out plink_results --allow-extra-chr`   

C) Calculate HWE (Variants with low P value usually suggest genotyping errors, or indicate evolutionary selection for these variants)
  - 3.C_HWE.slurm `plink --bfile snps --hardy --out plink_results --allow-extra-ch`

D) Apply filters - filter out low quality SNPS and Linkage disequlibrium SNPs
  - 3.D_LD_filt.slurm: `plink --bfile snps --maf 0.01 --geno 0.02 --mind 0.02 --hwe 1e-6 --indep-pairwise 50 5 0.2 --out plink_results --allow-extra-chr`

E) Check heterozygosity
  - 3.E_hetroz.slurm: `plink --bfile snps --extract ./plink_results/plink_results.prune.in --het --out plink_results --allow-extra-chr`

F) Convert filtered data into a bed file:
  - 3.F_convert_file.slurm: `plink --bfile snps --extract ./plink_results/plink_results.prune.in --make-bed --out plink_pruned --allow-extra-chr`






  
