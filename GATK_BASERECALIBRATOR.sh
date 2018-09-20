#!/bin/bash -l
#$ -l h_rt=12:00:00
#$ -cwd
#$ -l mem=1G
#$ -pe smp 12

# THIS SCRIPT REQUIRED READ GROUPS TO BE FIXED BEFORE RUNNING
# SEE 'FIX_READ_GROUPS.sh'

# EXAMPLE USAGE:
# qsub $HOME/Scratch/git_single_cell_sequencing_scripts/GATK_BASERECALIBRATOR.sh
# fc18_realigned \
# fc18_realigned.bam \
# $HOME/Scratch/BAM_files/hg38.fa \
# $HOME/Scratch/BAM_files/dbsnp_146.hg38.vcf.gz \
# $HOME/Scratch/BAM_files \
# BC03

# COMMAND LINE ARGUMENTS
# sample is a prefix for labelling output files
# bam_file is the full path and extention of the input bam file, or a txt file containing full paths for a list of bam files
# outpath is the directory where the outputs will be sent
# study is an overall name for the study
sample=$1
bam_file=$2
path_to_ref=$3
dbSNP=$4
outpath=$5
# location format == "chrN:123-456"
# chrom=$(echo $location | awk -F":" '{print $1}')


# REFERENCE GENOME
# path_to_ref=$HOME/Scratch/BAM_files/hg37/human_g1k_v37.fasta
# path_to_ref=$HOME/Scratch/BAM_files/hg38.fa
# dbSNP=$HOME/Scratch/BAM_files/hg37/dbsnp_138.b37.vcf.gz
# dbSNP=$HOME/Scratch/BAM_files/dbsnp_146.hg38.vcf.gz

# EXTENTIONS
ext1=".recalibration_report.grp"

# LOAD MODULES
module load java/1.8.0_45
module load gatk/3.4.46

echo "sample "$sample
echo "input bam "$bam_file
echo "ref "$path_to_ref
echo "dbSNP "$dbSNP
echo "outpath "$outpath
echo "generating base recalibration tables"
date +%Y%m%d%H%M%S

# BASE RECALIBRATION
GenomeAnalysisTK -T BaseRecalibrator \
       -R $path_to_ref \
       -I $bam_file \
       -knownSites $dbSNP \
       -nct 12 \
       -o $outpath/$sample$ext1

echo "complete"
date +%Y%m%d%H%M%S
