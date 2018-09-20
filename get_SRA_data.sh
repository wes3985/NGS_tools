#!/bin/bash -l
#$ -l h_rt=6:00:00
#$ -cwd
#$ -pe mpi 1

cd $2

echo $1
echo $2
wget -r --no-parent $1
