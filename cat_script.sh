#!/bin/bash -l
#$ -l h_rt=6:00:00
#$ -cwd
#$ -pe smp 1

prefix=$1
outpath=$2
fqA=$3
fqB=$4
ext=".fastq.gz"

zcat $fqA $fqB | gzip > $outpath/$prefix$ext

