#!/usr/bin/python


import sys

#function to return a tuple containing transcript numbers and SNP location
def tname(zeile):
	if zeile == '':	#in case file is done
		return ('finished', 0, 0, 0)	#in a comparison "finished" will be considered greater than a number
	else:		#this is what normally happens
		liste = ([int(i[1:]) for i in zeile[0].split('_')])
		liste.append(int(zeile[1]))
		return tuple(liste)

#function to write out lines into the merge file
def write_out(minimale):
#	print 'This will be written' #for debug
#	print ''.join([info(lines[i]) if i in minimale else dummy[i] for i in range(6)])	#for debug


	outhandle.write('\t'.join([str(i) for i in tname(lines[minimale[0]])]) +
'\t' + lines[0][2] + '\t' + str(len(minimale)) + '\t' +
''.join([info(lines[i]) if i in minimale else dummy[i] for i in range(6)]) + 
'\t' + binstring(minimale) + '\n')



#function to update the smalles tuple(s)
def move_on(kleinste):
	for i in kleinste:
#		print i	
		lines[i] = handles[i].readline().split()

#function to extract the info to be writeen from a line
def info(zeile):
	
	return zeile[4] + '\t' + zeile[3] + '\t' + zeile[9] + '\t' 


#get number(s) of the smallest element(s) in an enumerated list
def is_min(a): return a[1] == min(tlist)

#function to make binary string to indicate in which individuals SNPs were called
def binstring(kleinste):
	return ''.join(['i' if i in kleinste else 'o' for i in range(6)])



#a dummy list to replace elements, join all and write out
dummy = ['NA\tNA\tNA\t', 'NA\tNA\tNA\t', 'NA\tNA\tNA\t', 'NA\tNA\tNA\t', 'NA\tNA\tNA\t', 'NA\tNA\tNA\t']



#open files specified as command line parameters
handles = []
handles.append(open(sys.argv[1], 'r'))
handles.append(open(sys.argv[2], 'r'))
handles.append(open(sys.argv[3], 'r'))
handles.append(open(sys.argv[4], 'r'))
handles.append(open(sys.argv[5], 'r'))
handles.append(open(sys.argv[6], 'r'))

outhandle = open(sys.argv[7], 'w')


#skip header line
handles[0].readline()
handles[1].readline()
handles[2].readline()
handles[3].readline()
handles[4].readline()
handles[5].readline()


#list to contain the read lines
lines = []
#read in one line each
lines.append(handles[0].readline().split())
lines.append(handles[1].readline().split())
lines.append(handles[2].readline().split())
lines.append(handles[3].readline().split())
lines.append(handles[4].readline().split())
lines.append(handles[5].readline().split())


#using the tuple-making function defined above, print tuples
#print 'current tuples:'
#print tname(lines[0])
#print tname(lines[1])
#print tname(lines[2])
#print tname(lines[3])
#print tname(lines[4])
#print tname(lines[5])
#print '\n'

#list of current tuples

while True:


	tlist = [tname(i) for i in lines]

	if '' in tlist: print 'At least one file done.'

	if sum([i == '' for i in tlist]) == 6: break

	smallest = [i[0] for i in filter(is_min, enumerate(tlist))]
	print smallest
	write_out(smallest)

	move_on(smallest)



#close files
handles[0].close()
handles[1].close()
handles[2].close()
handles[3].close()
handles[4].close()
handles[5].close()
outhandle.close()
