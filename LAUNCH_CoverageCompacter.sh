#!/bin/bash -l
#$ -l h_rt=6:00:00
#$ -cwd
#$ -l mem=1G

module unload compilers
module load compilers/gnu/4.9.2
module load python3/recommended

infile=$1
outfile=$2
samples=$3
chrom=$4
binSize=$5
NoCov=$6

python $HOME/Scratch/git_single_cell_sequencing_scripts/CoverageCompacter/CoverageCompacter.py $infile $outfile $samples $chrom $binSize $NoCov


########################## EXAMPLE INPUTS	#########################################

# mCovFiles=$HOME/Scratch/merged_bam_analysis/coverage_data/mergedBAMSchr*.coverage
# mkdir $HOME/Scratch/merged_bam_analysis/coverage_data/CoverageCompacterOutput
# outfolder=$HOME/Scratch/merged_bam_analysis/coverage_data/CoverageCompacterOutput/
# prefix="mergedCC."
# ext=".bed"
# samples="AE,BE,HE,PBMC"
# binSize=10000
# NoCov=0


# for f in $mCovFiles 
# do 
# echo $f
# CHROM=$(echo $f | awk -F"/" '{print $NF }' | awk -F"BAMS" '{print $2}' | awk -F"." '{print $1}')
# echo $CHROM
# qsub LAUNCH_CoverageCompacter $f $outfolder/$prefix$CHROM$ext $samples $CHROM $binSize $NoCov
# done
