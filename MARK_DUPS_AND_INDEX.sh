#!/bin/bash -l
#$ -l h_rt=12:00:00
#$ -cwd
#$ -pe smp 6

sample=$1
bam_path=$2
outpath=$3

# EXAMPLE:
# qsub $HOME/Scratch/git_single_cell_sequencing_scripts/MARK_DUPS_AND_INDEX.sh ${samples[$i]} $outpath${BAM_files[$i]} $outpath
# Where ${samples[$i]} is an element of an array and $outpath${BAM_files[$i]} is a full path to the bam

bamExt=".dedup.bam"
metExt=".metrics.txt"

module load java/1.8.0_45
module load picard-tools/1.136
module load samtools/1.3.1

export CSD_temp=$HOME/Scratch/batch1_wgs_workflow/CSD_temp

echo "marking duplicates for "$sample
echo "outpath: "$outpath
echo "bam_path: "$bam_path
java -Xmx2g -jar $PICARDPATH/picard.jar MarkDuplicates I=$bam_path O=$outpath/$sample$bamExt M=$outpath/$sample$metExt TMP_DIR=$CSD_temp
echo "producing index for "$sample
samtools index $outpath/$sample$bamExt
echo "complete"
