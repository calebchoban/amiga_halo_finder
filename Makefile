# These are the only things you need to edit

# Main sim directory with output and AHF_data folders
MAIN_DIR='/oasis/tscc/scratch/cchoban/FIRE_2_0_or_h553_criden1000_noaddm_sggs_dust/Elemental/'
# Start and end snapshot numbers
STARTNUM=001
ENDNUM=10
# Number of snapshots each job will cover
SNAPSTEP=5 # Make sure the range you give is divisible by the SNAPSTEP
OMP_NUM_THREADS=2


###############################################################################
# Don't change anything below
###############################################################################
# Directory of snapshots
SNAP_DIR=$(MAIN_DIR)'output/'
# Directory to output AHF data
OUTPUT_DIR=$(MAIN_DIR)'AHF_data/AHF_output/'
# Directory of the AMIGA exe file
AMIGA_DIR=$(MAIN_DIR)'AHF_data/AHF/run/'


# Install and compile Amiga
.PHONY: compile
compile:
	source module-reset.sh && cd AHF/compile && make


# Submit batch of jobs to scheduler
.PHONY: submit
submit:
	beginnum=$(STARTNUM) ; endnum=$(SNAPSTEP) ; while [[ $$endnum -le $(ENDNUM) ]] ; do \
		echo $$beginnum $$endnum ; \
		sbatch Amiga_profiles.pbs $$(MAIN_DIR) $$OMP_NUM_THREADS $$beginnum $$endnum ; \
		((beginnum = beginnum + $(SNAPSTEP))) ; \
		((endnum = endnum + $(SNAPSTEP))) ; \
	done

# Read Amiga halos
.PHONY: read
read:
	python AHF_halos_catalog_reader.py

# Submit job to scheduler for all snapshots at once
#.PHONY: submit
#submit:
#	qsub Amiga_profiles.pbs



