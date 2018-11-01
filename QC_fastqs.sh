#!/bin/bash -l
#$ -l h_rt=4:00:00
#$ -cwd

# USE FULL PATHS TO INFILE AND OUTPATH
infile=$1
outpath=$2

$HOME/Scratch/FastQC/fastqc $infile --outdir $outpath 

