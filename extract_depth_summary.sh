#!/bin/bash -l
#$ -l h_rt=12:00:00
#$ -cwd
#$ -pe smp 1


full_infile_path=$1
sample=$2
outdir=$3
chr=$4

ext1="_cov_summary.txt"

# GET TOTAL BASES COVERED >1 READ
nonZeros=$(less $full_infile_path | grep $chr | awk -F"\t" '{print $NF }' | grep -v "\b0\b" | wc -l)
# GET TOTAL BASES NOT COVERED
zeros=$(less $full_infile_path | grep $chr | awk -F"\t" '{print $NF }' | grep "\b0\b" | wc -l)
# GET TOTAL NUMBER OF SEQUENCED BASES
total_seq_bases=$(less $full_infile_path | grep $chr | awk -F"\t" '{print $NF }' | grep -v "\b0\b" | xargs du -c | tail -1 | awk '{print $1}')


# PRINT METRICS TO OUTFILE
echo $chr $nonZeros $zeros $total_seq_bases >> $outdir/$sample$ext1
