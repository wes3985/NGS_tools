#!/bin/bash -l
#$ -l h_rt=12:00:00
#$ -cwd
#$ -l mem=2G
#$ -pe smp 2


# EXAMPLE USAGE
# BAM must be sorted and de-duplicated
# qsub $HOME/Scratch/git_single_cell_sequencing_scripts/picard_calculate_coverage_WG.sh $HOME/Scratch/chung_data/BC03_bams/SRR2973383Aligned.realigned.bam  SRR2973383
# $HOME/Scratch/coverage_data

full_bam_path=$1
sample=$2
out_dir=$3

ext1=_hs_metrics.txt
ext2=_per_target_hs_metrics.txt

module load java/1.8.0_45
module load picard-tools/1.136
module load samtools/1.3.1/gnu-4.9.2

# CREATE INDEX
# cd $HOME/Scratch/batch1_wgs_workflow/HG38_GATK_ref
# samtools faidx $HOME/Scratch/batch1_wgs_workflow/HG38_GATK_ref/Homo_sapiens_assembly38.fasta
# cd $HOME/Scratch/batch1_wgs_workflow

export CSD_temp=$HOME/Scratch/CSD_temp


# CREATE SEQUENCE DICTIONARY FROM REFERENCE SEQUENCE (only needed 1 time, old version used hg38)
# java -Xmx2g -jar $PICARDPATH/picard.jar CreateSequenceDictionary R=$HOME/Scratch/BAM_files/hg37/human_g1k_v37.fasta O=$HOME/Scratch/BAM_files/hg37/human_g1k_v37.dict 

TMP_DIR=$CSD_temp

# CREATE INTERVAL LIST OF TARGET REGION
# CONSIDER ADDING PYTHON SCRIPT HERE TO MAKE BED INTERVALS WITH A COMMAND LINE ARGUMENT OF INTERVAL SIZE
# java -Xmx2g -jar $PICARDPATH/picard.jar BedToIntervalList I=$HOME/support_files/human_g1k_v37_whole_genome.bed O=$HOME/Scratch/human_g1k_v37_picard.interval_list \
# SD=$HOME/Scratch/BAM_files/hg37/human_g1k_v37.dict TMP_DIR=$CSD_temp

# CALCULATE COVERAGE
java -Xmx2g -jar $PICARDPATH/picard.jar CalculateHsMetrics I=$1 O=$out_dir/$sample$ext1 R=$HOME/Scratch/batch1_wgs_workflow/HG38_GATK_ref/Homo_sapiens_assembly38.fasta \
BAIT_INTERVALS=$HOME/Scratch/batch1_wgs_workflow/HG38_GATK_ref/wgs_calling_regions.hg38.interval_list \
TARGET_INTERVALS=$HOME/Scratch/batch1_wgs_workflow/HG38_GATK_ref/wgs_calling_regions.hg38.interval_list \
PER_TARGET_COVERAGE=$out_dir/$sample$ext2 \
TMP_DIR=$HOME/Scratch/CSD_temp
