#(F16) Informatics
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

#probe
  dim(dmel.df)
  View(dmel.df)
  sapply(dmel.df, function(col) length(unique(col))) #find out how many unique values are in each column

  
  
#--------------------------------------------------------   
#1. Print a summary report with the following information:
#--------------------------------------------------------    
  
    #1.1. Total number of features of each type, sorted from the most common to the least common  (NEEDS WORK)
      dmel.df[feature] 
      count
    
    #1.2. Total number of genes per chromosome arm (X, Y, 2L, 2R, 3L, 3R, 4)  (NEEDS WORK)
      dmel.df$chromosome[feature="genes"]


#---------------------------------------
#2. Print summary plots of the following:
#---------------------------------------    
      
    #2.1. Histogram of the number of transcripts per gene (NEEDS WORK)
      
      dmel_transcripts <- dmel.df[feature == "mRNA"] #Subset by mRNA 
      dmel_transcripts2 <- dmel_transcripts[order(dmel_transcripts$FBgenenumber), ]  #yank out gene id. I want unique gene numbers. 
      head(dmel_transcripts2)
      
     unique(dmel_transcripts$FBgenenumber) #count occurrences of each unique FBgenenumber. Each repetition of an FBgenenumber represents a different transcript.
      
    test <- group_by(dmel_transcripts, FBgenenumber)
     summarise(test, tally(FBgenenumber))
     filter(test, disp == max(disp))
      
      
      
      # group the exons by transcript
      exons <- exonsBy(txdb, by = "tx")
      # make a data frame with transcripts and exon count
      exons.tx <- data.frame(tx = 1:length(exons), exons = sapply(exons, length))
      # plot
      ggplot(exons.tx) + geom_histogram(aes(exons), fill = "blue") + theme_bw()
      
      
      
    #2.2. Histogram of the length of genes (DONE)
      
      dmel_genes <- dmel.df[feature == "gene"] 
      dmel_genes$length <- (dmel_genes$end - dmel_genes$start + 1)
      
      geneplot <- ggplot(dmel_genes, aes(x=length)) + geom_histogram(bins=200, fill="#00CCCC") + scale_x_log10() +
        ggtitle("Gene length histogram") +
        labs(x="gene length (log10)", y="frequency") +
        theme(plot.title = element_text(family = "Trebuchet MS", color="#000066", face="bold", size=24)) +
        theme(axis.title = element_text(family = "Trebuchet MS", color="#666666", face="bold", size=16)) 
    
    
      
    #2.3. Histogram of the length of exons (DONE)
      
      dmel_exons <- dmel.df[feature == "exon"] #Subset by exons
      dmel_exons$length <- (dmel_exons$end - dmel_exons$start + 1)
      
        exonplot <- ggplot(dmel_exons, aes(x=length)) + geom_histogram(bins=50, fill="limegreen") + scale_x_log10() +
        ggtitle("Exon length histogram") +
        labs(x="exon length (log10)", y="frequency") +
        theme(plot.title = element_text(family = "Trebuchet MS", color="#000066", face="bold", size=24)) +
        theme(axis.title = element_text(family = "Trebuchet MS", color="#666666", face="bold", size=16)) 
      
    
    
    
