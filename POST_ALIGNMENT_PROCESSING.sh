#!/bin/bash -l
#$ -l h_rt=8:00:00
#$ -cwd
#$ -pe smp 8

threads=8

cd $HOME/Scratch

module load samtools/1.2/gnu-4.9.2
# module load samtools/0.1.19
module load java/1.8.0_45
module load picard-tools/1.136
module load gatk/3.4.46

# PATHS
export CSD_temp=$HOME/Scratch/CSD_temp
export hg37=$HOME/Scratch/BAM_files/hg37
export RNASeq_vcfs=$HOME/Scratch/RNASeq_vcfs

# STRING VARIABLES
# CHANGE INFILE TO INPATH THROUGHOUT THE SCRIPT
infile=$1
inpath=$2
ext1=Aligned.sortedByCoord.out.bam
ext2=RG.bam
ext3=RG.dedup.bam
ext4=metrics.txt
ext5=.GATK.vcf
ext6=.GATK.filtered.vcf
ext7=.split.bam
ext8=.reOrd.bam

echo "file: "$1
echo "path: "$2

# CREATE AND INDEX AND A DICTIONARY OF THE REFERENCE FASTA (only needs to be done once)
# java -Xmx2g -jar $PICARDPATH/picard.jar CreateSequenceDictionary \
#	R=$hg37/human_g1k_v37.fasta \
#	O=$hg37/human_g1k_v37.dict \
#	TMP_DIR=$CSD_temp
# cd $hg37
# samtools faidx $hg37/human_g1k_v37.fasta

# MOVE TO WORKING DIRECTORY
cd $2

# FIX THE READ GROUPS 
echo "fixing read groups for "$infile
java -Xmx2g -jar $PICARDPATH/picard.jar AddOrReplaceReadGroups \
    I= $2/$infile$ext1 \
    O=  $2/$infile$ext2 \
    SORT_ORDER=coordinate \
    RGID=data \
    RGLB=$infile \
    RGPL=illumina \
    RGSM=$infile \
    RGPU=data \
    CREATE_INDEX=True

# REMOVE INTERMEDIATE FILES
# if [ -e $2/$infile$ext2 ]; then rm $2/$infile$ext1; else echo "No $infile$ext2 input file"; fi

# MARK DUPLICATES
echo "marking duplicates for "$infile
java -Xmx2g -jar $PICARDPATH/picard.jar MarkDuplicates I=$2/$infile$ext2 \
	O=$2/$infile$ext3 M=$2/$infile$ext4 TMP_DIR=$CSD_temp
echo "completed marking duplicates for "$infile

# REMOVE INTERMEDIATE FILES
# if [ -e $2/$infile$ext3 ]; then rm $2/$infile$ext2; else echo "No $infile$ext3 file"; fi

# RE-ORDER BAM TO CHROMOSOME ORDER RATHER THAN LEXICOGRAPHIC
java -Xmx2g -jar $PICARDPATH/picard.jar ReorderSam \
    I=$2/$infile$ext3 \
    O=$2/$infile$ext8 \
    R=$hg37/human_g1k_v37.fasta \
    CREATE_INDEX=TRUE

# REMOVE INTERMEDIATE FILES
# if [ -e $2/$infile$ext8 ]; then rm $2/$infile$ext3; else echo "No $infile$ext8 input file"; fi

# SPLIT'N'TRIM
echo "spliting and trimming overhangs"
GenomeAnalysisTK -T SplitNCigarReads -R $hg37/human_g1k_v37.fasta \
	-I $2/$infile$ext8 -o $2/$infile$ext7 -rf ReassignOneMappingQuality \
	-RMQF 255 -RMQT 60 -U ALLOW_N_CIGAR_READS

echo "completed split'n'trim"
# REMOVE INTERMEDIATE FILES
# if [ -e $2/$infile$ext7 ]; then rm $2/$infile$ext8; else echo "No $infile$ext7 input file"; fi

# VARIANT CALLING
# echo "calling variants"
# GenomeAnalysisTK -T HaplotypeCaller -R $hg37/human_g1k_v37.fasta \
#	-I $2/$infile$ext7 --dbsnp $hg37/dbsnp_138.b37.vcf.gz \
#	-nt $threads \
#	-dontUseSoftClippedBases -stand_call_conf 20.0 -o $2/$infile$ext5

# REMOVE INTERMEDIATE FILES
# if [ -e $2/$infile$ext5 ]; then rm $2/$infile$ext7; else echo "No $infile$ext5 input file"; fi

# VARIANT FILTERING
# echo "filtering variants"
# GenomeAnalysisTK -T VariantFiltration -R $hg37/human_g1k_v37.fasta \
#	-V $2/$infile$ext5 -window 35 -cluster 3 \
#       -nt $threads \
#	-o $2/$infile$ext6

# REMOVE INTERMEDIATE FILES
# if [ -e $2/$infile$ext6 ]; then rm $2/$infile$ext5; else echo "No $infile$ext6  input file"; fi
