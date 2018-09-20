# THIS SHELL SCRIPT CHECKS FOR A indel.vcf FILE, IF A indel.vcf FILE IS PRESENT IT LAUNCHES A JOB TO CALL REALIGN AROUND THE INDELS

# EXAMPLE USAGE:
# $HOME/Scratch/git_single_cell_sequencing_scripts/LAUNCH_FIX_READ_GROUPS_AND_REALIGN_AROUND_INDELS.sh $HOME/Scratch/TNBC_data/SraRunTable.txt $HOME/Scratch/TNBC_data TNBC

# THE GROUP OF FILES TO BE EXTRACTED FROM ARE DERIVED FROM THE METAFILE
meta=$1
data_folder=$2
subgroup=$3

# data_folder=$HOME/Scratch/TNBC_data/

cd $data_folder

# GENERATE INFILE LIST
meta_prefix="ftp://ftp-trace.ncbi.nih.gov/sra/sra-instant/reads/ByRun/sra/"
bamExt="Aligned.dedup.bam"
vcfExt="Aligned.INDEL.vcf"
realinged=".realigned.bam"

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
	p2="$(echo $meta_prefix$three/$six/$f/$f$vcfExt |  awk -F"//" '{print $2}')"	
	p3="$(echo $meta_prefix$three/$six/$f/$f$realinged |  awk -F"//" '{print $2}')"	
        echo "path : "$path
        echo "p1 : "$p1


        # CHECK FOR dedup.bam AND INDEL.vcf
        dedup_bam=$(find $data_folder/$p1 -type f | grep '\b.dedup.bam$')
        indel_vcf=$(find $data_folder/$p2 -type f)
	realigned_bam=$(find $data_folder/$p3 -type f)
		

        # DEFINE PREFIX AND EXTRACT INPATH FROM $path
        inpath=$(echo $dedup_bam | awk -F"/" 'BEGIN{FS=OFS="/"}{NF--; print}')
        prefix=$(echo $dedup_bam | awk -F"/" '{print $NF }' | awk -F"." '{print $1}')

        # IF NO .INDEL.vcf THEN CHECK FOR dedup.bam
        if [[ ! $realigned_bam = *[!\ ]* ]]
                then
                # CHECK FOR dedup.bam; IF NOT THERE THEN ls THE OTHER FILES IN THE SAME PATH
                if  [[ ! $dedup_bam = *[!\ ]* ]]; then ls -lt $p1 ;
                # IF dedup.bam EXISTS THEN PRINT THE PREFIX AND THE INPATH AND LAUNCH THE EXTRACTION
                else ls -lt $dedup_bam;
                echo "prefix "$prefix
                echo "dedup "$dedup_bam
                echo "inpath "$inpath
		echo "indel vcf "$indel_vcf
                echo "Realignment around INDELs"
                qsub $HOME/Scratch/git_single_cell_sequencing_scripts/FIX_READ_GROUPS_AND_REALIGN_AROUND_INDELS.sh $prefix $dedup_bam $indel_vcf $inpath $subgroup
                fi
        # IF .realigned.bam ALREADY EXISTS THEN ls -lt
        else ls -lt $realigned_bam;
        echo "realignment already done"
        fi

        echo " "
done
