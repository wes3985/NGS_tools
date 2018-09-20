# THIS SHELL SCRIPT CHECKS FOR A .bam FILE, IF A .bam FILE IS PRESENT IT LAUNCHES A JOB TO PERFORM ALIGNMENT

# EXAMPLE USAGE:
# $HOME/Scratch/git_single_cell_sequencing_scripts/LAUNCH_MARK_DUPS_AND_INDEX.sh $HOME/Scratch/TNBC_data/SraRunTable.txt $HOME/Scratch/TNBC_data TNBC

# THE GROUP OF FILES TO BE EXTRACTED FROM ARE DERIVED FROM THE METAFILE
meta=$1
data_folder=$2
subgroup=$3

# data_folder=$HOME/Scratch/TNBC_data/

cd $data_folder

# GENERATE INFILE LIST
meta_prefix="ftp://ftp-trace.ncbi.nih.gov/sra/sra-instant/reads/ByRun/sra/"
#ext=".bam"
ext="Aligned.sortedByCoord.out.bam"
bamExt=".dedup.bam"

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

        # CHECK FOR .bam
        bam=$(find $data_folder/$p1 -type f | grep '\b.bam$')
	dedup_bam=$(find $data_folder/$p1 -type f | grep '\b.dedup.bam$')

        # DEFINE PREFIX AND EXTRACT INPATH FROM $path
        inpath=$(echo $bam | awk -F"/" 'BEGIN{FS=OFS="/"}{NF--; print}')
        prefix=$(echo $bam | awk -F"/" '{print $NF }' | awk -F"." '{print $1}')

        # IF NO .dedup.bam THEN CHECK FOR .bam
        if [[ ! $dedup_bam = *[!\ ]* ]]
                then
                # CHECK FOR .bam; IF NOT THERE THEN ls THE OTHER FILES IN THE SAME PATH
                if  [[ ! $bam = *[!\ ]* ]]; then ls -lt $p1 ;
                # IF .bam EXISTS THEN PRINT THE PREFIX AND THE INPATH AND LAUNCH THE EXTRACTION
                else ls -lt $bam;
                echo "prefix "$prefix
                echo "inpath "$inpath
                echo "launching mark duplicates"
                #qsub $HOME/Scratch/git_single_cell_sequencing_scripts/BWA_mem.sh $prefix $inpath $gz
		qsub $HOME/Scratch/git_single_cell_sequencing_scripts/MARK_DUPS_AND_INDEX.sh $prefix $bam $inpath
                #qsub $HOME/Scratch/git_single_cell_sequencing_scripts/MARK_DUPS_AND_INDEX.sh $prefix $path $inpath
		fi
        # IF .dedup.bam ALREADY EXISTS THEN ls -lt
        else ls -lt $bam;
        echo "duplicates already marked"
        fi

        echo " "
done
