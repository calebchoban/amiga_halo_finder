import glob
import shutil
import numpy as np

# Finds which halo file is the final halo (halo ID = 0) at z=0 and makes a copy with a new name

files = glob.glob('./history/halo*.dat')
for file in files:
    IDs = np.loadtxt(file, usecols=(1,), unpack=True,dtype=int)
    if (IDs[-1]==0):
        print(file, 'has the final halo at z=0.')
        new_name = './history/halo_main.dat'
        shutil.copy(file, new_name)
        exit()

print("No halo file has the main halo at z=0.")
