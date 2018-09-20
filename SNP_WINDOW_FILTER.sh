#!/bin/bash -l
#$ -l h_rt=2:00:00
#$ -cwd

# EXAMPLE USAGE: 
# qsub $HOME/Scratch/git_single_cell_sequencing_scripts/SNP_WINDOW_FILTER.sh IPF010_Chr1 \
# /home/rmhawwo/Scratch/RNASeq_data/IPF010_bams/VCFs_Realigned_Annotated/IPF010.1.annotated.rsfiltered.vcf \
# /home/rmhawwo/Scratch/RNASeq_data/IPF010_bams/VCFs_Realigned_Annotated \
# IPF010

# COMMAND LINE ARGUMENTS
# sample is a prefix for labelling output files
# vcf_file is the full path and extention of the input vcf file
# outpath is the directory where the outputs will be sent
# study is an overall name for the study
# clusterSize is number of SNVs searched for in a given window
# windowSize is size of window that will contain max number of SNVs for removal
sample=$1
vcf_file=$2
outpath=$3
study=$4
clusterSize=$5
windowSize=$6
path_to_ref=$7

# REFERENCE GENOME
# path_to_ref=$HOME/Scratch/BAM_files/hg37/human_g1k_v37.fasta
# path_to_ref=$HOME/Scratch/BAM_files/hg38.fa

# EXTENTIONS
outExt=".SNPWindowFiltered.vcf"

# LOAD MODULES
module load java/1.8.0_45
module load gatk/3.4.46

echo "sample "$sample
echo "input vcf "$vcf_file
echo "outpath "$outpath
date +%Y%m%d%H%M%S

# FILTER SNPS
GenomeAnalysisTK \
  -R $path_to_ref \
  -T VariantFiltration \
  -o $outpath/$sample$study$outExt \
  --variant $vcf_file \
  --clusterSize $clusterSize \
  --clusterWindowSize $windowSize 

echo "complete"
date +%Y%m%d%H%M%S


