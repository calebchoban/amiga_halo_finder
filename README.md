# AHF Runner and Halo Reader

This example compiles and runs Amiga Halo Finder and include scripts to read AHF outputs.

First, uncomment MAIN_DIR line in MakeFile and set to your directory.

Second, compile AHF:
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

Afterwards, run ahfHaloHistory:
```console
make ahfHaloHistory
```

The AHF and MergerTree output is located in AHF_output directory and the halo history is in the halos directory.

Note:
- By default AHF is not compiled with MPI, if you want to use MPI add the -DWITH_MPI flag to the DEFINEFLAGS list in Makefile.config, but be warned that this will cause the halo ID's to be randomized and you will have to edit the halo_ids file after running AHF. Also all AHF files for each snapshot are broken up for each MPI task.
- If you are running ahfHaloHistory for many halos, edit the Makefile so ahfHaloHistory submits a job instead of running the code on the login node.


