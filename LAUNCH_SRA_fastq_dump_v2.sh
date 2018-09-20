# THIS SHELL SCRIPT CHECKS FOR A .sra FILE, IF A .sra FILE IS PRESENT IT LAUNCHES A JOB TO CONVERT IT INTO A .fastq.gz FILE
# IF ARGUMENT $3 IS SUPPLIED THEN SUBGROUPS FROM THE METAFILE WILL BE PROCESSED INSTEAD OF THE WHOLE FILE

# EXAMPLE USAGE:
# $HOME/Scratch/git_single_cell_sequencing_scripts/LAUNCH_SRA_fastq_dump_v2.sh $HOME/Scratch/TNBC_data/SraRunTable.txt $HOME/Scratch/TNBC_data TNBC

# THE GROUP OF FILES TO BE EXTRACTED FROM ARE DERIVED FROM THE METAFILE
meta=$1
data_folder=$2
subgroup=$3

# data_folder=$HOME/Scratch/TNBC_data/

cd $data_folder

# GENERATE INFILE LIST
meta_prefix="ftp://ftp-trace.ncbi.nih.gov/sra/sra-instant/reads/ByRun/sra/"
ext=".sra"

# GET N FILES IN THE META
len=$(cat $meta | wc -l)

# STORES INFILES, TAKES ACCOUNT OF SPECIFIC SUB-GROUPS IF SPECIFIED
infiles=$(cat $meta | grep $subgroup | awk -F"\t" '{print $7}')

for ((i=2;i<=$len;i++))
do
	f=$(less $meta | awk -F"\t" '{print $7}' | head -$i | tail -1)
		
        # CONSTRUCT SAMPLE PATH
	three="${f:0:3}"
	six="${f:0:6}"
	path="$(echo $meta_prefix$three/$six/$f/$f$ext)"
        p1=$(echo $path | awk -F"//" '{print $2}')
	echo "path : "$path
	echo "p1 : "$p1

        # CHECK FOR .sra FILE AND .gz
        sra=$(find $data_folder/$p1 -type f | grep '\bsra$')
        gz=$(find $data_folder/$p1 -type f | grep '\b.gz$')
	bam=$(find $data_folder/$p1 -type f | grep '\b.bam$')

        # DEFINE PREFIX AND EXTRACT INPATH FROM $path
        inpath=$(echo $sra | awk -F"/" 'BEGIN{FS=OFS="/"}{NF--; print}')
        #inpath=$p1
	prefix=$(echo $sra | awk -F"/" '{print $NF }' | awk -F"." '{print $1}')

        # IF NO .gz THEN CHECK FOR .sra
        if [[ ! $gz = *[!\ ]* || ! $bam = *[!\ ]* ]]
                then
                # CHECK FOR .sra; IF NOT THERE THEN ls THE OTHER FILES IN THE SAME PATH
                if  [[ ! $sra = *[!\ ]* ]]; then ls -lt $p1 ;
                # IF .sra EXISTS THEN PRINT THE PREFIX AND THE INPATH AND LAUNCH THE EXTRACTION
                else ls -lt $sra;
                echo "prefix "$prefix
                echo "inpath "$inpath
		echo "launching fastq extraction"
                qsub $HOME/Scratch/git_single_cell_sequencing_scripts/SRA_fastq_dump.sh $prefix $inpath;
		job=$(qstat | head -$i | tail -1 | awk -F" " '{print $1}')
                fi
        # IF .gz or .bam ALREADY EXISTS THEN ls -lt
        else ls -lt $gz;
	ls -lt $bam
	echo "fastq extraction already performed"
        fi

	echo " "
done
