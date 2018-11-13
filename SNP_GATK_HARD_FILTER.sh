#!/bin/bash -l
#$ -l h_rt=2:00:00
#$ -cwd
#$ -pe smp 1

# EXAMPLE USAGE:
# qsub $HOME/Scratch/git_single_cell_sequencing_scripts/SNP_WINDOW_FILTER.sh IPF010_Chr1 \
# /home/rmhawwo/Scratch/RNASeq_data/IPF010_bams/VCFs_Realigned_Annotated/IPF010.1.annotated.rsfiltered.vcf \
# /home/rmhawwo/Scratch/RNASeq_data/IPF010_bams/VCFs_Realigned_Annotated \
# IPF010

# NOTES: AT THE TIME OF WRITING I AM UNSURE IF THE WINDOW FILTER WILL ACT BEFORE OR AFTER THE HARD FILTER PARAMETERS...
# SPECIFIED IN THIS SCRIPT SO I AM RUNNING THIS FIRST, THEN RUNNING THE WINDOW FILTERING

# COMMAND LINE ARGUMENTS
# sample is a prefix for labelling output files
# vcf_file is the full path and extention of the input vcf file
# outpath is the directory where the outputs will be sent
# study is an overall name for the study
sample=$1
vcf_file=$2
outpath=$3
study=$4

# REFERENCE GENOME
#path_to_ref=$HOME/Scratch/BAM_files/hg37/human_g1k_v37.fasta
path_to_ref=$HOME/Scratch/batch1_wgs_workflow/HG38_GATK_ref/Homo_sapiens_assembly38.fasta

# EXTENTIONS
outExt=".SNPHardFilter.vcf"

# LOAD MODULES
module load java/1.8.0_45
module load gatk/3.8.0

echo "sample "$sample
echo "input vcf "$vcf_file
echo "outpath "$outpath
echo "generating list of indel sites"
date +%Y%m%d%H%M%S

# FILTER SNPS
GenomeAnalysisTK \
-R $path_to_ref \
-T VariantFiltration \
-V $vcf_file \
--filterExpression 'QD < 2.0 || FS > 60.0 || MQ < 40.0 || MQRankSum < -12.5 || ReadPosRankSum < -8.0' \
--filterName 'QD || FS || MQ || MQRankSum || RPRS' \
-o $outpath/$sample$outExt

# --filterName "GATK_HARD_snp_filter" \

echo "complete"
date +%Y%m%d%H%M%S


echo "perfoming realignment"
date +%Y%m%d%H%M%S
