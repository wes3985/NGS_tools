#!/bin/bash -l
#$ -l h_rt=12:00:00
#$ -cwd
#$ -pe smp 12

cores=12
module load samtools/0.1.19
module load python2/recommended
monovar=$HOME/software/monovar/src/monovar.py

# LAUNCH EXAMPLE
# qsub $HOME/Scratch/git_single_cell_sequencing_scripts/MONOVAR_variant_calling.sh \
# LCM_batch1 \
# chr1 \
# $HOME/Scratch/batch1_wgs_workflow/LCM_BAMS/bam_list.txt \
# $HOME/Scratch/batch1_wgs_workflow/HG38_GATK_ref/Homo_sapiens_assembly38.fasta \
# $HOME/Scratch/batch1_wgs_workflow/MONOVAR_vcfs

# BAM PRE_PROCESSING


# VARIABLES
sample_group=$1
chrom=$2
list_of_BAM_files=$3
ref=$4
outpath=$5

echo "SAMPLE GROUP: "$sample_group
echo "CHROM: "$chrom
echo "BAM LIST: "$list_of_BAM_files
date +%Y%m%d%H%M%S

# MONOVAR CALL LINE (per chromosome)
samtools mpileup -BQ0 -d10000 -f $ref -r $chrom -q 40 -b $list_of_BAM_files | \
        $monovar -p 0.002 -a 0.2 -t 0.05 -m $cores -f $ref -b $list_of_BAM_files -o $outpath/MONOVAR.$sample_group.$chrom.vcf

echo "complete"
date +%Y%m%d%H%M%S
