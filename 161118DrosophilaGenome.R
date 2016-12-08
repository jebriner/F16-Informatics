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
library(GenomicFeatures)
library(splitstackshape)

#Preliminaries 
setwd("~/Dropbox/School/UCI/Classes/(F16) Informatics")
dmel_proto.df <- read.delim("/home/jbriner/Dropbox/School/UCI/Classes/(F16) Informatics/FinalExercises/dmel-all-r6.13.gtf", header=FALSE, sep = " ")
dmel.df <- cSplit(dmel_proto.df, splitCols = 1, sep = "\t", drop = TRUE) # split concatenated column 1 by empty space
  colnames(dmel.df) <-c("FBgenenumber", "gene_symbol", "V4", "transcriptID", "FBtr", "transcriptSymbol", "V8", "chromosome", "source", "feature", "start", "end", "score", "strand", "frame", "attributes")

dim(dmel.df)
View(dmel.df)
sapply(dmel.df, function(col) length(unique(col))) #find out how many unique values are in each column




#1. Total number of features of each type, sorted from the most common to the least common
dmel.df[feature] 
count

#2. Total number of genes per chromosome arm (X, Y, 2L, 2R, 3L, 3R, 4)
dmel.df$chromosome[feature="genes"]





#1. Histogram of the number of transcripts per gene 
  
  dmel_transcripts <- dmel.df[feature == "mRNA"] #Subset by mRNA 
  #yank out gene id
  

#2. Histogram of the length of genes
  
  dmel_genes$length <- dmel_genes$end - dmel_genes$start 
  hist(dmel_genes$length, breaks = "")
  
  hist(log(dmel_genes$length))

  #Scale transformation on ggplot for histogram of sequence size (log transform).
  myplot <- ggplot(dmel_anno, aes(carat, price)) +
    myplot + geom_histogram(bins=200) + scale_x_log10() + scale_y_log10()
  
#3. Histogram of the length of exons
  
  dmel_exons <- dmel.df[feature == "exon"] #Subset by exons
  



