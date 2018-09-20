#!/bin/bash -l
#$ -l h_rt=12:00:00
#$ -cwd
#$ -pe smp 12

# COMMAND LINE ARGUMENTS
# sample is a prefix for labelling output files
# bam_file is the full path and extention of the input bam file
# indel_file is the full path and extention to the vcf containing called indels
# outpath is where the outputs will be sent
# study is an overall name for the study
sample=$1
bam_file=$2
indel_file=$3
outpath=$4
study=$5

# REFERENCE GENOME
path_to_ref=$HOME/Scratch/BAM_files/hg37/human_g1k_v37.fasta

# EXTENTIONS
RGext=".RG.bam"
intervals=".intervals"
realigned=".realigned.bam"

# LOAD MODULES
module load java/1.8.0_45
module load picard-tools/1.136
module load samtools/1.2/gnu-4.9.2
module load gatk/3.4.46

echo "sample "$sample
echo "input bam "$bam_file
echo "known indel file "$indel_file
echo "outpath "$outpath
echo "fixing read groups"
date +%Y%m%d%H%M%S

# FIX THE READ GROUPS (IF NECESSARY)
java -Xmx2g -jar $PICARDPATH/picard.jar AddOrReplaceReadGroups \
    I= $bam_file \
    O= $outpath/$sample$RGext \
    SORT_ORDER=coordinate \
    RGID=BATCH1 \
    RGLB=$sample \
    RGPL=illumina \
    RGSM=$sample \
    RGPU=$study \
    CREATE_INDEX=True
	
echo "generating list of indel sites"
date +%Y%m%d%H%M%S
	
# STEP 1: GENERATE LIST OF INDEL SITES FOR REALIGNMENT
GenomeAnalysisTK \
  -I $outpath/$sample$RGext \
  -R $path_to_ref \
  -T RealignerTargetCreator \
  -nt 12 \
  -o $outpath/$sample$intervals \
  -known $indel_file
  
echo "perfoming realignment"  
date +%Y%m%d%H%M%S

# STEP 2: PERFORM REALIGNMENT
GenomeAnalysisTK \
  -I $outpath/$sample$RGext \
  -R $path_to_ref \
  -T IndelRealigner \
  -targetIntervals $outpath/$sample$intervals \
  -o $outpath/$sample$realigned \
  -known $indel_file
  
echo "completed"
date +%Y%m%d%H%M%S
