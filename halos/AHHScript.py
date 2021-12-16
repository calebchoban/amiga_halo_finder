import os
import sys

print(sys.argv)

dirc = sys.argv[1]
if len(sys.argv) > 2:
	startnum = int(sys.argv[2])
	endnum = int(sys.argv[3])
else:
	startnum = 0
	endnum = 600

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

filenames.sort()
if len(filenames) < endnum-startnum+1:
	print("Not all snapshots between start and end have had MergerTree run on them!")
	print("Run MergerTree on all files and then try ahfHaloHistory again")
	exit()

with open(prefix_list, 'w') as f:
	for item in filenames:
		f.write("%s\n" % item)


# Get list of redshifts to be used based on start and end snap numbers
ref_redshifts = 'ref_redshift_list.txt'
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
