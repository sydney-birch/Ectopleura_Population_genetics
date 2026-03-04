#! /usr/bin/env python3

#import modules 
import argparse
import subprocess
import os
import gzip


#create an instance of Argument Parser and add positional argument 
parser = argparse.ArgumentParser()
parser.add_argument("-b", help="directory to navigate to with fastq files")
args = parser.parse_args()

# run process radtags on the paired end samples

# Structure of files: 
# Wells_ddRAD_S12.1.fq.gz

def process_radtags(read_dir):
    os.chdir(read_dir)
    code_list = []
    for item in os.scandir():
        
        if ".1.fq" in item.name: 
            print("R1 sample: ", item.name)
            
            sp_name = item.name.split(".")
            print ("split name: ", sp_name)
            
            temp_list = []
            temp_list.append(sp_name[0])
            temp_list.append("2")
            temp_list.append(sp_name[2])
            temp_list.append(sp_name[3])
            
            print("temp list: ", temp_list)

            print("line: ustacks -o ./2.A_ustack_output -m 3 -M 1 -i gzfastq -f ../1_demultiplex_QC/1.B_trimmomatic/{0} -t 16 --force-diff-len".format(item.name))
            code_line = "ustacks -o ./2.A_ustack_output -m 3 -M 1 -i gzfastq -f ../1_demultiplex_QC/1.B_trimmomatic/{0} -t 16 --force-diff-len".format(item.name)
            code_list.append(code_line)
        elif ".2.fq" in item.name: 
            continue

    #write out code to put in slurm
    with open("ustack_code_to_run.txt", "w") as out_handel:
        for line in code_list:
            out_handel.write("{0}\n".format(line))

#call function
result_1 = process_radtags(args.b)  
