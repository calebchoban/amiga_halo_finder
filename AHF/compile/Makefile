AHF_VER = 100
AHF_DIR = ahf-v1.0-$(AHF_VER)
AHF_NAME = AHF-v1.0-100
MT_NAME = MergerTree
AHH_NAME = ahfHaloHistory
AHF_URL = http://popia.ft.uam.es/AHF/files/$(AHF_DIR).tgz

.PHONY: download
download: | $(AHF_DIR)
	echo "$(AHF_DIR) downloaded"

.PHONY: compile
compile: 
	patch -N -p0 < v1.0-100.patch
	mv $(AHF_DIR)/Makefile.config $(AHF_DIR)/Makefile.config.backup
	cp Makefile.config $(AHF_DIR)/
	cd $(AHF_DIR) && make AHF && make MergerTree && make ahfHaloHistory
	ln -s $(AHF_DIR)/bin/$(AHF_NAME) AHF
	ln -s $(AHF_DIR)/bin/$(MT_NAME) MergerTree
	ln -s $(AHF_DIR)/bin/$(AHH_NAME) ahfHaloHistory


.PHONY: compile_TSCC
compile_TSCC: 
	patch -N -p0 < v1.0-100.patch
	mv $(AHF_DIR)/Makefile.config $(AHF_DIR)/Makefile.config.backup
	cp TSCC_Makefile.config $(AHF_DIR)/Makefile.config
	cd $(AHF_DIR) && make AHF && make MergerTree && make ahfHaloHistory
	ln -s $(AHF_DIR)/bin/$(AHF_NAME) AHF
	ln -s $(AHF_DIR)/bin/$(MT_NAME) MergerTree
	ln -s $(AHF_DIR)/bin/$(AHH_NAME) ahfHaloHistory

.PHONY: compile_BigRed
compile_BigRed: 
	patch -N -p0 < v1.0-100.patch
	mv $(AHF_DIR)/Makefile.config $(AHF_DIR)/Makefile.config.backup
	cp BigRed_Makefile.config $(AHF_DIR)/Makefile.config
	cd $(AHF_DIR) && make AHF && make MergerTree && make ahfHaloHistory
	ln -s $(AHF_DIR)/bin/$(AHF_NAME) AHF
	ln -s $(AHF_DIR)/bin/$(MT_NAME) MergerTree
	ln -s $(AHF_DIR)/bin/$(AHH_NAME) ahfHaloHistory



$(AHF_DIR):
	curl $(AHF_URL) | tar xz

.PHONY: purge
purge:
	rm -rf ahf-*
