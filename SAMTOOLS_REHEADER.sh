#!/bin/bash -l
#$ -l h_rt=12:00:00
#$ -cwd
#$ -pe smp 1

inheader=$1
inbam=$2
prefix=$3
outpath=$4
ext=".reheader.bam"

# inbam = the full path to the input bam
# inheader =  full path to new header file

module load samtools/1.3.1/gnu-4.9.2

echo "start"
samtools reheader $inheader $inbam > $outpath/$prefix$ext
echo "end"
