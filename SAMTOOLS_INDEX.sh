#!/bin/bash -l
#$ -l h_rt=6:00:00
#$ -cwd
#$ -pe smp 1

bam_path=$1

# EXAMPLE:
# qsub $HOME/Scratch/git_single_cell_sequencing_scripts/SAMTOOLS_INDEX.sh path/to/bamfile

echo $bam_path
module load samtools/1.3.1
samtools index $bam_path
echo "complete"
