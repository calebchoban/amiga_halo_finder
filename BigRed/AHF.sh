#!/usr/bin/env python3

#SBATCH -J AHF
#SBATCH -p general
#SBATCH -t 08:00:00
#SBATCH --nodes=1              # Total # of nodes 
#SBATCH --ntasks-per-node=16    # Total # of mpi tasks per node = # of Cores per Node (128) / OMP_NUM_THREADS
#SBATCH --cpus-per-task=8  # OMP_NUM_THREADS
#SBATCH --mem=240GB
#SBATCH -A r00380
#SBATCH --mail-user=EMAIL
#SBATCH --mail-type=fail
#SBATCH -o AHF.log
#SBATCH --export=ALL
#SBATCH -D .


import sys
import os
import re

# directory for AHF executable
amiga_dir = os.path.expanduser('~/codes/halo/amiga_halo_finder/')
# starting snapshot number
startnum = 10
# ending snapshot number
endnum = 500
# Set if the simulation breaks simulations into multiple snapshots
multi_snap= False

snap_dir = '../../output/'
output_dir = './output/'


# Get the list of user's 
env_var = os.environ 
   
# Print the list of user's 
num_nodes = os.environ['SLURM_JOB_NUM_NODES']
num_task_per_node = os.environ['SLURM_NTASKS_PER_NODE']
num_OMP_THREADS = os.environ['SLURM_CPUS_PER_TASK']


# This command will be environment specific
run_command= 'srun --cpus-per-task='+str(num_OMP_THREADS)+' --ntasks-per-node='+str(num_task_per_node)+' --nodes='+str(num_nodes) + ' '


print("Snapshot Directory:", snap_dir)
print("Output Directory:", output_dir)
print("Amiga Directory:", amiga_dir)
print("First Snapshot:", startnum)
print("Final Snapshot:", endnum)
print("Multisnapshots:", multi_snap)
print("Number of Nodes:", num_nodes)
print("Num of Task per Node:", num_task_per_node)
print("NUM_OMP_THREADS:", num_OMP_THREADS)

# First create ouput directory if needed
if not os.path.isdir(output_dir):
    os.makedirs(output_dir,exist_ok=True)
    print("Directory " + output_dir +  " Created ")


# If AHF has already run on some snaps figure out which ones they are so we can skip them
skip_snaps = []
for file in os.listdir(output_dir):
    if file.endswith(".AHF_profiles"):
        regex = re.compile(r'\d+')
        num = int(regex.findall(file)[0])
        skip_snaps += [num]

# Make input files for AHF using template
finname = amiga_dir+'AHF.input'
outname = output_dir + 'AHF.input'
f=open(finname)
dars = f.readlines()
f.close()

inputlist = []

count = startnum
while(count <= endnum):
    strno = str(count)
    if count<10:
        strno='00'+str(count)
    elif count<100:
        strno='0'+str(count)
    print('DOING N ',strno)
    foutname = outname + strno
    g = open(foutname, 'w')
    linecount = 0
    for line in dars:
        linecount = linecount + 1
        if (linecount == 2):
            if not multi_snap:
                print('ic_filename = '+snap_dir+'snapshot_'+strno+'.hdf5')
                g.write('ic_filename = '+snap_dir+'snapshot_'+strno+'.hdf5'+'\n')
            else:
                print('ic_filename = '+snap_dir+'snapdir_'+strno+'/snapshot_'+strno+'.')
                g.write('ic_filename = '+snap_dir+'snapdir_'+strno+'/snapshot_'+strno+'.'+'\n')
        elif (linecount == 3):
            if not multi_snap:
                print('ic_filetype = 50')
                g.write('ic_filetype = 50\n')
            else:
                print('ic_filetype = 51')
                g.write('ic_filetype = 51\n')
        elif (linecount == 4):
            print('outfile_prefix = '+output_dir+'snapshot_'+strno)
            g.write('outfile_prefix = '+output_dir+'snapshot_'+strno+'\n')
        else:
            print(line.strip())
            g.write(line)
    g.close()
    count = count + 1
    inputlist.append(foutname)

count = startnum
while(count <= endnum):
    if count in skip_snaps:
        print("Skipping ", count)
        mycommand = 'rm '+outname+str(count)
        os.system(mycommand)
        count += 1
        continue

    strno = str(count)
    if count<10:
        strno='00'+str(count)
    elif count<100:
        strno='0'+str(count)
    print('Doing ',strno)

    mycommand = run_command + amiga_dir +'AHF '+ outname + strno
    print(mycommand)
    os.system(mycommand)
    # Clean up files after we are done with them
    mycommand = 'rm ' + outname +strno
    os.system(mycommand)
    count = count +1
