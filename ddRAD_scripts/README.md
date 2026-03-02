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

  
