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


##Setting up: get file, load modules

```shell
wget -O - /data/users/jbriner/ee282/dmel-all-chromosome-r6.13.fasta ftp://ftp.flybase.net/genomes/Drosophila_melanogaster/current/fasta/dmel-all-chromosome-r6.13.fasta.gz \
| gunzip dmel-all-chromosome-r6.13.fasta \
| less

module load jje/kent/2014.02.19 | module load jje/jjeutils
module list #verify
```




----------------------------------------------------------

##Print a summary report: total number of (nucelotides, Ns, sequences)
```
#1. Total number of sequences
		#Since each sequence is prefaced by a header, search for the number of times a header-specific string occurs:
		grep "species=Dmel" -o dmel-all-chromosome-r6.13.fasta | wc -l 
		    #Output (headered file) = 1870


	#2. Exclude the header(s) and create a new, headerless fasta file
		#This deletes all the characters from ">" to the end of the line, then creates a new file
		sed 's/>.*$//' dmel-all-chromosome-r6.13.fasta > dmel-all-chromosome-r6.13.2.fasta


	#3. Total number of nucleotides (A,C,T,G) in headerless file
		egrep "A|C|T|G" -o dmel-all-chromosome-r6.13.2.fasta | wc -l
		    #Output (headerless file) = 142573024


	#4. Total number of Ns (unknown bases) in headerless file
		grep N -o dmel-all-chromosome-r6.13.2.fasta | wc -l
		    #Output (headerless file) = 1152978
```

------------------------------------------------------------------------


##Print a summary report: total number of (nucelotides, Ns, sequences), but now for sequence data split into two parts: > 100kb and < 100kb

```
#0. Working with the original headered file again.

	dmel_fasta=dmel-all-chromosome-r6.13.fasta 	#giving this a nickname	
	less -N -S $dmel_fasta
	echo $dmel_fasta 	#check that nickname points to birth name

	faSize $dmel_fasta 	#Prints the total base count


#1. Filter sequences that are LESS than (or = to) 100000 nucleotides long: set ceiling with maxSize
 
	faFilter -maxSize=100000 $dmel_fasta dmel_fasta_less \
	| faSize dmel_fasta_less 	#confirm size filter worked
	
	#Print summary reports 
		faSize dmel_fasta_less		#Total no. sequences: 1863
		sed 's/>.*$//' dmel_fasta_less > dmel_fasta_less_behead 	#Strip headers
		egrep "A|C|T|G" -o dmel_fasta_less_behead | wc -l 	#Total no. nucleotides: 5515449
		grep N -o dmel_fasta_less_behead | wc -l	#Total no. Ns: 662593


#2. Filter sequences MORE than (or = to) 100000 nucleotides long: set floor with minSize

	faFilter -minSize=100000 $dmel_fasta dmel_fasta_more

	#Print summary reports 
		faSize dmel_fasta_more		#Total no. sequences: 7		
		sed 's/>.*$//' dmel_fasta_more > dmel_fasta_more_behead 	#Strip headers
		egrep "A|C|T|G" -o dmel_fasta_more_behead | wc -l 	#Total no. nucleotides: 137057575
		grep N -o dmel_fasta_more_behead | wc -l	#Total no. Ns: 490385
```

Print a summary report: total number of (nucelotides, Ns, sequences), but now for sequence data split into two parts: > 100kb and < 100kb

```
#See R script “MyWorkA_SummarizeGenomeAssembly_Plots.R” for the plotting details. I’m just prepping data files here.


#1. Sequence length distribution

	bioawk -c fastx '{ print $name, length($seq) }' $dmel_fasta > dmel_fasta_seqlength


#2. Sequence GC% distribution. Ignore N's. 

	bioawk -c fastx '{ print $name, gc($seq) }' $dmel_fasta > dmel_fasta_GC


#3. Cumulative genome size sorted from largest to smallest sequences


```
	
