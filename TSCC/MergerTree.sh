#!/usr/bin/env bash
#PBS -N AHF
#PBS -q condo
#PBS -l nodes=1:ppn=8
#PBS -l walltime=02:00:00
#PBS -j oe
#PBS -o MT.log
#PBS -d .

set -e
pwd
date
source ./module-reset.sh
cd ../halos/
pwd

# Set to directory of AHF_data
export MAIN_DIR=""
export OMP_NUM_THREADS=4

# Directory to output AHF data
export OUTPUT_DIR="${MAIN_DIR}AHF_data/AHF_output/"


python MergerTreeScript.py $OUTPUT_DIR
