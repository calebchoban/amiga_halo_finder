#!/bin/sh
#SBATCH -J Halo_History
#SBATCH -p development
#SBATCH -t 01:00:00
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -A AST20016
#SBATCH --mail-user=EMAIL
#SBATCH --mail-type=all
#SBATCH -o HH.log
#SBATCH --export=ALL
#SBATCH -D .
set -e
pwd
date
source ./module-reset.sh
cd $1
pwd

export OMP_NUM_THREADS=$2


python AHHScript.py $3 $4 $5
