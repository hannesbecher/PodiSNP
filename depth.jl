#!/usr/bin/julia


# This was written to merge the output of `samtools depth`. I had executed
# samtools depth on six BAM files each the result of mapping a samples reads
# to a common reference (as when comparing sample-specific trinscription
# and transcription level). Curently is goes through six files at the same time,
# averaging coverage per transcript and saving the results to another file.


using DataFrames


namen = ASCIIString[]

# Files to be read from
in85 = open("85_depth", "r")
in86 = open("86_depth", "r")
in87 = open("87_depth", "r")
in88 = open("88_depth", "r")
in89 = open("89_depth", "r")
in90 = open("90_depth", "r")

# One Float64 and one Int array for every file. Avgs are to contain the average
# coverage per transcript. tempcov collects per-base coverages (for one
# transcript at a time) that will be averaged once the whole transcript has been
# parsed.

avgs85 = Float64[]
tempcov85 = Int[]

avgs86 = Float64[]
tempcov86 = Int[]

avgs87 = Float64[]
tempcov87 = Int[]

avgs88 = Float64[]
tempcov88 = Int[]

avgs89 = Float64[]
tempcov89 = Int[]

avgs90 = Float64[]
tempcov90 = Int[]


# Read first line of every file
line85 = readline(in85)
line86 = readline(in86)
line87 = readline(in87)
line88 = readline(in88)
line89 = readline(in89)
line90 = readline(in90)


# currnam is the name of the transcript whose coverage is being calculated a
currnam = split(line85)[1]

# Push the first base's coverage into tempcov (for every file)
push!(tempcov85, parse(Int, split(line85)[3]))
push!(tempcov86, parse(Int, split(line86)[3]))
push!(tempcov87, parse(Int, split(line87)[3]))
push!(tempcov88, parse(Int, split(line88)[3]))
push!(tempcov89, parse(Int, split(line89)[3]))
push!(tempcov90, parse(Int, split(line90)[3]))

# count will count the lenth of each transcrip (necessary for calculation
# of the mean coverage).
count = 1


#dcount = 1 #for debug


# Main loop of this script

for line85 in eachline(in85)

# dcount and the if stuff is for debug only
#dcount += 1
#if dcount == 10000
#	break
#end


# newnam - transcript name of the next line. If it differs from the last line's
# transcript name (currnam), we have reached a new transcript and we can
# calculate last one's coverage and push it into avgs. Also count we be set back
# to 1 and tempcov will be emptied/
	newnam = split(line85)[1]
	
	if newnam != currnam

		push!(namen, currnam)
		push!(avgs85, sum(tempcov85)/count)
		push!(avgs86, sum(tempcov86)/count)
		push!(avgs87, sum(tempcov87)/count)
		push!(avgs88, sum(tempcov88)/count)
		push!(avgs89, sum(tempcov89)/count)
		push!(avgs90, sum(tempcov90)/count)

		println(currnam)	
		currnam = newnam
		count = 1
		tempcov85 = Int[]
		tempcov86 = Int[]
		tempcov87 = Int[]
		tempcov88 = Int[]
		tempcov89 = Int[]
		tempcov90 = Int[]


	end


	line86 = readline(in86)
	line87 = readline(in87)
	line88 = readline(in88)
	line89 = readline(in89)
	line90 = readline(in90)

	push!(tempcov85, parse(Int, split(line85)[3]))
	push!(tempcov86, parse(Int, split(line86)[3]))
	push!(tempcov87, parse(Int, split(line87)[3]))
	push!(tempcov88, parse(Int, split(line88)[3]))
	push!(tempcov89, parse(Int, split(line89)[3]))
	push!(tempcov90, parse(Int, split(line90)[3]))

	count += 1

	push!(tempcov85, parse(Int, split(line85)[3]))

end

# Once we have read through the whole file, we calculate the last transcript's 
# coverage and push it to avgs for every file. Then, we put all averages and
# names in a dataframe and dump to a file (very much like in R).
push!(namen, currnam)
push!(avgs85, sum(tempcov85)/count)
push!(avgs86, sum(tempcov86)/count)
push!(avgs87, sum(tempcov87)/count)
push!(avgs88, sum(tempcov88)/count)
push!(avgs89, sum(tempcov89)/count)
push!(avgs90, sum(tempcov90)/count)

df = DataFrame(names = namen, d85 = avgs85, d86 = avgs86, d87 = avgs87,
	d88 = avgs88, d89 = avgs89, d90 = avgs90)

writetable("coverages", df, separator = '\t')

# Close opened files.
close(in85)
close(in86)
close(in87)
close(in88)
close(in89)
close(in90)

	



