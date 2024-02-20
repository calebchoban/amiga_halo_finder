#!/usr/bin/env python3

#SBATCH -J MergerTree
#SBATCH -p general
#SBATCH -t 03:00:00
#SBATCH -N 1
#SBATCH -n 1
#SBATCH --mem=120GB
#SBATCH -A r00380
#SBATCH --mail-user=EMAIL
#SBATCH --mail-type=fail
#SBATCH -o MT.log
#SBATCH --export=ALL
#SBATCH -D .

# Note for Big Red you need to specificy the memory or else it will give you only n_tasks/128*TOTAL_MEMORY worth of memory


import sys
import os
import subprocess


mergertree_dir = os.path.expanduser('~/codes/halo/amiga_halo_finder/')

particle_dir = './output/'



# Check that AHF has already run
if not os.path.exists(particle_dir):
	print("Need to run AHF first before running MergerTree!")
	exit()

filenames = []

print("Getting particles files and creating needed lists for MergerTree")

# Get names of particle files
for file in os.listdir(particle_dir):
	if file.endswith(".AHF_particles"):
		# Now make sure MergerTree hasn't already been run for this snap
		# If so we can skip it
		if not os.path.exists(os.path.join(particle_dir,file[:-14]+".AHF_mtree")):
			filenames += [os.path.join(particle_dir, file)]

filenames.sort()
number = str(len(filenames))
# Create list of file names for MergerTree
particle_file_names = 'particle_file_names.txt'
with open(particle_file_names, 'w') as f:
	for item in filenames:
		f.write("%s\n" % item)

# Create output file names and write to txt file
output_names = []
for item in filenames[:-1]:
	output_names += [item[:-10]]

mtree_file_names = 'mtree_file_names.txt'
with open(mtree_file_names, 'w') as f:
	for item in output_names:
		f.write("%s\n" % item)

print("Running MergerTree")
# Now run MergerTree 
process=subprocess.Popen([mergertree_dir+'MergerTree'],
						stdin=subprocess.PIPE,
						stdout=subprocess.PIPE,
						stderr=subprocess.PIPE,
						encoding='utf8')

# Now step through giving each file name to MergerTree (why is this the only what to run MergerTree?!)
input_data=number+'\n'
with open(particle_file_names, 'r') as f:
	for item in f.readlines():
		input_data += item + '\n'

with open(mtree_file_names, 'r') as f:
	for item in f.readlines():
		input_data += item + '\n'

stdoutdata,stderrdata=process.communicate(input=input_data)
print(stderrdata)

os.remove(particle_file_names)
os.remove(mtree_file_names)
