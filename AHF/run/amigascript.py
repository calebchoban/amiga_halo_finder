import sys
import os


snap_dir = sys.argv[1]
output_dir = sys.argv[2]
amiga_dir = sys.argv[3]
if len(sys.argv)>5:
	startno = int(sys.argv[4])
	Nsnap = int(sys.argv[5])
	multi_snap = bool(sys.argv[6])
elif len(sys.argv)>4:
	starno = 0
	NSnap = 600
	multi_snap = bool(sys.argv[6])
else:
	startno = 0
	Nsnap = 600
	multi_snap = False

print("Snapshot Directory:", snap_dir)
print("Output Directory:", output_dir)
print("Amiga Directory:", amiga_dir)
print("First Snapshot:", startno)
print("Final Snapshot:", Nsnap)



# First create ouput directory if needed
try:
	# Create target Directory
	os.mkdir(output_dir)
	print("Directory ",output_dir," Created ")
except:
	print("Directory ",output_dir," already exists")


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
	strno = str(count)
	if count<10:
		strno='00'+str(count)
	elif count<100:
		strno='0'+str(count)
	print('doing ',strno)
	mycommand = 'ibrun '+amiga_dir+'AHF AHF.input'+strno
	os.system(mycommand)
	# Clean up files after we are done with them
	mycommand = 'rm AHF.input'+strno
	os.system(mycommand)
	count = count +1
