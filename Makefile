# These are the only things you need to edit

# Main sim directory with output and AHF_data folders
MAIN_DIR='/scratch/06185/tg854841/FIRE_2_0_or_h553_criden1000_noaddm_sggs_dust/Elemental/'
# Start and end snapshot numbers
STARTNUM=001
ENDNUM=600
# Number of snapshots each job will cover
SNAPSTEP=30 # Make sure the range you give is divisible by the SNAPSTEP
OMP_NUM_THREADS=16


###############################################################################
# Don't change anything below
###############################################################################
# Directory of snapshots
SNAP_DIR=$(MAIN_DIR)'output/'
# Directory to output AHF data
OUTPUT_DIR=$(MAIN_DIR)'AHF_data/AHF_output/'
# Directory of the AMIGA exe file
AMIGA_DIR=$(MAIN_DIR)'AHF_data/AHF/run/'
# Directory for MergerTree exe file
MTREE_DIR=$(MAIN_DIR)'AHF_data/MergerTree/'
# Directory for halo history output
HALOS_DIR=$(MAIN_DIR)'AHF_data/halos/'


# Install and compile Amiga
.PHONY: compile
compile:
	source ./module-reset.sh && cd AHF/compile && make

# Clear Amiga program. Use this if there are issues with installation before trying again.
.PHONY: clear
clear:
	rm -r ./AHF/compile/ahf-v1.0-100
	rm ./AHF/compile/AHF
	rm ./AHF/compile/MergerTree
	rm ./AHF/compile/ahfHaloHistory

# Delete the AHF_output folder and all halo files!
.PHONY: delete
delete:
	rm -r ./AHF_output/

# Submit batch of jobs to scheduler
.PHONY: submit
submit:
	beginnum=$(STARTNUM) ; endnum=$(SNAPSTEP) ; while [[ $$endnum -le $(ENDNUM) ]] ; do \
		echo $$beginnum $$endnum ; \
		sbatch Amiga_profiles.pbs $(MAIN_DIR) $(OMP_NUM_THREADS) $$beginnum $$endnum ; \
		((beginnum = beginnum + $(SNAPSTEP))) ; \
		((endnum = endnum + $(SNAPSTEP))) ; \
	done

# Run MergerTree for AHF output
.PHONY: MergerTree
MergerTree:
	sbatch MergerTree.pbs $(MAIN_DIR) $(OMP_NUM_THREADS)
	#source ./module-reset.sh && cd $(MTREE_DIR) && python MergerTreeScript.py $(OUTPUT_DIR)

# Run ahfHaloHistory for AHF and MergerTree output
.PHONY: ahfHaloHistory
ahfHaloHistory:
	source ./module-reset.sh && cd $(MTREE_DIR) && python AHHScript.py $(OUTPUT_DIR) $(HALOS_DIR)


