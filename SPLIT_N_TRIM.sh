#!/bin/bash -l
#$ -l h_rt=12:00:00
#$ -cwd
#$ -pe smp 12
#$ -l mem=4G

# COMMAND LINE ARGUMENTS
# sample is a prefix for labelling output files
# bam_file is the full path and extention of the input bam file
# outpath is the directory where the outputs will be sent
# path_to_ref is the reference used to align the reads

sample=$1
in_bam=$2
outpath=$3
path_to_ref=$4

ext=".SNT.bam"

# LOAD MODULES
module load java/1.8.0_45
module load gatk/3.4.46

date +%Y%m%d%H%M%S
echo "spliting and trimming overhangs"
GenomeAnalysisTK -T SplitNCigarReads \
	-R $path_to_ref \
	-I $in_bam \
	-o $outpath/$sample$ext \
	-rf ReassignOneMappingQuality \
	-RMQF 255 \
	-RMQT 60 \
	-U ALLOW_N_CIGAR_READS

echo "completed split'n'trim"
date +%Y%m%d%H%M%S
