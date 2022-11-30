#!/usr/bin/env bash
#PBS -N AHF
#PBS -q condo
#PBS -l nodes=1:ppn=8
#PBS -l walltime=04:00:00
#PBS -j oe
#PBS -o AHF.log
#PBS -d .

set -e
pwd
date
source ./module-reset.sh
cd ../AHF/run/
pwd

# Set this to the AHF_data directory
export MAIN_DIR=""
# Number of OMP Threads
export OMP_NUM_THREADS=4
# Number of cores per thread. Should be ppn/OMP_threads. 2 cores per thread is probably good
export CORES_PER_THREAD=2
# Start and end snapshot numbers
export STARTNUM=1
export ENDNUM=600
# Enter 0/1 for if snapshots are divided into subsnaps
export MULTI_SNAP=0

# Directory of snapshots
export SNAP_DIR="${MAIN_DIR}output/"
# Directory to output AHF data
export OUTPUT_DIR="${MAIN_DIR}AHF_data/AHF_output/"
# Directory of the AMIGA exe file
export AMIGA_DIR="${MAIN_DIR}AHF_data/AHF/run/"

echo $SNAP_DIR
echo $OUTPUT_DIR
echo $AMIGA_DIR
echo $STARTNUM
echo $ENDNUM
echo $MULTI_SNAP

python TSCC_amigascript.py $SNAP_DIR $OUTPUT_DIR $AMIGA_DIR $CORES_PER_THREAD $STARTNUM $ENDNUM $MULTI_SNAP
