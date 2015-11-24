

import sys

inhandle = open(sys.argv[1], 'r')

outhandle = open(sys.argv[1] + '_extract', 'w')

while True:
	line = inhandle.readline()
	if line[:6] == '#CHROM': break

outhandle.write('transcript\tposition\trefBase\taltBase\tcoverage\tfwRB\trwRB\tfwAB\twAB\taltFrac\n')

for line in inhandle:
	elements = line.split('\t')
	DP4index =  [item.startswith('DP4=') for item in elements[7].split(';')].index(1) #which element in the INFO column is DP4
	counts = [int(i) for i in elements[7].split(';')[DP4index][4:].split(',')]	#counts as integer list
	alt = float(sum(counts[2:]))/sum(counts)
	
	outhandle.write(elements[0] + '\t')
	outhandle.write(elements[1] + '\t')
	outhandle.write(elements[3] + '\t')
	outhandle.write(elements[4] + '\t')
	outhandle.write(str(sum(counts)) + '\t')
	outhandle.write('\t'.join([str(i) for i in counts]) + '\t')
	outhandle.write(str(alt) + '\n')
	


inhandle.close()
outhandle.close()
