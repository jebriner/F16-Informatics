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
    colnames(dmel_seqlength.df) <-c("sequence", "length")
  
  dmel_GC.df <- read.table("~/Dropbox/School/UCI/Classes/(F16) Informatics/FinalExercises/GenomeFiles/dmel_fasta_GC", header=FALSE, sep = "")
    colnames(dmel_GC.df) <-c("sequence", "percentGC")


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
          
    genomesize_plot <- ggplot(genomesize.df, aes(x=length)) + geom_histogram(bins=200, fill="violetred3") + scale_x_log10() +
      ggtitle("Histogram: Cumulative genome size, largest to smallest sequences") +
      labs(x="sequence length in nucleotides (log10) ", y="number of sequences") +
      theme(plot.title = element_text(family = "Trebuchet MS", color="#000066", face="bold", size=24)) +
      theme(axis.title = element_text(family = "Trebuchet MS", color="#666666", face="bold", size=16))       
          
          
      