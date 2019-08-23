AHF_VER = 100
AHF_DIR = ahf-v1.0-$(AHF_VER)
AHF_NAME = AHF-v1.0-100
AHF_URL = http://popia.ft.uam.es/AHF/files/$(AHF_DIR).tgz

.PHONY: all
all: AHF

AHF: | $(AHF_DIR)
	patch -N -p0 < v1.0-100.patch
	mv $(AHF_DIR)/Makefile.config $(AHF_DIR)/Makefile.config.backup
	cp Makefile.config $(AHF_DIR)/
	cd $(AHF_DIR) && make AHF
	ln -s $(AHF_DIR)/bin/$(AHF_NAME) AHF

$(AHF_DIR):
	curl $(AHF_URL) | tar xz

.PHONY: purge
purge:
	rm -rf ahf-*
