#!/bin/bash -l
#$ -l h_rt=24:00:00
#$ -cwd
# #$ -pe smp 4

# THIS SCRIPT TAKES ~12 HOURS TO RUN ON CHROMOSOME 1 FOR ~24 scSEQUENCING SAMPLES

sample=$1
bam_files=$2
outpath=$3
location=$4
BINSIZE=$5
# location format == "N:123-456"
chrom=$(echo $location | awk -F":" '{print $1}')

# LOAD MODULES
module load java/1.8.0_45
module load gatk/3.4.46

# REFERENCE AND DBSNP
#path_to_ref=$HOME/Scratch/BAM_files/hg38.fa
dbSNP=$HOME/Scratch/BAM_files/hg37/dbsnp_138.b37.vcf.gz
path_to_ref=$HOME/Scratch/BAM_files/hg37/human_g1k_v37.fasta
#dbSNP=$HOME/Scratch/BAM_files/dbsnp_146.hg38.vcf.gz
outExt=".coverage"

# CALCULATE BINSIZE BY DIVIDING TOTAL LENGTH OF SECTION BY BINSIZE TO OBTAIN NBINS
start=$(echo $location | awk -F":" '{print $2}' | awk -F"-" '{print $1}')
end=$(echo $location | awk -F"-" '{print $2}')
len=$(expr $end - $start)
len=$(expr $len + 1)
NBINS=$(expr $len / $BINSIZE)
NBINS=0
echo 'NBINS: '$NBINS
echo 'len :'$len

# VARIANT CALLING
date +%Y%m%d%H%M%S
echo "calculating depth"
GenomeAnalysisTK -T DepthOfCoverage \
        -R $path_to_ref \
        -I $bam_files \
        -L $location \
	-rf DuplicateRead \
	--nBins $NBINS \
        --out $outpath/$sample$chrom$outExt \
	--minMappingQuality 5
		
date +%Y%m%d%H%M%S
echo "complete"
