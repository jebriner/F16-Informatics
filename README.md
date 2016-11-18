# F16-Informatics

###Summarize a genome assembly
We will be working with the *Drosophila melanogaster* genome. You can start at flybase.org. Go to the most current download genomes section and download the fasta of all chromosomes.

###Print a summary report with the following information:

+ Total number of nucleotides
+ Total number of Ns
+ Total number of sequences
+ Repeat the above analysis, except split the data into sequences > 100kb and < 100kb

###Print summary plots of the following:

+ Sequence length distribution
+ Sequence GC% distribution
+ Cumulative genome size sorted from largest to smallest sequences



-------------------------------------------------

`ssh jbriner@hpc.oit.uci.edu`

Module load allows you to use software uploaded by individual users, modifying your environment on a per-module basis. 
To peek at software jje has made available to the cluster:

```
	module avail #see what's available
	module load jje/kent/2014.02.19  #has FAsize (fasta nucleotide counting)
	module load jje/jjeutils/0.1a  #has a lot of other software we've used in class
	module list #verify
	module whatis #probe
```

`module load /data/modulefiles/USER_CONTRIBUTED_SOFTWARE/kent; /data/modulefiles/USER_CONTRIBUTED_SOFTWARE/jje/jjeutils`


##Bioawk 
Bioawk makes it nicer to deal with bio data files (e.g. SAM, FASTA/Q)
https://www.biostars.org/p/47751/
`bioawk -c sam`
can use bioawk to both filter on size and get GC content

##hxor 
JJ's (horizontal XOR) shortcut for comparing the read orientation in a true/false fashion. Do they match or do the strands run opposite each other? Weird mappings hint at biologically interesting things like deletions, insertions, duplications, inversions, etc. Each has a distinctive signal.


Goal: Identify the mutation. Tell where and what kind (deletions, insertions, duplications, inversions). 

get sam file
interpret what's going on in the sam file
vwa





----------------------------------------------------------

##1) Prepare the files.

1.1) download the fasta of all chromosomes with wget (-P prefix specifies the download destination). Pipe into gunzip
	wget -r -A ftp://ftp.flybase.net/genomes/Drosophila_melanogaster/current/fasta/dmel-all-chromosome-r6.13.fasta.gz -P "/home/jbriner/	Desktop/(F16) Informatics/FinalExercises/Overview/dmel-all-chromosome-r6.13.fasta" | gunzip  *.fastq.gz | less


1.2) Get a sense for what I'm dealing with
	
  ```
  cd "/home/jbriner/Dropbox/UCI/Classes/(F16) Informatics/FinalExercises/Overview" 
	head "dmel-all-chromosome-r6.13.fasta"
  ```
	
  `#>2L type=golden_path_region; loc=2L:1..23513712; ID=2L; dbxref=GB:AE014134,GB:AE014134,REFSEQ:NT_033779; 		MD5=b6a98b7c676bdaa11ec9521ed15aff2b; length=23513712; release=r6.13; species=Dmel;`
	
	Data is arranged in columns


------------------------------------------------------------------------


##2) Summary time

	#Install package. Command line utilities for data analysis
	pip install data_hacks
	seq_length.py input_file.fasta |cut -f 2 | histogram.py --percentage --max=12972 --min=1001


2.1) Print a summary report: total number of (nucelotides, Ns, sequences)

	#Exclude the header (by what criterion?). Just count A,C,T,G.
	egrep -v ^$ #removes


	#How many nucleotides?
	count #count all letters that are A,C,T, or G

	#faSize 



2.2) Print a summary report: total number of (nucelotides, Ns, sequences), but now for sequence data split into two parts: > 100kb and < 100kb

	#split data (check the baseball exercise)

	subset1
	subset2




----------------------------------------------------------------------


Running vwa of some reads against a reference genome. Interpret those reads to figure out what kind of mutation you're dealing with and where the mutation is. 
Multiple types of genomes.
Use different aspects of the reads to figure out what is going on.
Investigate which of the flag fields indicates informative reads
A couple of R plots will make it easier to figure out
