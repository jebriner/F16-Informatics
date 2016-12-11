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


##Print summary plots for the original, unsplit sequence data


```
#See R script “MyWorkA_SummarizeGenomeAssembly_Plots.R” for the plotting details. I’m just prepping data files here.


#1. Sequence length distribution

	bioawk -c fastx '{ print $name, length($seq) }' $dmel_fasta > dmel_fasta_seqlength


#2. Sequence GC% distribution. Ignore N's. 

	bioawk -c fastx '{ print $name, gc($seq) }' $dmel_fasta > dmel_fasta_GC


#3. Cumulative genome size sorted from largest to smallest sequences


```

```R
#(F16) Informatics
#161208 Briner
#--------------------

#For the fasta file for *D. melanogaster*: dmel-all-chromosome-r6.13.2.fasta

#A-c) Print summary plots of the following:
  #Sequence length distribution
  #Sequence GC% distribution
  #Cumulative genome size sorted from largest to smallest sequences

#----------------------

rm(list = ls())
library(ggplot2)
library(dplyr)
library(splitstackshape)


#preliminaries 
  setwd("~/Dropbox/School/UCI/Classes/(F16) Informatics/FinalExercises")
  
  dmel_seqlength.df <- read.delim("~/Dropbox/School/UCI/Classes/(F16) Informatics/FinalExercises/GenomeFiles/dmel_fasta_seqlength", header=FALSE, sep = "")
    colnames(dmel_seqlength.df) <-c("genomicLocation", "length")
  
  dmel_GC.df <- read.table("~/Dropbox/School/UCI/Classes/(F16) Informatics/FinalExercises/GenomeFiles/dmel_fasta_GC", header=FALSE, sep = "")
    colnames(dmel_GC.df) <-c("genomicLocation", "length")

  #cumulative genome size: sort by sequence length (descending)
    dmel_seqlength_ordered.df <- dmel_seqlength.df[order(dmel_seqlength.df$length, decreasing = TRUE), ]
    dmel_seqlength_ordered.df$sizepercent <- ( dmel_seqlength_ordered.df$length / sum(dmel_seqlength.df$length) ) * 100 #add new row: transform sequence length into a percentage of total genome size
    dmel_seqlength_ordered.df <- dmel_seqlength_ordered.df[!(dmel_seqlength_ordered.df$sizepercent < 0.07), ] #remove all sequences that contribute little to the total genome size. Just looking at the chromosomes now.
    
    dmel_seqlength_simp.df <- data.frame(dmel_seqlength_ordered.df$genomicLocation, dmel_seqlength_ordered.df$sizepercent) #drop unnecessary length column
      colnames(dmel_seqlength_simp.df) <-c("genomicLocation", "sizepercent")
    
#------------------------------------------
#A-c) Print summary plots of the following:
#------------------------------------------    
          
  #1. Sequence length distribution [DONE]
    
    seqlength_plot <- ggplot(dmel_seqlength.df, aes(x=length)) + geom_histogram(bins=200, fill="mediumorchid4") + scale_x_log10() +
      ggtitle("Histogram: Sequence length distribution") +
      labs(x="sequence length in nucleotides (log10)", y="number of sequences") +
      theme(plot.title = element_text(family = "Trebuchet MS", color="#000066", face="bold", size=24)) +
      theme(axis.title = element_text(family = "Trebuchet MS", color="#666666", face="bold", size=16)) 
    
  #2. Sequence GC% distribution
   
    GC_plot <- ggplot(dmel_GC.df, aes(x=percentGC)) + geom_histogram(fill="deepskyblue4") + 
      ggtitle("Histogram: Sequences by GC content") +
      labs(x="GC content (%) ", y="number of sequences") +
      theme(plot.title = element_text(family = "Trebuchet MS", color="#000066", face="bold", size=24)) +
      theme(axis.title = element_text(family = "Trebuchet MS", color="#666666", face="bold", size=16)) 
    
    
  #3. Cumulative genome size sorted from largest to smallest sequences      
    
    #Make the first df column an ordered factor so ggplot doesn't alphebetize my chromosomes. Want to keep it ordered by size.
      dmel_seqlength_simp.df$genomicLocation <- factor(dmel_seqlength_simp.df$genomicLocation, levels = dmel_seqlength_simp.df$genomicLocation) 
    
    #Plot
    genomesize_plot <- ggplot(dmel_seqlength_simp.df, aes(x=genomicLocation, y=sizepercent)) + geom_bar(stat="identity", fill="violetred3", width=.5) +
      ggtitle("Bar plot: Cumulative genome size, largest to smallest") +
      labs(x="chromosome", y="size (as percentage of total genome)") +
      theme(plot.title = element_text(family = "Trebuchet MS", color="#000066", face="bold", size=24)) +
      theme(axis.title = element_text(family = "Trebuchet MS", color="#666666", face="bold", size=16))       
          

    
          
          
```


##Summarize an annotation file

```R

#(F16) Informatics
#161208 Briner
#--------------------

#For the gtf annotation file for *D. melanogaster*:

#1. Print a summary report with the following information:
  #1.1. Total number of features of each type, sorted from the most common to the least common
  #1.2. Total number of genes per chromosome arm (X, Y, 2L, 2R, 3L, 3R, 4)

#2. Print summary plots of the following:
  #2.1. Histogram of the number of transcripts (mRNAs) per gene 
  #2.2. Histogram of the length of genes
  #2.3. Histogram of the length of exons

#----------------------

rm(list = ls())
library(ggplot2)
library(dplyr)
library(splitstackshape)


#preliminaries 
  setwd("~/Dropbox/School/UCI/Classes/(F16) Informatics")
  
  dmel_proto.df <- read.delim("/home/jbriner/Dropbox/School/UCI/Classes/(F16) Informatics/FinalExercises/dmel-all-r6.13.gtf", header=FALSE, sep = " ")
  dmel.df <- cSplit(dmel_proto.df, splitCols = 1, sep = "\t", drop = TRUE) # split concatenated column 1 by empty space
    colnames(dmel.df) <-c("FBgenenumber", "gene_symbol", "V4", "transcriptID", "FBtr", "transcriptSymbol", "V8", "chromosome", "source", "feature", "start", "end", "score", "strand", "frame", "attributes")
       rm(dmel_proto.df) #get rid of the massive unnecessary proto dataframe
    
#probe
  dim(dmel.df)
  View(dmel.df)
  sapply(dmel.df, function(col) length(unique(col))) #find out how many unique values are in each column

  
  
#--------------------------------------------------------   
#1. Print a summary report with the following information:
#--------------------------------------------------------    
  
    #1.1. Total number of features of each type, sorted from the most common to the least common (DONE)
      as.data.frame(table(dmel.df$feature))
      
    #1.2. Total number of genes per chromosome arm (X, Y, 2L, 2R, 3L, 3R, 4)  (DONE)
      
        dmel_genes.df <- dmel.df[ which(dmel.df$feature=="gene"), ]   #subset dmel.df to just the rows containing genes 
          as.data.frame(table(dmel_genes.df$chromosome))    #count the number of rows (genes) in the data frame based on type (chromosome identity)

        
#---------------------------------------
#2. Print summary plots of the following:
#---------------------------------------    
      
    #2.1. Histogram of the number of transcripts per gene (DONE)
      
      dmel_transcripts.df <- dmel.df[ which(dmel.df$feature=="mRNA"), ] #subset dmel.df to just mRNA 
      dmel_transcriptsbygene.df <- dmel_transcripts.df[order(dmel_transcripts.df$FBgenenumber), ]  #yank out gene id. I want unique gene numbers. 
        
        #count occurrences of each unique FBgenenumber. Each repetition of an FBgenenumber represents a different transcript.
        dmel_transcriptsbygene_counts.df = as.data.frame(table(dmel_transcriptsbygene.df$FBgenenumber))    #count the number of rows (genes) in the data frame based on type (chromosome identity)
        colnames(dmel_transcriptsbygene_counts.df) <-c("FBgenenumber", "Counts")
          head(dmel_transcriptsbygene_counts.df)
      
        
        #plot number of times each FBgenenumber occurs
        transcriptplot_base <- hist(log(table(dmel_uniquetranscriptsbygene.df$FBgenenumber))) #this solution vetted by JJ, but can "change the base to make it more meaningful."
          
          #barplot(table(dmel_uniquetranscriptsbygene.df$FBgenenumber)) #gross
      
        transcriptplot <- ggplot((dmel_transcriptsbygene_counts.df), aes(x=Counts)) + geom_histogram(bins=60, fill="sienna2") + 
          scale_y_log10(expand = c(0, 0)) + scale_x_continuous(expand = c(0, 0), limits = c(0, 40)) +
          ggtitle("Histogram: Number of transcripts per gene") +
          labs(x="number of transcripts per gene", y="number of genes (log10)") +
          theme(plot.title = element_text(family = "Trebuchet MS", color="#000066", face="bold", size=24)) +
          theme(axis.title = element_text(family = "Trebuchet MS", color="#666666", face="bold", size=16)) 
        
      
      
    #2.2. Histogram of the length of genes (DONE)
      
      dmel_genes <- dmel.df[feature == "gene"] #Subset by genes
      dmel_genes$length <- (dmel_genes$end - dmel_genes$start + 1) #add one
      
      geneplot <- ggplot(dmel_genes, aes(x=length)) + geom_histogram(bins=200, fill="#00CCCC") + scale_x_log10() +
        ggtitle("Histogram: Gene length") +
        labs(x="gene length (log10)", y="frequency") +
        theme(plot.title = element_text(family = "Trebuchet MS", color="#000066", face="bold", size=24)) +
        theme(axis.title = element_text(family = "Trebuchet MS", color="#666666", face="bold", size=16)) 
    
    
      
    #2.3. Histogram of the length of exons (DONE)
      
      dmel_exons <- dmel.df[feature == "exon"] #Subset by exons
      dmel_exons$length <- (dmel_exons$end - dmel_exons$start + 1) #add one
      
        exonplot <- ggplot(dmel_exons, aes(x=length)) + geom_histogram(bins=50, fill="limegreen") + scale_x_log10() +
        ggtitle("Histogram: Exon length") +
        labs(x="exon length (log10)", y="frequency") +
        theme(plot.title = element_text(family = "Trebuchet MS", color="#000066", face="bold", size=24)) +
        theme(axis.title = element_text(family = "Trebuchet MS", color="#666666", face="bold", size=16)) 
      
    
```    
    

