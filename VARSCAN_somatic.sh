#!/bin/bash -l
#$ -l h_rt=48:00:00
#$ -cwd
#$ -l mem=4G
#$ -pe smp 1

module load perl
module load python2/recommended
module load java/1.8.0_45
module load varscan/2.3.9
module load samtools/1.2/gnu-4.9.2

export BAMS=$HOME/Scratch/BAM_files
export SOMATIC=$HOME/Scratch/varscan_somatic

# EXAMPLE CALL
# qsub $HOME/Scratch/git_single_cell_sequencing_scripts/VARSCAN_somatic.sh 
# $HOME/Scratch/BAM_files/fc16_realignedrecalibrated.bam
# $HOME/Scratch/BAM_files/g16_realignedrecalibrated.bam
# $HOME/Scratch/BAM_files/hg38.fa

# NOTES: run from directory that the output mut be in
# gBAM and fcBAM must be full file paths

gBAM=$1
fcBAM=$2
ref=$3
sample=$4
# chrom=$5

ext="varscan_somatic.vcf"

# SNV CALLING
# samtools mpileup -f $ref -q 20 -r $chrom $gBAM $fcBAM | \
samtools mpileup -f $ref -q 20 $gBAM $fcBAM | \
varscan somatic -mpileup $fcBAM --min-coverage-normal 2 \
--min-coverage-tumor 2 --p-value 0.05 --somatic-p-value 0.05 --min-var-freq 0.001 --strand-filter 1 --output-vcf 1 --output $sample.$ext


