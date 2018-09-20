#!/bin/bash -l
#$ -l h_rt=12:00:00
#$ -cwd
#$ -pe smp 12

module load perl
module load python2/recommended
module load java/1.8.0_45
module load varscan/2.3.9
module load samtools/1.2/gnu-4.9.2

sample=$1
bam_file=$2
outpath=$3

path_to_ref=$HOME/Scratch/BAM_files/hg37/human_g1k_v37.fasta
vcfExt=".INDEL.vcf"

echo $sample
echo $bam_file

# INDEL CALLING
# MINIMAL PARAMETERS BECAUSE WE WANT IT TO BE 'LOOSE' WITH CALLS TO IDENTIFY AS MANY REGIONS THAT REQUIRE
# RE-ALIGNMENT AS POSSIBLE

samtools mpileup -f $path_to_ref -q 15 $bam_file | \
varscan mpileup2indel --p-value 0.05 --min-var-freq 0.1 --min-coverage 1 --min-reads2 1 --output-vcf 1 > $outpath/$sample$vcfExt

echo "complete"
