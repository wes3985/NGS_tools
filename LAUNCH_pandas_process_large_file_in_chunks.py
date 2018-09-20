#!/bin/bash -l
#$ -l h_rt=4:00:00
#$ -cwd
#$ -l mem=4G

module unload compilers
module load compilers/gnu/4.9.2

module load python3/recommended

# sample_outdir = where the output (summary bin files) will be saved
# sample_paths = .txt file containing a list of full paths to the outputs from SAMTOOLS_CALCULATE_DEPTH.sh
sample_outdir=$1
sample_paths=$2

# EXAMPLE OF INPUTS
# sample_outdir="/home/rmhawwo/Scratch/batch1_wgs_workflow/LCM_coverage_binData/coverage_HC_LCM1"
# sample_paths="/home/rmhawwo/Scratch/batch1_wgs_workflow/coverage_HC_LCM1_paths.txt"

python $HOME/Scratch/git_single_cell_sequencing_scripts/pandas_process_large_file_in_chunks.py $sample_paths 10000 $sample_outdir
