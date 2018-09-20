#!/bin/bash -l
#$ -l h_rt=12:00:00
#$ -cwd
#$ -pe smp 12
#$ -l mem=4G

# COMMAND LINE ARGUMENTS
# sample is a prefix for labelling output files
# bam_file is the full path and extention of the input bam file
# indel_file is the full path and extention to the vcf containing known indels (from public databases)
# outpath is where the outputs will be sent
# path_to_ref is the reference used to align the reads


sample=$1
bam_file=$2
outpath=$3
path_to_ref=$4
indel_file=$5

# EXTENTIONS
intervals=".intervals"
realigned=".realigned.bam"

# LOAD MODULES
module load java/1.8.0_45
module load picard-tools/1.136
module load samtools/1.2/gnu-4.9.2
module load gatk/3.4.46

echo "sample "$sample
echo "input bam "$bam_file
echo "outpath "$outpath
echo "generating list of indel sites"
date +%Y%m%d%H%M%S

# STEP 1: GENERATE LIST OF INDEL SITES FOR REALIGNMENT
#GenomeAnalysisTK \
java -Xmx4g -jar $GATKPATH/GenomeAnalysisTK.jar \
  -I $bam_file \
  -R $path_to_ref \
  -T RealignerTargetCreator \
  -nt 12 \
  -o $outpath/$sample$intervals \
  -known $indel_file

echo "perfoming realignment"
date +%Y%m%d%H%M%S

# STEP 2: PERFORM REALIGNMENT
#GenomeAnalysisTK \
java -Xmx4g -jar $GATKPATH/GenomeAnalysisTK.jar \
  -I $bam_file \
  -R $path_to_ref \
  -T IndelRealigner \
  -targetIntervals $outpath/$sample$intervals \
  -o $outpath/$sample$realigned \
  -known $indel_file

echo "completed"
date +%Y%m%d%H%M%S
