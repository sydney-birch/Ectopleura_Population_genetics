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

# renames the fastq files after trimmommatic

# Structure of files: 
# CML_ddRAD_filtered_5.1.tags.tsv.gz

#Step 1: make dictionary from input file of file names to change 

def name_change(trim_dir):
    os.chdir(trim_dir)

    for item in os.scandir():
        #line = line.rstrip()
        
        if ".1." in item.name: 
            print("sample: ", item.name)
            
            sp_name = item.name.split(".")
            print ("split name: ", sp_name)
            
            temp_list = []
            temp_list.append(sp_name[0])
            temp_list.append(sp_name[2])
            temp_list.append(sp_name[3])
            temp_list.append(sp_name[4])
            
            print("temp list: ", temp_list)
            temp_join = ".".join(temp_list)
            
            print("New Name: ", temp_join)
            
            print("line: mv {0} {1}".format(item.name, temp_join))
            result = subprocess.run("mv {0} {1}".format(item.name, temp_join), shell=True)

#call function
result_1 = name_change(args.b) 
