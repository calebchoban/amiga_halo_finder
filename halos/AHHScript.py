import os
import sys

ref_redshifts = 'ref_redshift_list.txt'

if not os.path.isfile(ref_redshifts):
	print("Need to create ref_redshift_list.txt file from either FIRE-2 or FIRE-3 redshifts.")
	exit()

# Get list of redshifts to be used based on start and end snap numbers
redshifts = []
with open(ref_redshifts, 'r') as f:
	# Number of snaps is different for FIRE-2 vs FIRE-3
	last_snap = len(f.readlines())-1

dirc = sys.argv[1]
if len(sys.argv) > 2:
	startnum = int(sys.argv[2])
	endnum = int(sys.argv[3])
else:
	startnum = 1
	endnum = last_snap

halo_ids = 'halo_ids.txt'



# Get list of file prefixes which AHH will us to get the _mtree and _halo files

prefix_list = 'prefix_file_names.txt'
print("Getting particles file names for ahfHaloHistory")
# Delete temp file if it already exists
if os.path.exists(prefix_list):
    os.remove(prefix_list)

filenames = []
# Get names of particle files
for file in os.listdir(dirc):
    if file.endswith(".AHF_mtree") and int(file[9:12]) >= startnum and int(file[9:12]) <= endnum:
        filenames += [os.path.join(dirc, file[:-6])]
    # Need to tack on last snapshot since it may not have a merger tree file for it
    elif int(file[9:12])==endnum and file.endswith(".AHF_halos"):
        filenames += [os.path.join(dirc, file[:-6])]

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



my_command = './ahfHaloHistory ' + halo_ids + ' ' + prefix_list + ' ' + redshift_list
os.system(my_command)
