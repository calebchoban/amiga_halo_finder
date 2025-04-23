#!/usr/bin/env python3

#SBATCH -J Halo_History
#SBATCH -p general
#SBATCH -t 01:00:00
#SBATCH -N 1
#SBATCH -n 1
#SBATCH --mem=10GB
#SBATCH -A r00380
#SBATCH --mail-user=EMAIL
#SBATCH --mail-type=all
#SBATCH -o HH.log
#SBATCH --export=ALL
#SBATCH -D .


import os
import sys
import re
import glob
import numpy as np
import h5py
from shutil import copyfile


amiga_dir = os.path.expanduser('~/codes/halo/amiga_halo_finder/')
# FIRE Version used for reference snapshots and number of total snaps
FIRE_VER = 2
# Number of halos from zero to numhalos you want to run ahfHaloHistory for
numhalos=4
# If False, an error will be thrown if any snapshots are missing a MergerTree file.
# Useful since MergerTree can randomly not work on some snapshots.
# Set this to True if you only ran AHF and MergerTree on a select number of 
# snapshots (i.e every 5th snapshot)
skip_missing_merger_files=True

particle_dirc = './output/'
output_dir = './history/'

# Double check the FIRE version is correct by opening one of the snapshots
print("Checking FIRE version")
try:
    snapfile = glob.glob('../../output/*.hdf5')
    snapfile.sort()
    snapfile = snapfile[0]
    f = h5py.File(snapfile, 'r')
    if 'Solar_Abundances_Adopted' in f['Header'].attrs.keys():
        if f['Header'].attrs['Solar_Abundances_Adopted'][0]==0.02:
            snap_ver = 2
        else: 
            snap_ver = 3
    else: # Old snaps without abundances are from FIRE-1/2
        snap_ver = 2
    if (snap_ver!=FIRE_VER):
        print("Provided FIRE version does not match with snapshot version")
        print("Provided: FIRE-%i \t Snap: FIRE-%i"%(FIRE_VER,snap_ver))
        print("Will override with snapshot version")
        FIRE_VER=snap_ver
    else:
        print("FIRE version seems fine.")
except:
    print("Couldn't open a snapshot to double check FIRE version")
    print("Make sure FIRE-%i is the correct version!!!"%FIRE_VER)


# Copy over reference redshift list
ref_redshifts = 'ref_redshift_list.txt'
if FIRE_VER == 3:
    last_snap=500
    copyfile(amiga_dir+'FIRE3_ref_redshift_list.txt',ref_redshifts)
else:
    last_snap=600
    copyfile(amiga_dir+'FIRE2_ref_redshift_list.txt',ref_redshifts)


# First create ouput directory if needed
if not os.path.isdir(output_dir):
    os.makedirs(output_dir,exist_ok=True)
    print("Directory " + output_dir +  " Created ")

# First remove any old ahf history files
old_files = os.listdir(output_dir)
for file in old_files:
    path_to_file = os.path.join(output_dir, file)
    os.remove(path_to_file)


halo_ids = 'halo_ids.txt'
if os.path.exists(halo_ids):
    os.remove(halo_ids)
# Create file with halo ids
myfile = open(halo_ids, 'w')
for n in range(numhalos):
    myfile.write(str(n) + '\n')
myfile.close()

# Get list of file prefixes which AHH will us to get the _mtree and _halo files
prefix_list = 'prefix_file_names.txt'
print("Getting particles file names for ahfHaloHistory")
# Delete temp file if it already exists
if os.path.exists(prefix_list):
    os.remove(prefix_list)

filenames = []
# Get names of particle files
for file in os.listdir(particle_dirc):
    if file.endswith(".AHF_mtree") or file.endswith(".AHF_halos"):
        filename = os.path.join(particle_dirc, file[:-6])
        if filename not in filenames:
            filenames += [filename]

filenames.sort()
file = re.split('/',filenames[0])[-1]
startnum = int(re.search('_([0-9]{3}).', file).group(1))
file = re.split('/',filenames[-1])[-1]
endnum = int(re.search('_([0-9]{3}).', file).group(1))
print("Starting and ending snapnums detected:",startnum,endnum)

all_snap_nums = []
for filename in filenames:
    file = re.split('/',filename)[-1]
    all_snap_nums += [int(re.search('_([0-9]{3}).', file).group(1))]

print("Number snapshots detected:",len(all_snap_nums))
print(all_snap_nums)


if len(filenames) < endnum-startnum and not skip_missing_merger_files:
    print("Number of snaps with mergertree files:",len(filenames))
    print("Number of files from given snapshot range:",endnum-startnum+1)
    print("Not all snapshots between start and end have had MergerTree run on them!")
    print("Run MergerTree on all files and then try ahfHaloHistory again")
    exit()
else:
    print("Looks like AHF and MergerTree have been run for all files in the detected range")

with open(prefix_list, 'w') as f:
    for item in filenames:
        f.write("%s\n" % item)


# Get list of redshifts to be used based on start and end snap numbers
redshifts = []
with open(ref_redshifts, 'r') as f:
    for i, line in enumerate(f.readlines()):
        if i >= startnum and i <= endnum and i in all_snap_nums:
            redshifts += [line]

redshift_list  = 'redshift_list.txt'
# Delete temp file if it already exists
if os.path.exists(redshift_list):
    os.remove(redshift_list)

with open(redshift_list, 'w') as f:
    for item in redshifts:
        f.write("%s" % item)


my_command = amiga_dir + 'ahfHaloHistory ' + halo_ids + ' ' + prefix_list + ' ' + redshift_list + ' ' + output_dir
os.system(my_command)

# Remove trailing character
for filename in os.listdir(output_dir):
    if filename.startswith(""):
        os.rename(output_dir+filename, output_dir+filename[1:])

os.remove(prefix_list)
os.remove(redshift_list)



# Now find if one of the halo history files is for the main halo at the final snapshot
print('Determining if any halo history files have the main halo at the last snapshot')
files = glob.glob(output_dir+'halo*.dat')
for file in files:
    IDs = np.loadtxt(file, usecols=(1,), unpack=True,dtype=int)
    if (IDs[-1]==0):
        print(file, 'has the final halo')
        new_name = './history/halo_main.dat'
        print("Creating new file called %s and smoothing file"%new_name)
        data = np.loadtxt(file, unpack=True)
        # Clean up column names
        column_names = list(np.genfromtxt(file,skip_header=1,max_rows = 1,dtype=str,comments='@'))
        column_names[0] = 'ID(1)'
        if '(' in column_names[0]: 
            column_names = [name[:name.index('(')] for name in column_names]
        # Revert back to old names for new AHF files
        if 'Rhalo' in column_names:
            column_names[column_names.index('Rhalo')] = 'Rvir'
            column_names[column_names.index('Mhalo')] = 'Mvir'
        # Insert snapnum data column and redshift column names (AHF doesn't do this on its own)
        column_names = ['snum','redshift'] + column_names
        # Make snapshot numbers column  
        new_data = np.insert(data,0,all_snap_nums,axis=0)
        # Keep it somewhat readable by eye
        fmts = ['%i','%1.6f','%i','%i','%i']+['%1.4e']*(len(column_names)-5)
        np.savetxt(new_name,new_data.transpose(),delimiter='\t', header='\t'.join(column_names),fmt=fmts,comments='')
    else:
        new_name = './history/halo_%i.dat'%IDs[-1]
        print("Creating new file called %s and smoothing file"%new_name)
        data = np.loadtxt(file, unpack=True)
        # Clean up column names
        column_names = list(np.genfromtxt(file,skip_header=1,max_rows = 1,dtype=str,comments='@'))
        column_names[0] = 'ID(1)'
        if '(' in column_names[0]: 
            column_names = [name[:name.index('(')] for name in column_names]
        # Revert back to old names for new AHF files
        if 'Rhalo' in column_names:
            column_names[column_names.index('Rhalo')] = 'Rvir'
            column_names[column_names.index('Mhalo')] = 'Mvir'
        # Insert snapnum data column and redshift column names (AHF doesn't do this on its own)
        column_names = ['snum','redshift'] + column_names
        # Make snapshot numbers column  
        new_data = np.insert(data,0,all_snap_nums,axis=0)
        # Keep it somewhat readable by eye
        fmts = ['%i','%1.6f','%i','%i','%i']+['%1.4e']*(len(column_names)-5)
        np.savetxt(new_name,new_data.transpose(),delimiter='\t', header='\t'.join(column_names),fmt=fmts,comments='')


print("No halo file has the main halo at last snapshot.")

