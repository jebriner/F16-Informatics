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
      
    
    
    
