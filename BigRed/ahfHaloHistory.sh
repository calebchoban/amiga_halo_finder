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
from shutil import copyfile


amiga_dir = os.path.expanduser('~/codes/halo/amiga_halo_finder/')
# FIRE Version used for reference snapshots and number of total snaps
FIRE_VER = 3
# Number of halos from zero to numhalos you want to run ahfHaloHistory for
numhalos=10

particle_dirc = './output/'
output_dir = './history/'

# Copy over reference redshift list
ref_redshifts = 'ref_redshift_list.txt'
if FIRE_VER == 3:
	last_snap=500
	copyfile(amiga_dir+'FIRE3_ref_redshift_list.txt',ref_redshifts)
else:
	last_snap=600
	copyfile(amiga_dir+'FIRE2_ref_redshift_list.txt',ref_redshifts)

# Snaps you want to run ahfHaloHistory over
startnum=10
endnum=12

# First create ouput directory if needed
if not os.path.isdir(output_dir):
    os.makedirs(output_dir,exist_ok=True)
    print("Directory " + output_dir +  " Created ")


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
    if file.endswith(".AHF_mtree") and int(file[9:12]) >= startnum and int(file[9:12]) <= endnum:
        filenames += [os.path.join(particle_dirc, file[:-6])]
    # Need to tack on last snapshot since it may not have a merger tree file for it
    elif int(file[9:12])==endnum and file.endswith(".AHF_halos"):
        filenames += [os.path.join(particle_dirc, file[:-6])]

filenames.sort()
if len(filenames) < endnum-startnum:
    print("Number of snaps with mergertree files:",len(filenames))
    print("Number of files from given snapshot range:",endnum-startnum+1)
    print("Not all snapshots between start and end have had MergerTree run on them!")
    print("Run MergerTree on all files and then try ahfHaloHistory again")
    exit()

with open(prefix_list, 'w') as f:
    for item in filenames:
        f.write("%s\n" % item)


# Get list of redshifts to be used based on start and end snap numbers
redshifts = []
with open(ref_redshifts, 'r') as f:
	for i, line in enumerate(f.readlines()):
		if i >= startnum and i <= endnum:
			redshifts += [line]


# Get list of redshifts to be used based on start and end snap numbers
redshifts = []
with open(ref_redshifts, 'r') as f:
	for i, line in enumerate(f.readlines()):
		if i >= startnum and i <= endnum:
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
