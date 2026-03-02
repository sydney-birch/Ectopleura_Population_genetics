# Workflow for Ectopleura ddRAD analysis

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

