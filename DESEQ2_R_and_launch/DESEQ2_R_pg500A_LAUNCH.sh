#!/bin/bash -l
#$ -S /bin/bash
#$ -l h_rt=12:0:0
#$ -N RNASeqpg500A
#$ -pe smp 6
#$ -wd /home/rmhawwo/Scratch/batch3_admera/batch3_RNA_alignment
export LANG=C.UTF-8
cd $TMPDIR

module unload compilers
module unload gmt/recommended
module unload mpi
module load compilers/gnu/4.9.2
module load perl/5.22.0
module load python/2.7.12
module load hdf/5-1.8.15/gnu-4.9.2
module load netcdf/4.3.3.1/gnu-4.9.2
module load gdal/2.0.0
module load libtool/2.4.6
module load graphicsmagick/1.3.21
module load ghostscript/9.19/gnu-4.9.2
module load fftw/3.3.4/gnu-4.9.2
module load gmt/5.3.1
module load mpi/openmpi/1.10.1/gnu-4.9.2
module load r/recommended

# R --no-save < $R_script > $R_output
R --no-save < /home/rmhawwo/Scratch/git_single_cell_sequencing_scripts/NGS_tools/DESEQ2_R_and_launch/DESEQ2_R_pg500A_R.R > Bioconducter_RNASeq_pg500A.out
tar zcvf $HOME/Scratch/batch3_admera/batch3_RNA_alignment/files_from_job_$JOB_ID.tgz $TMPDIR
