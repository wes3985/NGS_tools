#!/bin/bash -l
#$ -l h_rt=12:00:00
#$ -cwd
#$ -pe smp 12

prefix=$1
infile=$2
outdir=$3

# prefix = a simple prefix to label intermediate files and the outfile with
# infile = the full path to the input bam
# outdir = the directory which the outfile will be written to



ext=".sorted.bam"

module load samtools/1.3.1/gnu-4.9.2

samtools sort -@ 12 -T $prefix -o $outdir/$prefix$ext $infile

samtools index $outdir/$prefix$ext
