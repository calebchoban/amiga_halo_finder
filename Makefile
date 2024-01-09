# These are the only things you need to edit

# Main sim directory with output and AHF_data folders
# Uncomment these lines and set to the MAIN_DIR of your simulation and no/yes (0/1) if the snapshots are split
MAIN_DIR='/N/scratch/cchoban/HiZ_dust/new_z5m11d/'
MULTI_SNAPS=0

# Start and end snapshot numbers
STARTNUM=10
ENDNUM=36
# Number of snapshots each job will cover
SNAPSTEP=26 # Make sure the range you give is divisible by the SNAPSTEP
# Make sure to check if you need to set this in your job submission scripts (e.g. AHF.sh)
OMP_NUM_THREADS=8

# Start and end snap numbers for halo history.
HH_STARTNUM=10
HH_ENDNUM=68

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
		sbatch AHF.sh $(MAIN_DIR) $(OMP_NUM_THREADS) $$beginnum $$endnum $(MULTI_SNAPS) ; \
		((beginnum = beginnum + $(SNAPSTEP))) ; \
		((endnum = endnum + $(SNAPSTEP))) ; \
	done

# Run MergerTree for AHF output
.PHONY: MergerTree
MergerTree:
	sbatch MergerTree.sh $(MAIN_DIR) $(OMP_NUM_THREADS)

# Run ahfHaloHistory for AHF and MergerTree output
.PHONY: ahfHaloHistory
ahfHaloHistory:
	source ./module-reset.sh && cd $(HALOS_DIR) && python AHHScript.py $(OUTPUT_DIR) $(HH_STARTNUM) $(HH_ENDNUM)
	# Uncomment this and comment out the line above if you are running for many halos
	#sbatch HaloHistory.sh $(HALOS_DIR) $(OMP_NUM_THREADS) $(OUTPUT_DIR) $(HH_STARTNUM) $(HH_ENDNUM)


.PHONY: AHF_TSCC
AHF_TSCC:
	cd TSCC && qsub AHF.sh

.PHONY: compile_TSCC
compile_TSCC:
	source ./TSCC/module-reset.sh && cd AHF/compile && $(MAKE) compile_TSCC

# Run MergerTree for AHF output
.PHONY: MergerTree_TSCC
MergerTree_TSCC:
	cd TSCC && qsub MergerTree.sh

# Run ahfHaloHistory for AHF and MergerTree output
.PHONY: ahfHaloHistory_TSCC
ahfHaloHistory_TSCC:
	source ./TSCC/module-reset.sh && cd $(HALOS_DIR) && python AHHScript.py $(OUTPUT_DIR) $(HH_STARTNUM) $(HH_ENDNUM)


.PHONY: AHF_BigRed
AHF_BigRed:
	cd BigRed; \
	beginnum=$(STARTNUM) ; ((endnum=$(STARTNUM)+$(SNAPSTEP)-1)) ; while [[ $$endnum -le $(ENDNUM) ]] ; do \
        	echo $$beginnum $$endnum ; \
        	sbatch AHF.sh $(MAIN_DIR) $(OMP_NUM_THREADS) $$beginnum $$endnum $(MULTI_SNAPS) ; \
        	((beginnum = beginnum + $(SNAPSTEP))) ; \
       		((endnum = endnum + $(SNAPSTEP))) ; \
	done


.PHONY: compile_BigRed
compile_BigRed:
	source ./BigRed/module-reset.sh && cd AHF/compile && $(MAKE) compile_BigRed

# Run MergerTree for AHF output
.PHONY: MergerTree_BigRed
MergerTree_BigRed:
	cd BigRed && sbatch MergerTree.sh $(MAIN_DIR) $(OMP_NUM_THREADS)


# Run ahfHaloHistory for AHF and MergerTree output
.PHONY: ahfHaloHistory_BigRed
ahfHaloHistory_BigRed:
	source ./BigRed/module-reset.sh && cd $(HALOS_DIR) && python AHHScript.py $(OUTPUT_DIR) $(HH_STARTNUM) $(HH_ENDNUM)

