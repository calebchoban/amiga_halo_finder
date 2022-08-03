#!/bin/sh
#SBATCH -J AHF
#SBATCH -p small
#SBATCH -t 48:00:00
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -A AST20016
#SBATCH --mail-user=EMAIL
#SBATCH --mail-type=all
#SBATCH -o amiga.log%j
#SBATCH --export=ALL
#SBATCH -D .


set -e
pwd
date
source ./module-reset.sh
cd ./AHF/run/
pwd

export MAIN_DIR=$1
export OMP_NUM_THREADS=$2
export STARTNUM=$3
export ENDNUM=$4
export MULTI_SNAP=$5

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

python amigascript.py $SNAP_DIR $OUTPUT_DIR $AMIGA_DIR $STARTNUM $ENDNUM $MULTI_SNAP
