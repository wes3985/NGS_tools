#!/bin/bash -l
#$ -S /bin/bash
#$ -l h_rt=12:0:0
#$ -N RNASeq
#$ -pe smp 12
#$ -wd /home/rmhawwo/Scratch/mRNA_raw_FASTQ_files
cd $TMPDIR

# MY R REPOSITORY
# export R_LIBS=/your/local/R/library/path:$R_LIBS

# module unload compilers/intel/2015/update2
# module unload mpi/intel/2015/update3/intel
#module unload compilers
#module unload mpi
#module unload java/1.8.0_45

#module load compilers/gnu/4.9.2
#module load mpi/openmpi/1.8.4/gnu-4.9.2
#module load java/1.8.0_92
#module load r/recommended
#module load r/old

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
R --no-save < /home/rmhawwo/Scratch/git_RNA_seq_scripts/Bioconducter_RNASeq_test.R > Bioconducter_RNASeq_test.out
tar zcvf $HOME/Scratch/lcm_RNASeq_batch1/LCM_BAMS/files_from_job_$JOB_ID.tgz $TMPDIR
