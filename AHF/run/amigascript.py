import sys
import os
import re


snap_dir = sys.argv[1]
output_dir = sys.argv[2]
amiga_dir = sys.argv[3]
if len(sys.argv)>5:
	startno = int(sys.argv[4])
	Nsnap = int(sys.argv[5])
	multi_snap = bool(int(sys.argv[6]))
elif len(sys.argv)>4:
	starno = 0
	NSnap = 600
	multi_snap = bool(int(sys.argv[4]))
else:
	startno = 0
	Nsnap = 600
	multi_snap = False

print("Snapshot Directory:", snap_dir)
print("Output Directory:", output_dir)
print("Amiga Directory:", amiga_dir)
print("First Snapshot:", startno)
print("Final Snapshot:", Nsnap)
print("Multisnapshots:", multi_snap)


# First create ouput directory if needed
if not os.path.isdir(output_dir):
    os.mkdir(output_dir)
    print("Directory " + output_dir +  " Created ")


# If AHF has already run on some snaps figure out which ones they are so we can skip them
skip_snaps = []
for file in os.listdir(output_dir):
    if file.endswith(".AHF_profiles"):
        regex = re.compile(r'\d+')
        num = int(regex.findall(file)[0])
        skip_snaps += [num]


finname = amiga_dir+'AHF.input'
f=open(finname)
dars = f.readlines()
f.close()

inputlist = []

count = startno
while(count <= Nsnap):
	strno = str(count)
	if count<10:
		strno='00'+str(count)
	elif count<100:
		strno='0'+str(count)
	print('DOING N ',strno)
	foutname = finname + strno
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

count = startno
while(count <= Nsnap):
    if count in skip_snaps:
        print("Skipping ", count)
        mycommand = 'rm AHF.input'+str(count)
        os.system(mycommand)
        count += 1
        continue

    strno = str(count)
    if count<10:
        strno='00'+str(count)
    elif count<100:
        strno='0'+str(count)
    print('Doing ',strno)
    mycommand = 'ibrun '+amiga_dir+'AHF AHF.input'+strno
    print(mycommand)
    os.system(mycommand)
    # Clean up files after we are done with them
    mycommand = 'rm AHF.input'+strno
    os.system(mycommand)
    count = count +1
