Date: 161114


ssh jbriner@hpc.oit.uci.edu

#module load allows you to use software uploaded by individual users. Peek at software jje has made available to the cluster:
module load jje/kent

#will find jje/jjeutils/0.1a useful. Has a lot of the software we've used in class. jje/kent/ has FAsize (fasta nucleotide counting). 

----------------------------------------------------------

#1) Prepare the files.

#1.1) download the fasta of all chromosomes with wget (-P prefix specifies the download destination). Pipe into gunzip
wget -r -A ftp://ftp.flybase.net/genomes/Drosophila_melanogaster/current/fasta/dmel-all-chromosome-r6.13.fasta.gz -P "/home/jbriner/Desktop/(F16) Informatics/FinalExercises/Overview/dmel-all-chromosome-r6.13.fasta" | gunzip  *.fastq.gz | less


#1.2) Get a sense for what I'm dealing with
	cd "/home/jbriner/Dropbox/UCI/Classes/(F16) Informatics/FinalExercises/Overview" 
	head "dmel-all-chromosome-r6.13.fasta"

	#>2L type=golden_path_region; loc=2L:1..23513712; ID=2L; dbxref=GB:AE014134,GB:AE014134,REFSEQ:NT_033779; 		MD5=b6a98b7c676bdaa11ec9521ed15aff2b; length=23513712; release=r6.13; species=Dmel;
	
	#Data is arranged in columns


------------------------------------------------------------------------


#2) Summary time

	#Install package. Command line utilities for data analysis
	pip install data_hacks
	seq_length.py input_file.fasta |cut -f 2 | histogram.py --percentage --max=12972 --min=1001


#2.1) Print a summary report: total number of (nucelotides, Ns, sequences)

	#Exclude the header (by what criterion?). Just count A,C,T,G.
	egrep -v ^$ #removes


	#How many nucleotides?
	count

	#faSize



#2.2) Print a summary report: total number of (nucelotides, Ns, sequences), but now for sequence data split into two parts: > 100kb and < 100kb

	#split data (check the baseball exercise)
	subset1
	subset2




----------------------------------------------------------------------


#Running vwa of some reads against a reference genome. Interpret those reads to figure out what kind of mutation you're dealing with and where the mutation is. 
#Multiple types of genomes.
#Use different aspects of the reads to figure out what is going on.
#Investigate which of the flag fields indicates informative reads
#A couple of R plots will make it easier to figure out
