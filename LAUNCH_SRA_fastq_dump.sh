

# THIS SHELL SCRIPT CHECKS FOR A .sra FILE, IF A .sra FILE IS PRESENT IT LAUNCHES A JOB TO CONVERT IT INTO A .fastq.gz FILE
# IF ARGUMENT $3 IS SUPPLIED THEN SUBGROUPS FROM THE METAFILE WILL BE PROCESSED INSTEAD OF THE WHOLE FILE

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

	# CHECK FOR .sra FILE AND .gz
	sra=$(find $data_folder/$p1 -type f | grep '\bsra$')
	gz=$(find $HOME/Scratch/RNASeq_data/$p1 -type f | grep '\b.gz$')

	# DEFINE PREFIX AND EXTRACT INPATH FROM $f
	inpath=$(echo $sra | awk -F"/" 'BEGIN{FS=OFS="/"}{NF--; print}')
	prefix=$(echo $sra | awk -F"/" '{print $NF }' | awk -F"." '{print $1}')

	# IF NO .gz THEN CHECK FOR .sra
	if [[ ! $gz = *[!\ ]* ]]
		then
		# CHECK FOR .sra; IF NOT THERE THEN ls THE OTHER FILES IN THE SAME PATH
		if  [[ ! $sra = *[!\ ]* ]]; then ls -lt $p1 ;
		# IF .sra EXISTS THEN PRINT THE PREFIX AND THE INPATH AND LAUNCH THE EXTRACTION
		else ls -lt $sra;
		echo "prefix "$prefix
		echo "inpath "$inpath
		qsub $HOME/Scratch/git_single_cell_sequencing_scripts/SRA_fastq_dump.sh $prefix $inpath;
		fi
	# IF .gz ALREADY EXISTS THEN ls -lt
	else ls -lt $gz;
	fi

done
