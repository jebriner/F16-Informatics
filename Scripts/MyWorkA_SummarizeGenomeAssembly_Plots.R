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
    
  #2. Sequence GC% distribution [DONE]
   
    GC_plot <- ggplot(dmel_GC.df, aes(x=percentGC)) + geom_histogram(fill="deepskyblue4") + 
      ggtitle("Histogram: Sequences by GC content") +
      labs(x="GC content (%) ", y="number of sequences") +
      theme(plot.title = element_text(family = "Trebuchet MS", color="#000066", face="bold", size=24)) +
      theme(axis.title = element_text(family = "Trebuchet MS", color="#666666", face="bold", size=16)) 
    
    
  #3. Cumulative genome size sorted from largest to smallest sequences [DONE]      
    
    #Make the first df column an ordered factor so ggplot doesn't alphebetize my chromosomes. Want to keep it ordered by size.
      dmel_seqlength_simp.df$genomicLocation <- factor(dmel_seqlength_simp.df$genomicLocation, levels = dmel_seqlength_simp.df$genomicLocation) 
    
    #Plot
    genomesize_plot <- ggplot(dmel_seqlength_simp.df, aes(x=genomicLocation, y=sizepercent)) + geom_bar(stat="identity", fill="violetred3", width=.5) +
      ggtitle("Bar plot: Cumulative genome size, largest to smallest") +
      labs(x="chromosome arm", y="size (as percentage of total genome)") +
      theme(plot.title = element_text(family = "Trebuchet MS", color="#000066", face="bold", size=24)) +
      theme(axis.title = element_text(family = "Trebuchet MS", color="#666666", face="bold", size=16))       
          
          
      