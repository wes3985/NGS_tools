#!/bin/bash -l
#$ -l h_rt=6:00:00
#$ -cwd
#$ -pe smp 1

file1=$1
file2=$2

# append file2 to the end of file1
cat $file2 >> $file1
