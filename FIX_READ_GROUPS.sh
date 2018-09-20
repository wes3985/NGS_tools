#!/bin/bash -l
#$ -l h_rt=12:00:00
#$ -cwd
#$ -pe smp 12

# COMMAND LINE ARGUMENTS
# sample is a prefix for labelling output files
# bam_file is the full path and extention of the input bam file
# outpath is where the outputs will be sent
# study is an overall name for the study
sample=$1
bam_file=$2
outpath=$3
study=$4
ref_genome=$5

# EXTENTIONS
RGext=".RG.bam"
intervals=".intervals"
# realigned=".realigned.bam"

# LOAD MODULES
module load java/1.8.0_45
module load picard-tools/1.136
module load samtools/1.2/gnu-4.9.2
module load gatk/3.4.46

echo "sample "$sample
echo "input bam "$bam_file
echo "outpath "$outpath
echo "reference "$ref_genome
echo "fixing read groups"
date +%Y%m%d%H%M%S

# FIX THE READ GROUPS (IF NECESSARY)
java -Xmx2g -jar $PICARDPATH/picard.jar AddOrReplaceReadGroups \
    I= $bam_file \
    O= $outpath/$sample$RGext \
    SORT_ORDER=coordinate \
    RGID=$study \
    RGLB=$sample \
    RGPL=illumina \
    RGSM=$sample \
    RGPU=$study \
    CREATE_INDEX=True

echo "complete"
date +%Y%m%d%H%M%S
