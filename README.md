# F16-Informatics

https://drive.google.com/uc?export=download&id=0B89qjFzcZ81rbjhPM3lOa2ozU00

##A) Summarize a genome assembly
We will be working with the *Drosophila melanogaster* genome. You can start at flybase.org. Go to the most current download genomes section and download the fasta of all chromosomes.

####A-a) Print a summary report with the following information:

+ Total number of nucleotides
+ Total number of Ns
+ Total number of sequences
+ Repeat the above analysis, except split the data into sequences > 100kb and < 100kb

####A-b) Print summary plots of the following:

+ Sequence length distribution
+ Sequence GC% distribution
+ Cumulative genome size sorted from largest to smallest sequences



##B) Summarize an annotation file
Go to the most current download genomes section at flybase.org and download the gtf annotation file for *D. melanogaster*.


####B-a) Print a summary report with the following information:

+ Total number of features of each type, sorted from the most common to the least common
+ Total number of genes per chromosome arm (X, Y, 2L, 2R, 3L, 3R, 4)

####B-b) Print summary plots of the following:
+ Histogram of the number of transcripts per gene
+ Histogram of the length of genes
+ Histogram of the length of exons


-------------------------------------------------

##0) Preliminaries

Get on the HPC.
`ssh jbriner@hpc.oit.uci.edu`

Module load allows you to use software uploaded by individual users, modifying your environment on a per-module basis. 
To peek at software JJ has made available to the cluster:
```shell
	module avail #see what's available
	module load jje/kent/2014.02.19  #has FAsize (fasta nucleotide counting)
	module load jje/jjeutils/0.1a  #has a lot of other software we've used in class
	module list #verify
	module whatis #probe
	module load /data/modulefiles/USER_CONTRIBUTED_SOFTWARE/kent; /data/modulefiles/USER_CONTRIBUTED_SOFTWARE/jje/jjeutils
```



----------------------------------------------------------

##1) Prepare the files.

1.1) Download the fasta of all chromosomes with wget (the -P prefix specifies the download destination). Pipe into gunzip.

```
wget -r -A "ftp://ftp.flybase.net/genomes/Drosophila_melanogaster/current/fasta/dmel-all-chromosome-r6.13.fasta.gz" -O "/home/jbriner/Desktop/(F16) Informatics/FinalExercises/Overview/dmel-all-chromosome-r6.13.fasta" | gunzip  *.fastq.gz | less
```


1.2) Get a sense for what I'm dealing with

```
cd "/home/jbriner/Dropbox/UCI/Classes/(F16) Informatics/FinalExercises/Overview" 
head "dmel-all-chromosome-r6.13.fasta"
```

------------------------------------------------------------------------


##2) Summary time

###Packages used:

bioawk

bedtools http://bedtools.readthedocs.io/en/latest/

data_hacks ?

GAG ?

```
	#Install package. Command line utilities for data analysis
	pip install data_hacks
	seq_length.py input_file.fasta |cut -f 2 | histogram.py --percentage --max=12972 --min=1001
```


2.1) Print a summary report: total number of (nucelotides, Ns, sequences)

	```
	#3. Total number of sequences
		#Since each sequence is prefaced by a header, search for the number of times a header-specific string occurs:
		grep "species=Dmel" -o dmel-all-chromosome-r6.13.fasta | wc -l 
		#Output = 1870
		
		
	#0. Exclude the header(s) and create a new, headerless fasta file
		#This deletes all the characters from ">" to the end of the line, then creates a new file
		sed 's/>.*$//' dmel-all-chromosome-r6.13.fasta > dmel-all-chromosome-r6.13.2.fasta

	
	#1. Total number of nucleotides (A,C,T,G) in headerless file
		egrep "A|C|T|G" -o dmel-all-chromosome-r6.13.2.fasta | wc -l
		#Output = 142576909
	
	#2. Total number of Ns (unknown bases) in headerless file
		grep N -o dmel-all-chromosome-r6.13.2.fasta | wc -l
		#Output = 1154850

	
	
	
	#----------------
	
	
	#Extract mapped reads with header:
	awk -c sam -H '!and($flag,4)'
	
	egrep -v ^$ #removes
	
	

	#faSize 
	
	#count sequences using the built-in variable NR (number of records):
	bioawk -c fastx 'END{print NR}' test.fastq

	
	```



2.2) Print a summary report: total number of (nucelotides, Ns, sequences), but now for sequence data split into two parts: > 100kb and < 100kb

	```
	#how many sequences are shorter than 100000bp
	bioawk -cfastx 'BEGIN{ shorter = 0} {if (length($seq) < 100000) shorter += 1} END {print "shorter sequences", shorter}' test-trimmed.fastq

	```


----------------------------------------------------------------------

##3) Print summary plots

###Bioawk 
Bioawk makes it nicer to deal with bio data files (e.g. SAM, FASTA/Q). You can use bioawk to both filter on size and get GC content. 
https://www.biostars.org/p/47751/

`bioawk -c sam`



####3.1) Sequence length distribution


####3.2) Sequence GC% distribution

Get the %GC from FASTA. Ignore N's.
`awk -c fastx '{ print ">"$name; print gc($seq) }' seq.fa.gz`


####3.3) Cumulative genome size sorted from largest to smallest sequences


----------------------------------------------------------------------


Running vwa of some reads against a reference genome. Interpret those reads to figure out what kind of mutation you're dealing with and where the mutation is. 
Multiple types of genomes.
Use different aspects of the reads to figure out what is going on.
Investigate which of the flag fields indicates informative reads
A couple of R plots will make it easier to figure out


##hxor 
JJ's (horizontal XOR) shortcut for comparing the read orientation in a true/false fashion. Do they match or do the strands run opposite each other? Weird mappings hint at biologically interesting things like deletions, insertions, duplications, inversions, etc. Each has a distinctive signal.


Goal: Identify the mutation. Tell where and what kind (deletions, insertions, duplications, inversions). 

get sam file
interpret what's going on in the sam file
vwa

```
wget -r "ftp://ftp.flybase.net/genomes/Drosophila_melanogaster/dmel_r6.13_FB2016_05/gtf/dmel-all-r6.13.gtf.gz" -O "/home/jbriner/Dropbox/UCI/Classes/(F16) Informatics/FinalExercises/Overview/dmel-all-r6.13.gtf.gz" | gunzip *.gz | less
```
