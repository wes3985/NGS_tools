#!/bin/bash -l
#$ -l h_rt=12:00:00
#$ -cwd
#$ -pe smp 12
#$ -l mem=4G

threads=12

export STAR=$HOME/software/STAR-2.5.3a/bin/Linux_x86_64/STAR
export hg37=$HOME/Scratch/BAM_files/hg37

cd $HOME/Scratch/BAM_files/hg37

# BUILD INDEX (Only needs to be done 1 time)
# $STAR --runMode genomeGenerate --genomeDir $hg37 --genomeFastaFiles $hg37/GRCh37.primary_assembly.genome.fa \
#	--runThreadN 12 --sjdbOverhang 49 --sjdbGTFfile $hg37/gencode.v26lift37.annotation.gtf

# BUILD INDEX WITH NO ANNOTATION FILE
$STAR --runMode genomeGenerate --genomeDir $hg37 --genomeFastaFiles $hg37/human_g1k_v37.fasta \
	--runThreadN 12 --sjdbOverhang 149 --sjdbGTFfile $hg37/gencode.v26lift37.annotation.gtf  


# INFILE (gzipped)
# prefix=$1
# inpath=$2
# outpath=$3
# ext1=.fastq.gz
# ext2=Aligned.sortedByCoord.out.bam

# LABELS TO TRACK JOB PROGRESS
# cd $inpath
# echo $prefix
# echo $inpath
# echo $inpath/$prefix$ext1

# PERFORM ALIGNMENT	
# $STAR --runThreadN $threads --readFilesCommand zcat --genomeDir $hg37 \
#	--readFilesIn $inpath/$prefix$ext1 --outSAMmapqUnique 254 \
#	--twopassMode Basic --outFileNamePrefix $outpath/$prefix \
#	--outSAMtype BAM SortedByCoordinate --quantMode TranscriptomeSAM --chimSegmentMin 20 --outWigType bedGraph

# LOG DATA-FOOTPRINT
# footprint=$(ls -lt $inpath | tail -1 | awk -F" " '{print $5}'); 
# name=$(ls -lt $inpath | tail -1 | awk -F" " '{print $9}'); 
# echo $footprint $name >> $inpath/$prefix.footprint.txt
# CLEAN UP
# if [ -e $outpath/$prefix$ext2 ]; then rm $inpath/$prefix$ext1; else echo "No BAM file produced!"; fi

