#!/bin/bash -l
#$ -l h_rt=6:00:00
#$ -cwd
#$ -pe smp 6

bam_path=$1
bam_out=$2
excluded_regions=$3

echo $bam_path
module load samtools/1.3.1
samtools view -b -h $bam_path -U $bam_out.excluded -L $excluded_regions -@ 6 -o $bam_out
