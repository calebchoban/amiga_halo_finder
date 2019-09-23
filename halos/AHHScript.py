import os
import sys

halo_ids = 'halo_ids.txt'

# Get list of file prefixes which AHH will us to get the _mtree and _halo files
prefix_list = 'mtree_file_names.txt'

my_command = './ahfHaloHistory ' + halo_ids + ' ' + prefix_list + ' -1'
os.system(my_command)