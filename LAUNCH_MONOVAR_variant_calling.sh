# THIS IS A SHELL SCRIPT TO LAUNCH JOBS FOR  ALIGNMENT
# IF ARGUMENT $3 IS NOT SUPPLIED THEN ALL SUBGROUPS FROM THE METAFILE WILL BE PROCESSED INSTEAD OF SAMPLE SUBGROUPS

# USAGE EXAMPLE
# $HOME/Scratch/git_single_cell_sequencing_scripts/LAUNCH_MONOVAR_variant_calling.sh $HOME/Scratch/RNASeq_data/GSE86618_meta_v3.csv \
$HOME/Scratch/RNASeq_data/IPF010_bams IPF010

# THE GROUP OF FILES TO BE EXTRACTED FROM ARE DERIVED FROM THE METAFILE
meta=$1
data_folder=$2
subgroup=$3

# data_folder=$HOME/Scratch/RNASeq_data/

cd $data_folder

# STORES INFILES, TAKES ACCOUNT OF SPECIFIC SUB-GROUPS IF SPECIFIED
infiles=$(cat $meta | grep $subgroup | awk -F"," '{print $9}' | tr -d \")

# LIST OF CHROMS
declare -a chroms=("1" "2" "3" "4" "5" "6" "7" "8" "9" "10" "11" "12" "13" "14" "15" "16" "17" "18" "19" "20" "21" "22" "X" "Y" "MT")

#PRODUCE LIST OF BAM FILES FOR THE SAMPLE GROUP AND SAVE
ext_bam_list="_BAM_list.txt"
rm $subgroup$ext_bam_list
touch $subgroup$ext_bam_list

for f in $infiles
do
        # GET PATH
        p1=$(echo $f | awk -F"//" '{print $2}')

        # CHECK FOR FINAL BAM FILES
        BAM_final=$(find $data_folder/$p1 -type f | grep '.realigned.bam')

        # DEFINE PREFIX AND EXTRACT INPATH FROM $f
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

for c in "${chroms[@]}"
do
	echo $subgroup $c $subgroup$ext_bam_list
	#qsub $HOME/Scratch/git_single_cell_sequencing_scripts/MONOVAR_variant_calling.sh $subgroup $c $subgroup$ext_bam_list 
done
