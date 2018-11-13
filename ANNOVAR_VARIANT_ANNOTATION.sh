!/bin/bash -l
#$ -l h_rt=4:00:00
#$ -cwd
#$ -pe smp 1

# SUGGEST TO USE "ChrNTNBC" FOR SAMPLE
sample=$1
full_vcf_path=$2
outpath=$3

outExt=".annotated"

export annovar=$HOME/software/annovar

echo $sample
echo $full_vcf_path
echo $outpath

#ANNOTATE VARIANTS
$annovar/table_annovar.pl $full_vcf_path $annovar/humandb/ -buildver hg38 -out \
$outpath/$sample$outExt -remove -protocol \
refGene,avsnp147 -operation g,f \
-nastring . -vcfinput

echo "complete"
