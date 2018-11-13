#!/bin/bash -l
#$ -l h_rt=16:00:00
#$ -cwd
#$ -pe smp 16

prefix=$1
outpath=$2
fqF=$3
fqR=$4
# path_to_ref=$HOME/Scratch/BAM_files/hg37/human_g1k_v37.fasta
path_to_ref=$HOME/Scratch/batch1_wgs_workflow/HG38_GATK_ref/Homo_sapiens_assembly38.fasta
out_ext=".bam"

cd $outpath

# OLD BWA MEM BEFORE ALT-CONTIGS HANDLING INTRODUCED
#module load bwa/0.7.12/gnu-4.9.2
# NEW BWA:
export bwa=$HOME/software/bwa/bwa
module load samtools/1.3.1
#module load samtools/0.1.19

# PRODUCE INDEX FILES IN 64bit
# $bwa index -6 $path_to_ref 


# IF NO fqR THEN SUBMIT AS UNPAIRED
echo $prefix
echo $outpath

if [[ ! $fqR = *[!\ ]* ]]
then
echo 'map as unpaired'
$bwa mem -M -t 16 $path_to_ref $fqF | samtools sort -@16 -O bam -o $outpath/$prefix$out_ext -
else
echo 'map as paired'
# THE '-' TELLS samtools view to read from stdin
$bwa mem -M -t 16 $path_to_ref $fqF $fqR | samtools sort -@16 -O bam -o $outpath/$prefix$out_ext -
fi

