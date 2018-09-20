#!/bin/bash -l
#$ -l h_rt=8:00:00
#$ -cwd
# #$ -pe smp 1


module load samtools/1.3.1/gnu-4.9.2

inbams=$(cat $1)
outpath=$2
dsEXT=".10percent.bam"

for f in $inbams 
do
echo $f
sample=$(echo $f | awk -F"/" '{print $NF }' | awk -F"." '{print $1}')
echo $sample
samtools view -b -s 0.1 $f > $outpath/$sample$dsEXT
done
