#!/bin/bash -l
#$ -l h_rt=12:00:00
#$ -cwd
#$ -pe smp 1


# EXAMPLE USE
# qsub $HOME/Scratch/git_single_cell_sequencing_scripts/split_depth_file_into_chroms.sh \
# $HOME/Scratch/batch1_wgs_workflow/LCM_coverage_data/undetermined.coverage \
# undetermined \
# $HOME/Scratch/batch1_wgs_workflow/LCM_coverage_data

full_infile_path=$1
sample=$2
outdir=$3

ext1="_coverage.txt"
ext2="_"

declare -a chroms=("chr1" "chr2" "chr3" "chr4" "chr5" "chr6" "chr7" "chr8" "chr9" "chr10" "chr11" "chr12" "chr13" "chr14" "chr15" "chr16" "chr17" "chr18" "chr19" "chr20" "chr21" 
"chr22" "chrX" "chrY" "chrM")

for i in {0..24};
do
echo $i
echo ${chroms[$i]}
less $full_infile_path | grep ${chroms[$i]} > $outdir/$sample$ext2${chroms[$i]}$ext1
done
