#!/bin/bash -l
#$ -l h_rt=12:00:00
#$ -cwd
#$ -pe smp 12

bamFullPathsList=$1
merged=$2
outdir=$3
headers=$4

ext=".bam"

#	bamFullPathsList = the full path to a txt file containing the full paths of all bams to be merged.
#	merged = a prefix for the merged outfile.
#	outdir = the full path to the directory that the output file will be written to.
#	headers = incoming bam read @ headers will be changed to this, 
	#	ideally choose a short common abreviation such as 'AE' for alviolar epithelium if merging a group of these bams.

module load samtools/1.3.1/gnu-4.9.2

samtools merge -nur1f -@ 12 -b $bamFullPathsList $outdir/$merged$ext
