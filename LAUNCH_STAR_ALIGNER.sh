

# THIS IS A SHELL SCRIPT TO LAUNCH JOBS FOR  ALIGNMENT
# IF ARGUMENT $3 IS SUPPLIED THEN SUBGROUPS FROM THE METAFILE WILL BE PROCESSED INSTEAD OF THE WHOLE FILE

# USAGE EXAMPLE
# ./LAUNCH_STAR_ALIGNER.sh $HOME/Scratch/RNASeq_data/GSE86618_meta_v3.csv $HOME/Scratch/RNASeq_data IPF009

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

        # CHECK FOR FILES
        gz=$(find $data_folder/$p1 -type f | grep '\b.gz$')
	BAMLog=$(find $data_folder/$p1 -type f | grep 'Log.out')
	BAM1=$(find $data_folder/$p1 -type f | grep 'Aligned.sortedByCoord.out.bam')
	BAM_final=$(find $data_folder/$p1 -type f | grep '.split.bam')

        # DEFINE PREFIX AND EXTRACT INPATH FROM $f
        inpath=$(echo $gz | awk -F"/" 'BEGIN{FS=OFS="/"}{NF--; print}')
        prefix=$(echo $gz | awk -F"/" '{print $NF }' | awk -F"." '{print $1}')

        # IF NO Log.out THEN CHECK FOR .gz AND BEGIN ALIGNMENT
        if [[ ! $BAMLog = *[!\ ]* ]]
                then
                # CHECK FOR .gz; IF NOT THERE THEN ls THE OTHER FILES IN THE SAME PATH
                if  [[ ! $gz = *[!\ ]* ]]; then ls -lt $p1 ;
                # IF .gz EXISTS THEN PRINT THE PREFIX AND THE INPATH AND LAUNCH THE ALIGNMENT
                else ls -lt $gz;
                echo "prefix "$prefix
                echo "inpath "$inpath
		echo $BAMLog
		echo "no Log.out, starting alignment"
                qsub $HOME/Scratch/git_single_cell_sequencing_scripts/STAR_ALIGNER.sh $prefix $inpath $inpath
		echo " "
                fi
        # IF Log.out ALREADY EXISTS THEN CHECK THE ALIGNMENT COMPLETED, IF NOT THEN RE-LAUNCH
        elif [[ $BAMLog = *[!\ ]* ]]
		then
		# CHECK ALIGNMENT COMPLETED
		BAMStatus=$(cat $BAMLog | tail -1)
		echo "Final line of "$BAMLog
		echo "Log.out present, final entry; "$BAMStatus
		if [[ ! $BAMStatus =~ "ALL DONE!" ]]
			then
			echo "prefix "$prefix
                	echo "inpath "$inpath
			echo "Alignment not complete, restarting"
			qsub $HOME/Scratch/git_single_cell_sequencing_scripts/STAR_ALIGNER.sh $prefix $inpath $inpath
			echo " "
		else
			size=$(ls -lt $BAM1 | awk -F" " '{print $5}')
			if [[ $size == "28" || $size == "0" ]]
			then
				ls -lt $BAM1
				echo "Alignment file looks suspiciously small, repeating alignment"
				qsub $HOME/Scratch/git_single_cell_sequencing_scripts/STAR_ALIGNER.sh $prefix $inpath $inpath
				echo " "
			else
				echo "Alignment previously performed and completed"	
				ls -lt $BAM1
				# IF THERE IS NO FINAL BAM THEN LAUNCH POST ALIGNMENT SCRIPT
				if [[ ! $BAM_final = *[!\ ]* ]]
					then
					echo "Launching POST_ALIGNMENT_PROCESSING.sh"
					qsub $HOME/Scratch/git_single_cell_sequencing_scripts/POST_ALIGNMENT_PROCESSING.sh $prefix $inpath
				# IF THERE IS A FINAL BAM THEN DO....
				elif [[ $BAM_final = *[!\ ]* ]]
					then
					echo "Final BAM present"
					ls -lt $BAM_final
				fi	
				echo " "
			fi
		fi 
        fi

done

