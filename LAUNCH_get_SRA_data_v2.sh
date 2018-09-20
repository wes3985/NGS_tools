# THIS IS A SHELL SCRIPT FOR RETRIEVING ALL .sra FILES FROM THE ACCOMPANYING METAFILE FROM THE FOLLOWING URL
# https://www.ncbi.nlm.nih.gov/Traces/study/?WebEnv=NCID_1_13090614_130.14.18.48_5555_1503392746_1461040313_0MetA0_S_HStore&query_key=6

# EXAMPLE LAUNCH:
# $HOME/Scratch/git_single_cell_sequencing_scripts/LAUNCH_get_SRA_data_v2.sh \
#	$HOME/Scratch/TNBC_data/SraRunTable.txt $HOME/Scratch/TNBC_data

# META FILE PATH
# meta=$HOME/Scratch/TNBC_data/SraRunTable.txt
meta=$1

# PATH TO STORE OUTPUT DATA
#outpath=$HOME/Scratch/TNBC_data
outpath=$2

# SCRIPT TO CALL
get_SRA_data=$HOME/Scratch/git_single_cell_sequencing_scripts/get_SRA_data.sh

# GET N FILES IN THE META
len=$(cat $meta | wc -l)

# PREFIX FOR THE DOWNLOAD
prefix="ftp://ftp-trace.ncbi.nih.gov/sra/sra-instant/reads/ByRun/sra/"
ext=".sra"

# CONSTRUCT THE REMAINDER OF THE DOWNLOAD PATH FROM THE METAFILE
# SRR/SRR304/SRR304976/SRR304976.sra

# i=2 PRESUMES THE METAFILE HAS A HEADER
for ((i=2;i<=$len;i++))
do

# GRAB THE PATH COLUMN FROM THE METAFILE
#ftp1=$(less $meta | awk -F"\t" '{print $13}' | head -$i | tail -1)
#ftp1=$(less $meta | awk -F"\t" '{print $10}' | head -$i | tail -1)
ftp1=$(less $meta | awk -F"\t" '{print $7}' | head -$i | tail -1)
three="${ftp1:0:3}" 
six="${ftp1:0:6}"
path="$(echo $prefix$three/$six/$ftp1/$ftp1$ext)"
echo $path

# REMOVE URL MARKER FROM STRING
p1=$(echo $path | awk -F"//" '{print $2}')

# SEE IF THE .sra FILE EXISTS AND STORE PATH IN A VARIABLE
p2=$(find $outpath/$p1 -type f | grep '\bsra$')

# CHECK IF THE .sra FILE EXISTS AND IF NOT THEN GET FILE
#if [[ ! $p2 = *[!\ ]* ]]; then wget -r --no-parent $path; else echo "file $p1 exists"; fi
if [[ ! $p2 = *[!\ ]* ]]; then qsub $get_SRA_data $path $outpath; else echo "file $p1 exists"; fi

done
