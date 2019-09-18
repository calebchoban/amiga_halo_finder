import os
import sys

data_dir = sys.argv[1]
output_dir = sys.argv[1]

print "Data Directory:", data_dir
print "Output Directory:", output_dir

halo_ids = 'halo_ids.txt'

# Create list of file prefixes which AHH will us to get the _mtree and _halo files
prefix_list = []
output_file_names = 'output_file_names.txt'
file = open(output_file_names, 'r')
for line in file.readlines():
    prefix_list += [line]

my_command = 'ahfHaloHistory ' + halo_ids + ' ' + prefix_list + ' -1'
os.system(my_command)