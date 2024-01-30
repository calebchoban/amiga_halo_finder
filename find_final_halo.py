import glob
import numpy as np

# Finds which halo file is the final halo (halo ID = 0) at z=0

files = glob.glob('./output/halo*.dat')
for file in files:
    IDs = np.loadtxt(file, usecols=(1,), unpack=True,dtype=int)
    if (IDs[-1]==0):
        print(file, 'has the final halo at z=0.')
        exit()

print("No halo file has the main halo at z=0.")
