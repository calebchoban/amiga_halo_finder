import os
import sys

data_dir = sys.argv[1]
output_dir = sys.argv[1]

print "Data Directory:", data_dir
print "Output Directory:", output_dir

# First create ouput directory if needed
try:
    # Create target Directory
    os.mkdir(output_dir)
    print "Directory " + output_dir +  " Created " 
except:
    print "Directory " + output_dir +  " already exists"


halo_ids = 'halo_ids.txt'

# Get list of file prefixes which AHH will us to get the _mtree and _halo files
prefix_list = 'mtree_file_names.txt'

my_command = './ahfHaloHistory ' + halo_ids + ' ' + prefix_list + ' -1'
os.system(my_command)