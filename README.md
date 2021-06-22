# AHF Runner and Halo Reader

This example compiles and runs Amiga Halo Finder and include scripts to read AHF outputs.

First, uncomment MAIN_DIR line in MakeFile and set to your directory.

Second, download AHF:
```console
make download
```

If you are using FIRE-3 snapshots you ned to edit some AHF code before compiling. Go to AHF/compile/ahf-v1.0-100/src/libio/io_gizmo_header.c and change these two lines
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

Depending on what snapshots you ran AHF for, you will need to edit the redshift_list.txt file in the halos directory. By default the list starts at z=99 and ends at z=0. ahfHaloHistory uses this list when outputting the halo history file.

Afterwards, run ahfHaloHistory:
```console
make ahfHaloHistory
```

The AHF and MergerTree output is located in AHF_output directory and the halo history is in the halos directory.

Note:
- By default AHF is not compiled with MPI, if you want to use MPI add the -DWITH_MPI flag to the DEFINEFLAGS list in Makefile.config, but be warned that this will cause the halo ID's to be randomized and you will have to edit the halo_ids file after running AHF. Also all AHF files for each snapshot are broken up for each MPI task.
- If you are running ahfHaloHistory for many halos, edit the Makefile so ahfHaloHistory submits a job instead of running the code on the login node.


