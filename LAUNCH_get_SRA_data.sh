


# THIS IS A SHELL SCRIPT FOR RETRIEVING ALL .sra FILES FROM THE ACCOMPANYING METAFILE


# META FILE PATH
# meta=$HOME/Scratch/RNASeq_data/GSE86618_meta_v3.csv
meta=$1

# PATH TO STORE OUTPUT DATA
#outpath=$HOME/Scratch/RNASeq_data
outpath=$2

# GET N FILES IN THE META
len=$(cat $meta | wc -l)

for ((i=2;i<=$len;i++))
do

# THIS COLUMN IS THE SUB DIRECTORY OF THE TARGET FILE
# IT IS NOT USED HERE BUT MAY BE IN FUTURE PROJECTS
# ftp1=$(less $meta | awk -F"," '{print $10}' | head -$i | tail -1)

# GRAB THE COLUMN FROM THE METAFILE
ftp2=$(less $meta | awk -F"," '{print $9}' | head -$i | tail -1)

# REMOVE QUOTATION MARKS FROM TEXT
ftp3=$(echo $ftp2 | tr -d '"' )

# REMOVE URL MARKER FROM STRING 
p1=$(echo $ftp3 | awk -F"//" '{print $2}')

# SEE IF THE .sra FILE EXISTS AND STORE PATH IN A VARIABLE
p2=$(find $outpath/$p1 -type f | grep '\bsra$')

# CHECK IF THE .sra FILE EXISTS AND IF NOT THEN GET FILE
if [[ ! $p2 = *[!\ ]* ]]; then wget -r --no-parent $ftp3; else echo "file $p1 exists"; fi
if [[ ! $p2 = *[!\ ]* ]]; then qsub get_SRA_data.sh $ftp3 $outpath; else echo "file $p1 exists"; fi

done

