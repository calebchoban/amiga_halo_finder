# AHF Runner and Halo Reader

This example downloads and compiles  Amiga Halo Finder and include scripts to run AHF and MergerTree for a few supercomputing environments.

## Downloading and Compiling AHF

First clone this repository into the following folder in your home directory.
```console
~/codes/halo/
```
If you clone this somewhere else you will need to edit the scripts accordingly.

Next, run
```console
make download
```
to download the latest version of AHF from github.

If you are using FIRE-3 (or recent FIRE-2) snapshots you need to edit some AHF code before compiling. Go to ./amiga/src/libio/io_gizmo_header.c and change these two lines
```console
hdf5_attribute = H5Aopen_name(hdf5_headergrp, "Omega0");
...
hdf5_attribute = H5Aopen_name(hdf5_headergrp, "OmegaLambda");

```
To this
```console
hdf5_attribute = H5Aopen_name(hdf5_headergrp, "Omega_Matter");
...
hdf5_attribute = H5Aopen_name(hdf5_headergrp, "Omega_Lambda");
```

Then, from the folder corresponding to the supercomputer environment you are on, copy Makefile.config into ./AHF and activate.sh into ./.
If your environment isn't listed you will have to make your own.

Next run
```console
make compile
```
which will compile AHF, MergerTree, and ahfHaloHistory and make links to the executables.


## Running AHF

First you need to make the following folders in your simulation directory.
```console
./halo/ahf/output/
./halo/ahf/history/
```
This is were the AHF/MergerTree outputs and ahfHaloHistory outputs will go respectively.

### 1. AHF

Copy the AHF job script into ./halo/ahf/history/ and submit the job:
```console
qsub AHF.sh
```
If this times out before finishing just resubmit. It will pick up wherever the last run left off at.
Note when dealing with large snapshots, you will want a lower number of NUM_OMP_THREADS to avoid running out of memory.

### 2. MergerTree

Copy the MergerTree job script into ./halo/ahf/history/ and submit the job:
```console
qsub MergerTree.sh
```
Ditto on the resubmission.

### 3. ahfHaloHistory

Copy the ahfHaloHistory job script into ./halo/ahf/history/ 
Set various parameters if you need such as the FIRE version (FIRE_VER), start and end snaps (starnum, endnum), and the number of halos you want to calculate the history for (numhalos).
Then submit the job:
```console
qsub ahfHaloHistory.sh
```
Note that each halo history file is the history of halo N, were N is the designation of the halo at the first snap. This can cause issues sinces the primary halo at early times may not be the primary halo at simulation end. To determine which halo history (if any) represents the main halo, copy find_final_halo.py and run it.


Notes:
- By default AHF is not compiled with MPI, if you want to use MPI add the -DWITH_MPI flag to the DEFINEFLAGS list in Makefile.config, but be warned that this will cause the halo ID's to be randomized and you will have to edit the halo_ids file after running AHF. Also all AHF files for each snapshot are broken up for each MPI task.


