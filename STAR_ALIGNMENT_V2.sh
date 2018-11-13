#!/bin/bash -l
#$ -l h_rt=12:00:00
#$ -cwd
#$ -pe smp 12
#$ -l mem=4G

threads=12

# SOFTWARE PATH
export STAR=$HOME/software/STAR-2.5.3a/bin/Linux_x86_64/STAR
# REF GENOME
# export hg37=$HOME/Scratch/BAM_files/hg37/human_g1k_v37.fasta 


# INFILE (gzipped)
prefix=$1
fwd=$2
rev=$3
outpath=$4
ref_genome_dir=$5
annot_file=$6


echo $prefix
echo $fwd
echo $rev
echo $outpath
echo $ref_genome_dir
echo $annot_file

cd $outpath

date +%Y%m%d%H%M%S
# PERFORM ALIGNMENT
$STAR --runThreadN $threads \
	--readFilesCommand zcat \
	--genomeDir $ref_genome_dir \
        --readFilesIn $fwd $rev \
	--outSAMmapqUnique 254 \
	--sjdbGTFfile $annot_file \
        --twopassMode Basic \
	--outFileNamePrefix $outpath/$prefix \
        --outSAMtype BAM SortedByCoordinate \
	--quantMode TranscriptomeSAM \
	--chimSegmentMin 20 \
	--outWigType bedGraph \
	--alignIntronMax INTRONMAX \
	--outFilterMatchNminOverLread 0 \
	--outFilterScoreMinOverLread 0 \
	--outFilterMatchNmin  40
		

date +%Y%m%d%H%M%S
