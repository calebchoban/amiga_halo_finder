# AHF Runner and Halo Reader

This example compiles and runs Amiga Halo Finder and include scripts to read AHF outputs.

You should set the main directory in the Makefile.

First, compile AHF:
```console
make compile
```

Then, submit the job script:
```console
make submit
```

Finally, read:
```console
make read
```

The AHF output is located in AHF_output directory and the halo reader data is in the halos directory.

