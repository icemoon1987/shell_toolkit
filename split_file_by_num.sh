#!/usr/bin/bash

######################################################
#
# File Name:	split_file_by_num.sh
#
# Function:		split a file by file num
#
# Usage:		bash ./split_file_by_num.sh FILE_NAME FILE_NUM
#
# Input:		FILE_NAME: source file
#				LINE_NUM_PER_PART: line num for each result parts
#
# Output:
#
# Author:		panwenhai
#
# Create Time:  2016-08-23 15:25:32
#
######################################################

file_name=$1
file_num=$2

if [ $# -ne 2 ]; then
    echo "USAGE: ./split_file_by_line FILE_NAME file_num"
    exit 1
fi

echo $file_name
echo $file_num

line_num=`wc -l $file_name | awk '{print $1}'`
((line_num=line_num/$file_num+1))

# Split File
echo "Spliting file ..."
split -l $line_num $file_name ${file_name}_part_

# Rename result files
echo "Renaming result files ..."
index=1
for file in ${file_name}_part_*; do
    echo "rename "$file" to "${file_name}_part_${index}
    mv $file ${file_name}_part_${index}
    ((index++))
done

# Add EOF to result files
#echo "Add EOF to result files ..."
#for file in ${file_name}_part_*; do
    #tail $file | grep "EOF"

    #if [ $? -ne 0 ]; then
        #echo "add EOF to "$file
        #echo "EOF" >> $file
    #fi
#done


