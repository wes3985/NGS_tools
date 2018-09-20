#!/bin/bash -l
#$ -l h_rt=4:00:00
#$ -cwd
#$ -pe smp 1

module load java/1.8.0_45
module load picard-tools/1.136

# COMMAND LINE ARGUMENTS
prefix=$1
inpath=$2
ext=$3

echo "INFILE: "$prefix
echo "INPATH: "$inpath
echo "EXT: "$ext

cd $inpath

java -Xmx2g -jar $PICARDPATH/picard.jar ValidateSamFile \
    I=$inpath/$prefix$ext \
	IGNORE_WARNINGS=true \
    MODE=VERBOSE
    CREATE_INDEX=TRUE
