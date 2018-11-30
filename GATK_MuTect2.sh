#!/bin/bash -l
#$ -l h_rt=12:00:00
#$ -cwd
#$ -l mem=4G
#$ -pe smp 12

# TAKES 4-5 HOURS WITH cfDNA EXOME WITH 12 CORES, 4G Mem per core

# EXAMPLE USAGE:
# qsub $HOME/Scratch/git_single_cell_sequencing_scripts/GATK_BASERECALIBRATOR.sh
# fc18 \
# full_path_to_tumour.bam \
# full_path_to_control.bam \
# $HOME/Scratch/BAM_files/hg38.fa \
# $HOME/Scratch/BAM_files/dbsnp_146.hg38.vcf.gz \
# $HOME/Scratch/exome_support_files/truseq_hg38_annotated_final_tab.bed \ ###
# OR chr1 \
# $HOME/Scratch/BAM_files 


# COMMAND LINE ARGUMENTS TO LAUNCH THIS SCRIPT
sample=$1
t_bam=$2
n_bam=$3
path_to_ref=$4
dbSNP=$5
outpath=$6
target_regions=$7


# EXTENTIONS
# ext1="."$target_regions".BQSR.vcf"
ext1="."$target_regions".MuTect2.vcf"

# LOAD MODULES
module load java/1.8.0_45
module load gatk/3.8.0

echo "sample "$sample
echo "t_bam "$t_bam
echo "n_bam "$n_bam
echo "ref "$path_to_ref
echo "dbSNP "$dbSNP
# echo "target chrom "$target_regions
echo "outpath "$outpath
echo "variant claling with MuTect2"
date +%Y%m%d%H%M%S

# NOTE: "--disable-read-filter MateOnSameContigOrNoMappedMateReadFilter \" is for alt aware mapping and will use reads from alt contigs
# This increases the supporting reads by ~8% and hence increases variant calls as more reads can be used.


GenomeAnalysisTK \
     -T MuTect2 \
     -R $path_to_ref \
     -I:tumor $t_bam \
     -I:normal $n_bam \
     -nct 12 \
     --dbsnp $dbSNP \
     -minPruning 3 \
     -o $outpath/$sample$ext1 \
     -L $target_regions \
     -rf BadCigar
# --disable-read-filter MateOnSameContigOrNoMappedMateReadFilter 
	 
date +%Y%m%d%H%M%S
