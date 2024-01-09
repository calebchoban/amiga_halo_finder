#!/bin/sh
#SBATCH -J MergerTree
#SBATCH -p general
#SBATCH -t 02:00:00
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -A r00380
#SBATCH --mail-user=EMAIL
#SBATCH --mail-type=fail
#SBATCH -o MT.log
#SBATCH --export=ALL
#SBATCH -D .

set -e
pwd
date
source ./module-reset.sh
cd ../halos/
pwd

export MAIN_DIR=$1
export OMP_NUM_THREADS=$2

# Directory to output AHF data
export OUTPUT_DIR="${MAIN_DIR}AHF_data/AHF_output/"


python MergerTreeScript.py $OUTPUT_DIR
