# THIS SHELL SCRIPT CHECKS FOR A .gz FILE, IF A .gz FILE IS PRESENT IT LAUNCHES A JOB TO PERFORM ALIGNMENT

# EXAMPLE USAGE:
# $HOME/Scratch/git_single_cell_sequencing_scripts/LAUNCH_BWA_mem.sh $HOME/Scratch/TNBC_data/SraRunTable.txt $HOME/Scratch/TNBC_data TNBC

# THE GROUP OF FILES TO BE EXTRACTED FROM ARE DERIVED FROM THE METAFILE
meta=$1
data_folder=$2
subgroup=$3

# data_folder=$HOME/Scratch/TNBC_data/

cd $data_folder

# GENERATE INFILE LIST
meta_prefix="ftp://ftp-trace.ncbi.nih.gov/sra/sra-instant/reads/ByRun/sra/"
ext=".fastq.gz"

# GET N FILES IN THE META
len=$(cat $meta | wc -l)

# STORES INFILES, TAKES ACCOUNT OF SPECIFIC SUB-GROUPS IF SPECIFIED
infiles=$(cat $meta | grep $subgroup | awk -F"\t" '{print $10}')

for ((i=2;i<=$len;i++))
do
        f=$(less $meta | awk -F"\t" '{print $10}' | head -$i | tail -1)

        # CONSTRUCT SAMPLE PATH
        three="${f:0:3}"
        six="${f:0:6}"
        path="$(echo $meta_prefix$three/$six/$f/$f$ext)"
        p1=$(echo $path | awk -F"//" '{print $2}')
        echo "path : "$path
        echo "p1 : "$p1

        # CHECK FOR .gz FILE AND .bam
        gz=$(find $data_folder/$p1 -type f | grep '\b.gz$')
	bam=$(find $data_folder/$p1 -type f | grep '\b.bam$')

        # DEFINE PREFIX AND EXTRACT INPATH FROM $path
        inpath=$(echo $gz | awk -F"/" 'BEGIN{FS=OFS="/"}{NF--; print}')
        prefix=$(echo $gz | awk -F"/" '{print $NF }' | awk -F"." '{print $1}')
		
        # IF NO .bam THEN CHECK FOR .gz
        if [[ ! $bam = *[!\ ]* ]]
                then
                # CHECK FOR .gz; IF NOT THERE THEN ls THE OTHER FILES IN THE SAME PATH
                if  [[ ! $gz = *[!\ ]* ]]; then ls -lt $p1 ;
                # IF .sra EXISTS THEN PRINT THE PREFIX AND THE INPATH AND LAUNCH THE EXTRACTION
                else ls -lt $gz;
                echo "prefix "$prefix
                echo "inpath "$inpath
                echo "launching alignment"
		qsub $HOME/Scratch/git_single_cell_sequencing_scripts/BWA_mem.sh $prefix $inpath $gz 
                fi
        # IF .bam ALREADY EXISTS THEN ls -lt
        else ls -lt $bam;
        echo "alignment already performed"
        fi

        echo " "
done

