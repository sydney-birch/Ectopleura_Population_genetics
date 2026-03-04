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
# Wells_ddRAD_12_filtered_1P.fq.gz

#Step 1: make dictionary from input file of file names to change 

def name_change(trim_dir):
    os.chdir(trim_dir)

    for item in os.scandir():
        #line = line.rstrip()
        
        if "filtered.1.fq.gz" in item.name: 
            print("Paired R1 sample: ", item.name)
            
            sp_name = item.name.split("_")
            print ("split name: ", sp_name)
            
            temp_list = []
            temp_list.append(sp_name[0])
            temp_list.append(sp_name[1])
            temp_list.append("filtered")
            temp_list.append(sp_name[3])
            
            print("temp list: ", temp_list)
            temp_join = "_".join(temp_list)
            
            #temp_list2 = []
            #temp_list2.append(temp_join)
            #temp_list2.append("1.fq.gz")
            
            #new_name = ".".join(temp_list2)
            print("New Name: ", temp_join)
            
            print("line: mv {0} {1}".format(item.name, temp_join))
            result = subprocess.run("mv {0} {1}".format(item.name, temp_join), shell=True)
        
        elif "filtered.2.fq.gz" in item.name: 
            print("Paired R2 sample: ", item.name)
            
            sp_name = item.name.split("_")
            print ("split name: ", sp_name)
            
            temp_list = []
            temp_list.append(sp_name[0])
            temp_list.append(sp_name[1])
            temp_list.append("filtered")
            temp_list.append(sp_name[3])
            
            print("temp list: ", temp_list)
            temp_join = "_".join(temp_list)
            
            #temp_list2 = []
            #temp_list2.append(temp_join)
            #temp_list2.append("2.fq.gz")
            
            #new_name = ".".join(temp_list2)
            print("New Name: ", temp_join)
            
            print("line: mv {0} {1}".format(item.name, temp_join))
            result = subprocess.run("mv {0} {1}".format(item.name, temp_join), shell=True)        

#call function
result_1 = name_change(args.b) 
