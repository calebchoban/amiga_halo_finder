import os
import sys

halo_ids = 'halo_ids.txt'

# Get list of file prefixes which AHH will us to get the _mtree and _halo files
prefix_list = 'mtree_file_names.txt'
# List of redshifts to be used
redshift_list = 'redshift_list.txt'

my_command = './ahfHaloHistory ' + halo_ids + ' ' + prefix_list + ' ' + redshift_list
os.system(my_command)