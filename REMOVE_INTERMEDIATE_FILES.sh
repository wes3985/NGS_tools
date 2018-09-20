# THIS IS A SHELL SCRIPT TO REMOVE INTERMEDIATE FILES FROM ALIGNMENTS
# IF ARGUMENT $3 IS SUPPLIED THEN SUBGROUPS FROM THE METAFILE WILL BE PROCESSED INSTEAD OF THE WHOLE FILE

# USAGE EXAMPLE
# ./REMOVE_INTERMEDIATE_FILES.sh $HOME/Scratch/RNASeq_data/GSE86618_meta_v3.csv $HOME/Scratch/RNASeq_data IPF009

# THE GROUP OF FILES TO BE EXTRACTED FROM ARE DERIVED FROM THE METAFILE
meta=$1
data_folder=$2
subgroup=$3

# data_folder=$HOME/Scratch/RNASeq_data/

cd $data_folder

# STORES INFILES, TAKES ACCOUNT OF SPECIFIC SUB-GROUPS IF SPECIFIED
infiles=$(cat $meta | grep $subgroup | awk -F"," '{print $9}' | tr -d \")

for f in $infiles
do

        # GET PATH
        p1=$(echo $f | awk -F"//" '{print $2}')

        # CHECK FOR ALL FILES PRODUCED IN THE ANALYSIS
	sra=$(find $data_folder/$p1 -type f | grep '\b.sra$')
        gz=$(find $data_folder/$p1 -type f | grep '\b.gz$')
	chiOutS=$(find $data_folder/$p1 -type f | grep '\bChimeric.out.sam$') 
	chiOutJ=$(find $data_folder/$p1 -type f | grep '\bChimeric.out.junction$')
	BAMT=$(find $data_folder/$p1 -type f | grep '\bAligned.toTranscriptome.out.bam$')
	BAMC=$(find $data_folder/$p1 -type f | grep 'Aligned.sortedByCoord.out.bam')
	SUM2=$(find $data_folder/$p1 -type f | grep '\bSignal.UniqueMultiple.str2.out.bg$')
	SUM1=$(find $data_folder/$p1 -type f | grep '\bSignal.UniqueMultiple.str1.out.bg$')
	SU2=$(find $data_folder/$p1 -type f | grep '\bSignal.Unique.str2.out.bg$')
	SU1=$(find $data_folder/$p1 -type f | grep '\bSignal.Unique.str1.out.bg$')
	OT=$(find $data_folder/$p1 -type f | grep '\b.out.tab$')
	BAMRG=$(find $data_folder/$p1 -type f | grep '\bRG.bam$')
	BAIRG=$(find $data_folder/$p1 -type f | grep '\bRG.bai$')
	BAMDUP=$(find $data_folder/$p1 -type f | grep '\b.dedup.bam$')
	BAMReOr=$(find $data_folder/$p1 -type f | grep '\b.reOrd.bam$')
	BAIReOr=$(find $data_folder/$p1 -type f | grep '\b.reOrd.bai$')
	BAMLog=$(find $data_folder/$p1 -type f | grep 'Log.out')
	BAM_final=$(find $data_folder/$p1 -type f | grep '.split.bam')
	BAI_final=$(find $data_folder/$p1 -type f | grep '.split.bai')

        # DEFINE PREFIX AND EXTRACT INPATH FROM $f
        inpath=$(echo $gz | awk -F"/" 'BEGIN{FS=OFS="/"}{NF--; print}')
        prefix=$(echo $gz | awk -F"/" '{print $NF }' | awk -F"." '{print $1}')

	# IF .fastq EXISTS THEN REMOVE .sra

	# If Alignned.sortedByCoord.out.bam' EXISTS THE CHECK THE LOG

		# IF Log.out SAYS THE ALIGNMENT COMPLETED THEN REMOVE INTERMEDIATE FILES

		# ELSE REPORT ALIGNMENT NOT COMPLETED

	# IF .split.bam EXISTS THEN REMOVE INTERMEDIATE BAM AND INDEX FILES
