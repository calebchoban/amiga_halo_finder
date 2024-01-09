#!/bin/sh
#SBATCH -J AHF
#SBATCH -p general
#SBATCH -t 04:00:00
#SBATCH --nodes=1              # Total # of nodes 
#SBATCH --ntasks-per-node=16    # Total # of mpi tasks per node = # of Cores per Node (128) / OMP_NUM_THREADS
#SBATCH --cpus-per-task=8
#SBATCH --mem=240GB
#SBATCH -A r00380
#SBATCH --mail-user=EMAIL
#SBATCH --mail-type=fail
#SBATCH -o amiga.log
#SBATCH --export=ALL
#SBATCH -D .


set -e
pwd
date
source ./module-reset.sh
cd ../AHF/run/
pwd

# Set this to the AHF_data directory
export MAIN_DIR=$1
# Number of OMP Threads
export OMP_NUM_THREADS=$2
# Start and end snapshot numbers
export STARTNUM=$3
export ENDNUM=$4
# Enter 0/1 for if snapshots are divided into subsnaps
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


python BigRed_amigascript.py $SNAP_DIR $OUTPUT_DIR $AMIGA_DIR $STARTNUM $ENDNUM $MULTI_SNAP $SLURM_JOB_NUM_NODES $SLURM_NTASKS_PER_NODE $OMP_NUM_THREADS 
