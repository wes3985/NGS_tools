#!/bin/bash -l
#$ -l h_rt=16:00:00
#$ -cwd
# #$ -pe smp 4

bam_file_list=$1
outpath=$2
samples=$3
path_to_ref=$4
chr=$5
Mqual=10
Bqual=20

module load samtools/1.3.1/gnu-4.9.2

covExt=".coverage"
# path_to_ref=$HOME/Scratch/BAM_files/hg37/human_g1k_v37.fasta

# samtools depth -a -q $Mqual --reference $path_to_ref -r $chr -f $bam_file_list > $outpath/$samples$chr$covExt
# the '-f' argument points to a list of files, otherwise a single bam file is used

samtools depth -a -q $Mqual -Q $Bqual --reference $path_to_ref -r $chr -f $bam_file_list > $outpath/$samples$chr$covExt

# samtools depth -a -q $Mqual -Q $Bqual --reference $path_to_ref $bam_file_list > $outpath/$samples$covExt
