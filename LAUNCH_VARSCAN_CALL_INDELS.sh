# THIS SHELL SCRIPT CHECKS FOR A dedup.bam FILE, IF A dedup.bam FILE IS PRESENT IT LAUNCHES A JOB TO CALL INDELS

# EXAMPLE USAGE:
# $HOME/Scratch/git_single_cell_sequencing_scripts/LAUNCH_VARSCAN_CALL_INDELS.sh $HOME/Scratch/TNBC_data/SraRunTable.txt $HOME/Scratch/TNBC_data TNBC

# THE GROUP OF FILES TO BE EXTRACTED FROM ARE DERIVED FROM THE METAFILE
meta=$1
data_folder=$2
subgroup=$3

# data_folder=$HOME/Scratch/TNBC_data/

cd $data_folder

# GENERATE INFILE LIST
meta_prefix="ftp://ftp-trace.ncbi.nih.gov/sra/sra-instant/reads/ByRun/sra/"
bamExt="Aligned.dedup.bam"
vcfExt=".INDEL.vcf"

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
        path="$(echo $meta_prefix$three/$six/$f/$f$bamExt)"
        p1=$(echo $path | awk -F"//" '{print $2}')
        echo "path : "$path
        echo "p1 : "$p1

        # CHECK FOR dedup.bam
        dedup_bam=$(find $data_folder/$p1 -type f | grep '\b.dedup.bam$')
	indel_vcf=$(find $data_folder/$p1 -type f | grep '\b.INDEL.vcf$')

        # DEFINE PREFIX AND EXTRACT INPATH FROM $path
        inpath=$(echo $dedup_bam | awk -F"/" 'BEGIN{FS=OFS="/"}{NF--; print}')
        prefix=$(echo $dedup_bam | awk -F"/" '{print $NF }' | awk -F"." '{print $1}')

        # IF NO .INDEL.vcf THEN CHECK FOR dedup.bam
        if [[ ! $indel_vcf = *[!\ ]* ]]
                then
                # CHECK FOR .bam; IF NOT THERE THEN ls THE OTHER FILES IN THE SAME PATH
                if  [[ ! $dedup_bam = *[!\ ]* ]]; then ls -lt $p1 ;
                # IF dedup.bam EXISTS THEN PRINT THE PREFIX AND THE INPATH AND LAUNCH THE EXTRACTION
                else ls -lt $dedup_bam;
                echo "prefix "$prefix
		echo "dedup "$dedup_bam
                echo "inpath "$inpath
                echo "INDEL calling"
                qsub $HOME/Scratch/git_single_cell_sequencing_scripts/VARSCAN_CALL_INDELS.sh $prefix $dedup_bam $inpath
                fi
        # IF .INDEL.vcf ALREADY EXISTS THEN ls -lt
        else ls -lt $indel_vcf;
        echo "INDELS already called"
        fi

        echo " "
done
