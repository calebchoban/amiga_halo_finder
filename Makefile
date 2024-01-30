GITHUB_URL = https://github.com/NegriAndrea/AHF.git
AHF_DIR = amiga

# Download AHF
.PHONY: download
download:
	git clone $(GITHUB_URL) $(AHF_DIR)

# Compile AHF
.PHONY: compile
compile:
	source ./activate.sh && cd $(AHF_DIR) && make AHF && make MergerTree && make ahfHaloHistory
	ln -s $(AHF_DIR)/bin/AHF* AHF
	ln -s $(AHF_DIR)/bin/MergerTree MergerTree
	ln -s $(AHF_DIR)/bin/ahfHaloHistory ahfHaloHistory

# Clear Amiga program. Use this if there are issues with installation before trying again.
.PHONY: clean
clear:
	rm -r $(AHF_DIR)
	rm ./AHF
	rm ./MergerTree
	rm ./ahfHaloHistory

# Delete the AHF_output folder and all halo files!
.PHONY: delete
delete:
	rm -r $(AHF_DIR)
