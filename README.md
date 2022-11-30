# AHF Runner and Halo Reader

This example compiles and runs Amiga Halo Finder and include scripts to read AHF outputs. If running on TSCC checks notes at bottom first!

First, uncomment MAIN_DIR line in MakeFile and set to your directory. Then uncomment MULTI_SNAPS line and set to 1 if you simulation snapshots are broken up into multiple files or 0 otherwise. Also edit all of the job scripts (AHF.sh, HaloHistory.sh, and MergerTree.sh) to use your email address.

If needed, you can also edit the start and end snapshot numbers, the number snapshots each AHF job will deal with, and pick an OMP_NUM_THREADS number for your given number of cpu cores.

Second, download AHF:
```console
make download
```

If you are using FIRE-3 (or recent FIRE-2) snapshots you need to edit some AHF code before compiling. Go to AHF/compile/ahf-v1.0-100/src/libio/io_gizmo_header.c and change these two lines
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

Third, compile AHF:
```console
make compile
```


Then, submit the AHF job script:
```console
make AHF
```

Once the AHF jobs are done run MergerTree:
```console
make MergerTree
```
If this times out before finishing just keep running MergerTree. It will pick up wherever the last run left off at.


Depending on what snapshots you ran AHF for, you will need to edit the HH_STARTNUM and HH_ENDNUM values in the Makefile. By default the list starts at snapshot 001 and ends at snapshot 600. If you want to run halo history for certain halos you can list the halos' numbers in the halo_ids.txt file. The default is halos 0-5.

Afterwards, run ahfHaloHistory:
```console
make ahfHaloHistory
```

The AHF and MergerTree output is located in AHF_output directory and the halo history is in the halos directory.

Note:
- If running on TSCC run the TSCC version of each of the Makefile commands (i.e compile_TSCC, AHF_TSCC, MergerTree_TSCC, ahfHaloHistory_TSCC). You will also need to directly edit fields in the job submission scripts found in the TSCC/ directory.
- By default AHF is not compiled with MPI, if you want to use MPI add the -DWITH_MPI flag to the DEFINEFLAGS list in Makefile.config, but be warned that this will cause the halo ID's to be randomized and you will have to edit the halo_ids file after running AHF. Also all AHF files for each snapshot are broken up for each MPI task.
- If you are running ahfHaloHistory for many halos, edit the Makefile so ahfHaloHistory submits a job instead of running the code directly.


