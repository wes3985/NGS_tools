#!/bin/bash -l
#$ -l h_rt=6:00:00
#$ -cwd
#$ -pe smp 6

bam_path=$1
bam_out=$2

echo $bam_path
module load samtools/1.3.1
samtools view -bq 10 -@ 6 $bam_path > $bam_out

