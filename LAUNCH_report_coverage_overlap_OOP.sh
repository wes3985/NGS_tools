#!/bin/bash -l
#$ -l h_rt=2:00:00
#$ -cwd
#$ -l mem=1G

module unload compilers
module load compilers/gnu/4.9.2

module load python3/recommended

# EXAMPLE OF HOW TO CALL THIS SCRIPT:
# qsub $HOME/Scratch/git_single_cell_sequencing_scripts/LAUNCH_report_coverage_overlap_OOP.sh $HOME/Scratch/merged_bam_analysis/coverage_test_file_100k.txt "2" "AE,BE,HE,C" $HOME/Scratch/merged_bam_analysis/coverage_test_file_100k_OUTPUT.txt

infile=$1
minCov=$2
sampleList=$3
outfile=$4

# EXAMPLE OF INPUTS
# infile=$HOME/Scratch/merged_bam_analysis/coverage_test_file_100k.txt
# minCov="2"
# sampleList="AE,BE,HE,C"
# outfile=$HOME/Scratch/merged_bam_analysis/coverage_test_file_100k_OUTPUT.txt

python $HOME/Scratch/git_single_cell_sequencing_scripts/report_coverage_overlap_OOP.py $infile $minCov $sampleList $outfile

