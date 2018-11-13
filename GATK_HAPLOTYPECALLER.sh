#!/bin/bash -l
#$ -l h_rt=48:00:00
#$ -cwd
#$ -l mem=16G
# #$ -pe smp 12

# TOTAL TIME ~24 HOURS PER CHROMOSOME FOR 24 SAMPLES: HIGH MEMORY IS REQUIRED FOR MULTIPLE SAMPLES!!!
# NB: USING MULTIPLE CORES WITH HAPLOTYPECALLER IS STILL GLITCHY SO USE SINGLE CORES

# EXAMPLE USAGE:
# qsub $HOME/Scratch/git_single_cell_sequencing_scripts/GATK_HAPLOTYPECALLER.sh 
# SRR2973374 \
# /home/rmhawwo/Scratch/chung_data/BC03/BC03_bams/SRR2973374Aligned.realigned.bam \
# /home/rmhawwo/Scratch/chung_data/BC03/BC03_bams \
# /home/rmhawwo/Scratch/chung_data/BC03/GATK_outputs \
# BC03

# COMMAND LINE ARGUMENTS
# sample is a prefix for labelling output files
# bam_file is the full path and extention of the input bam file, or a txt file containing full paths for a list of bam files
# outpath is the directory where the outputs will be sent
# study is an overall name for the study
sample=$1
bam_file=$2
outpath=$3
location=$4
# location format == "chrN:123-456"
chrom=$(echo $location | awk -F":" '{print $1}')


# REFERENCE GENOME
# path_to_ref=$HOME/Scratch/BAM_files/hg37/human_g1k_v37.fasta
# path_to_ref=$HOME/Scratch/BAM_files/hg38.fa
# dbSNP=$HOME/Scratch/BAM_files/hg37/dbsnp_138.b37.vcf.gz
path_to_ref=$HOME/Scratch/batch1_wgs_workflow/HG38_GATK_ref/Homo_sapiens_assembly38.fasta
dbSNP=$HOME/Scratch/batch1_wgs_workflow/HG38_GATK_ref/Homo_sapiens_assembly38.dbsnp138.vcf

# EXTENTIONS
outExt=".HaplotypeCaller.vcf"

# LOAD MODULES
module load java/1.8.0_45
module load gatk/3.4.46

echo "sample "$sample
echo "input bam "$bam_file
echo "outpath "$outpath
echo "generating list of indel sites"
date +%Y%m%d%H%M%S

# VARIANT CALLING
echo "calling variants"
GenomeAnalysisTK -T HaplotypeCaller \
	-R $path_to_ref \
        -I $bam_file \
	-L $location \
	--dbsnp $dbSNP \
        -dontUseSoftClippedBases \
	-stand_call_conf 20.0 \
	-stand_emit_conf 20 \
	--monitorThreadEfficiency \
	-o $outpath/$sample$location$outExt 
		
echo "complete"
date +%Y%m%d%H%M%S

