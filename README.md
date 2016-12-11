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

Module load allows you to use software uploaded by individual users, modifying your environment on a per-module basis. 
To see software JJ has made available to the cluster:
```shell
	module avail #see what's available
	module load jje/jjeutils jje/kent 
	module list #verify
```




----------------------------------------------------------

##1) Prepare the files.
```
#1.1) Download the fasta of all chromosomes with wget (the -P prefix specifies the download destination). Pipe into gunzip.

wget -r -A "ftp://ftp.flybase.net/genomes/Drosophila_melanogaster/current/fasta/dmel-all-chromosome-r6.13.fasta.gz" -O "/home/jbriner/Desktop/(F16) Informatics/FinalExercises/Overview/dmel-all-chromosome-r6.13.fasta" | gunzip  *.fastq.gz | less

#1.2) Get a sense for what I'm dealing with

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
	#1. Total number of sequences
		#Since each sequence is prefaced by a header, search for the number of times a header-specific string occurs:
		grep "species=Dmel" -o dmel-all-chromosome-r6.13.fasta | wc -l 
			#Output = 1870
		
		
	#2. Exclude the header(s) and create a new, headerless fasta file
		#This deletes all the characters from ">" to the end of the line, then creates a new file
		sed 's/>.*$//' dmel-all-chromosome-r6.13.fasta > dmel-all-chromosome-r6.13.2.fasta

	
	#3. Total number of nucleotides (A,C,T,G) in headerless file
		egrep "A|C|T|G" -o dmel-all-chromosome-r6.13.2.fasta | wc -l
			#Output (header file) = 142576909 
			#Output (headerless file) = 142573024

	
	#4. Total number of Ns (unknown bases) in headerless file
		grep N -o dmel-all-chromosome-r6.13.2.fasta | wc -l
			#Output (header file) = 1154850
			#Output (headerless file) = 1152978
	```



2.2) Print a summary report: total number of (nucelotides, Ns, sequences), but now for sequence data split into two parts: > 100kb and < 100kb

	```
	#1. Return to using the original, header'd file
	grep "length=23513712l" -o dmel-all-chromosome-r6.13.fasta | wc -l 


	#how many sequences are shorter than 100000bp
	bioawk -cfastx 'BEGIN{ shorter = 0} {if (length($seq) < 100000) shorter += 1} END {print "shorter sequences", shorter}' test-trimmed.fastq
	
	
	#----------------
	
	
	#Extract mapped reads with header:
	awk -c sam -H '!and($flag,4)'
	
	#faSize 
	
	#count sequences using the built-in variable NR (number of records):
	bioawk -c fastx 'END{print NR}' test.fastq

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


