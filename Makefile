# These are the only things you need to edit

# Main sim directory with output and AHF_data folders
# Uncomment this line and set to the MAIN_DIR of your simulation
#MAIN_DIR='/scratch/06185/tg854841/FIRE_2_0_or_h553_criden1000_noaddm_sggs_dust/Elemental/'

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
# Directory for halo history and MergerTree
HALOS_DIR=$(MAIN_DIR)'AHF_data/halos/'

# Download AHF
.PHONY: download
download:
	cd AHF/compile && $(MAKE) download


# Compile AHF
.PHONY: compile
compile:
	source ./module-reset.sh && cd AHF/compile && $(MAKE) compile

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

# Submit batch of AHF jobs
.PHONY: AHF
AHF:
	beginnum=$(STARTNUM) ; ((endnum=$(STARTNUM)+$(SNAPSTEP)-1)) ; while [[ $$endnum -le $(ENDNUM) ]] ; do \
		echo $$beginnum $$endnum ; \
		sbatch Amiga_profiles.pbs $(MAIN_DIR) $(OMP_NUM_THREADS) $$beginnum $$endnum ; \
		((beginnum = beginnum + $(SNAPSTEP))) ; \
		((endnum = endnum + $(SNAPSTEP))) ; \
	done

# Run MergerTree for AHF output
.PHONY: MergerTree
MergerTree:
	sbatch MergerTree.pbs $(MAIN_DIR) $(OMP_NUM_THREADS)

# Run ahfHaloHistory for AHF and MergerTree output
.PHONY: ahfHaloHistory
ahfHaloHistory:
	source ./module-reset.sh && cd $(HALOS_DIR) && python AHHScript.py
    # Uncomment this and comment out the line above if you are running for many halos
	#sbatch HaloHistory.pbs $(HALOS_DIR) $(OMP_NUM_THREADS)


