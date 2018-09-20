#!/bin/bash -l
#$ -l h_rt=12:00:00
#$ -cwd
#$ -pe mpi 1



export sra=$HOME/software/sratoolkit.2.8.2-1-ubuntu64/bin

prefix=$1
inpath=$2
ext1=.sra
ext2=.fastq
ext3=.gz

cd $inpath

$sra/fastq-dump $inpath/$prefix$ext1
gzip $inpath/$prefix$ext2

echo $prefix
echo $inpath

# REMOVE .sra IF .fastq.gz HAS BEEN MADE SUCESSFULLY
if [ -e $inpath/$prefix$ext2$ext3 ]; then rm $inpath/$prefix$ext1; fi



