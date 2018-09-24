#!/bin/bash -l
#$ -l h_rt=8:00:00
#$ -cwd
#$ -l mem=4G
#$ -pe smp 1


declare -a pRoots=("/home/rmhawwo/Scratch/mRNA_raw_FASTQ_files/TGF+COMP-/9/UCLGNS1176-9_S24_L00" 
"/home/rmhawwo/Scratch/mRNA_raw_FASTQ_files/TGF+COMP-/7/UCLGNS1176-7_S22_L00"
"/home/rmhawwo/Scratch/mRNA_raw_FASTQ_files/TGF+COMP-/10/UCLGNS1176-10_S10_L00" "/home/rmhawwo/Scratch/mRNA_raw_FASTQ_files/TGF+COMP-/8/UCLGNS1176-8_S23_L00"
"/home/rmhawwo/Scratch/mRNA_raw_FASTQ_files/TGF-AZD+/17/UCLGNS1176-17_S13_L00" "/home/rmhawwo/Scratch/mRNA_raw_FASTQ_files/TGF-AZD+/13/UCLGNS1176-13_S11_L00"
"/home/rmhawwo/Scratch/mRNA_raw_FASTQ_files/TGF-AZD+/14/UCLGNS1176-14_S12_L00" "/home/rmhawwo/Scratch/mRNA_raw_FASTQ_files/TGF-AZD+/18/UCLGNS1176-18_S14_L00"
"/home/rmhawwo/Scratch/mRNA_raw_FASTQ_files/TGF+AZD+/22/UCLGNS1176-22_S18_L00" "/home/rmhawwo/Scratch/mRNA_raw_FASTQ_files/TGF+AZD+/21/UCLGNS1176-21_S17_L00"
"/home/rmhawwo/Scratch/mRNA_raw_FASTQ_files/TGF+AZD+/20/UCLGNS1176-20_S16_L00" "/home/rmhawwo/Scratch/mRNA_raw_FASTQ_files/TGF+AZD+/23/UCLGNS1176-23_S19_L00"
"/home/rmhawwo/Scratch/mRNA_raw_FASTQ_files/TGF-RAPA+/30/UCLGNS1176-30_S17_L00" "/home/rmhawwo/Scratch/mRNA_raw_FASTQ_files/TGF-RAPA+/28/UCLGNS1176-28_S15_L00"
"/home/rmhawwo/Scratch/mRNA_raw_FASTQ_files/TGF-RAPA+/29/UCLGNS1176-29_S16_L00" "/home/rmhawwo/Scratch/mRNA_raw_FASTQ_files/TGF-RAPA+/25/UCLGNS1176-25_S14_L00"
"/home/rmhawwo/Scratch/mRNA_raw_FASTQ_files/TGF+RAPA+/33/UCLGNS1176-33_S19_L00" "/home/rmhawwo/Scratch/mRNA_raw_FASTQ_files/TGF+RAPA+/36/UCLGNS1176-36_S21_L00"
"/home/rmhawwo/Scratch/mRNA_raw_FASTQ_files/TGF+RAPA+/32/UCLGNS1176-32_S18_L00" "/home/rmhawwo/Scratch/mRNA_raw_FASTQ_files/TGF+RAPA+/34/UCLGNS1176-34_S20_L00"
"/home/rmhawwo/Scratch/mRNA_raw_FASTQ_files/TGF-COMP-/2/UCLGNS1176-2_S15_L00" "/home/rmhawwo/Scratch/mRNA_raw_FASTQ_files/TGF-COMP-/1/UCLGNS1176-1_S9_L00"
"/home/rmhawwo/Scratch/mRNA_raw_FASTQ_files/TGF-COMP-/3/UCLGNS1176-3_S20_L00" "/home/rmhawwo/Scratch/mRNA_raw_FASTQ_files/TGF-COMP-/5/UCLGNS1176-5_S21_L00")

# USES "p" and "n" for positive and negative respectively
declare -a catFiles=("$HOME/Scratch/mRNA_raw_FASTQ_files/TGFpCOMPn_9" "$HOME/Scratch/mRNA_raw_FASTQ_files/TGFpCOMPn_7"
"$HOME/Scratch/mRNA_raw_FASTQ_files/TGFpCOMPn_10" "$HOME/Scratch/mRNA_raw_FASTQ_files/TGFpCOMPn_8"
"$HOME/Scratch/mRNA_raw_FASTQ_files/TGFnAZDp_17" "$HOME/Scratch/mRNA_raw_FASTQ_files/TGFnAZDp_13"
"$HOME/Scratch/mRNA_raw_FASTQ_files/TGFnAZDp_14" "$HOME/Scratch/mRNA_raw_FASTQ_files/TGFnAZDp_18"
"$HOME/Scratch/mRNA_raw_FASTQ_files/TGFpAZDp_22" "$HOME/Scratch/mRNA_raw_FASTQ_files/TGFpAZDp_21"
"$HOME/Scratch/mRNA_raw_FASTQ_files/TGFpAZDp_20" "$HOME/Scratch/mRNA_raw_FASTQ_files/TGFpAZDp_23"
"$HOME/Scratch/mRNA_raw_FASTQ_files/TGFnRAPAp_30" "$HOME/Scratch/mRNA_raw_FASTQ_files/TGFnRAPAp_28"
"$HOME/Scratch/mRNA_raw_FASTQ_files/TGFnRAPAp_29" "$HOME/Scratch/mRNA_raw_FASTQ_files/TGFnRAPAp_25"
"$HOME/Scratch/mRNA_raw_FASTQ_files/TGFpRAPAp_33" "$HOME/Scratch/mRNA_raw_FASTQ_files/TGFpRAPAp_36"
"$HOME/Scratch/mRNA_raw_FASTQ_files/TGFpRAPAp_32" "$HOME/Scratch/mRNA_raw_FASTQ_files/TGFpRAPAp_34"
"$HOME/Scratch/mRNA_raw_FASTQ_files/TGFnCOMPn_2" "$HOME/Scratch/mRNA_raw_FASTQ_files/TGFnCOMPn_1"
"$HOME/Scratch/mRNA_raw_FASTQ_files/TGFnCOMPn_3" "$HOME/Scratch/mRNA_raw_FASTQ_files/TGFnCOMPn_5")

path_ext="_001.fastq.gz"
FWD_ext=".FWD.fastq.gz"
REV_ext=".REV.fastq.gz"
declare -a R1_lanes=("1_R1" "2_R1" "3_R1" "4_R1")
declare -a R2_lanes=("1_R2" "2_R2" "3_R2" "4_R2")

for ((j=0;j<24;++j)); 
do
pR=${pRoots[j]}
catF=${catFiles[j]}
echo $catF$FWD_ext
echo $catF$REV_ext
# rm $catF$FWD_ext
# rm $catF$REV_ext
touch $catF$FWD_ext
touch $catF$REV_ext
for ((i=0;i<5;++i)); 
do
iFWD=$(echo ${R1_lanes[i]}) 
iREV=$(echo ${R2_lanes[i]})
echo $pR$iFWD$path_ext
echo $pR$iREV$path_ext
cat $catF$FWD_ext $pR$iFWD$path_ext >> $catF$FWD_ext
cat $catF$REV_ext $pR$iREV$path_ext >> $catF$REV_ext
done
done
