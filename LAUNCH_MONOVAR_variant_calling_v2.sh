# THIS IS A SHELL SCRIPT TO LAUNCH JOBS FOR  ALIGNMENT
# IF ARGUMENT $3 IS NOT SUPPLIED THEN ALL SUBGROUPS FROM THE METAFILE WILL BE PROCESSED INSTEAD OF SAMPLE SUBGROUPS

# USAGE EXAMPLE
# $HOME/Scratch/git_single_cell_sequencing_scripts/LAUNCH_MONOVAR_variant_calling_v2.sh $HOME/Scratch/TNBC_data/SraRunTable.txt $HOME/Scratch/TNBC_data TNBC

# THE GROUP OF FILES TO BE EXTRACTED FROM ARE DERIVED FROM THE METAFILE
meta=$1
data_folder=$2
subgroup=$3

cd $data_folder

# MAIN INPUT FILE EXTENSION
meta_prefix="ftp://ftp-trace.ncbi.nih.gov/sra/sra-instant/reads/ByRun/sra/"
ext=".realigned.bam"

# GET N FILES IN THE META
len=$(cat $meta | wc -l)

# STORES INFILES, TAKES ACCOUNT OF SPECIFIC SUB-GROUPS IF SPECIFIED
infiles=$(cat $meta | grep $subgroup | awk -F"\t" '{print $10}')


#PRODUCE LIST OF BAM FILES FOR THE SAMPLE GROUP AND SAVE
ext_bam_list="_BAM_list.txt"
rm $subgroup$ext_bam_list
touch $subgroup$ext_bam_list

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

        # CHECK FOR .bam SPECIFIED BY ext
	#BAM_final=$(find $data_folder/$p1 -type f | grep '\b.dedup.bam$')
	BAM_final=$(find $data_folder/$p1 -type f)

        # DEFINE PREFIX AND EXTRACT INPATH FROM $path
        inpath=$(echo $BAM_final | awk -F"/" 'BEGIN{FS=OFS="/"}{NF--; print}')
        prefix=$(echo $BAM_final | awk -F"/" '{print $NF }' | awk -F"." '{print $1}')
		
        echo "PREFIX: "$prefix
        echo "INPATH: "$inpath
        echo "FINAL BAM: "$BAM_final
        # ADD FILE PATH TO LIST OF BAM FILES IF FILE EXISTS
        if [[ $BAM_final = *[!\ ]* ]]
                then
                echo $BAM_final >> $subgroup$ext_bam_list
        else
                echo "Final BAM doesn't exist"
        fi
        echo ""

done


total_bams=$(cat $subgroup$ext_bam_list | wc -l)
echo "number of bams to process: "$total_bams

# LAUNCH VARIANT CALLING PER CHROMOSOME

# LIST OF CHROMS
declare -a chroms=("1" "2" "3" "4" "5" "6" "7" "8" "9" "10" "11" "12" "13" "14" "15" "16" "17" "18" "19" "20" "21" "22" "X" "Y" "MT")

for c in "${chroms[@]}"
do
        echo $subgroup $c $subgroup$ext_bam_list
        qsub $HOME/Scratch/git_single_cell_sequencing_scripts/MONOVAR_variant_calling.sh $subgroup $c $subgroup$ext_bam_list
done
