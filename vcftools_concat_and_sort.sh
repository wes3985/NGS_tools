#!/bin/bash -l
#$ -l h_rt=4:00:00
#$ -cwd
#$ -l mem=1G
#$ -pe smp 1


sample=$1
input_file_list=$2
outpath=$3

module load perl/5.22.0
module load vcftools/0.1.15/gnu-4.9.2

ext1=".merged.vcf"
ext2=".merged.sorted.vcf"

cd $outpath
vcf-concat -f $input_file_list > $outpath/$sample$ext1
cat $outpath/$sample$ext1 | vcf-sort -c > $outpath/$sample$ext2
rm $outpath/$sample$ext1
