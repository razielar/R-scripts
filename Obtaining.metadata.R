#!/usr/bin/env Rscript

##### Information obtained from: https://jdblischak.github.io/2014-09-18-chicago/novice/r/06-cmdline.html

##### Libraries: 

suppressPackageStartupMessages(library(optparse))
suppressPackageStartupMessages(library(dplyr))

##### Metadata matrix:

Inclusion_matrix <- read.delim("/users/rg/ramador/D_me/RNA-seq/AS_analysis/vast_out/New_analysis/India-samples/0_hours/C2_R1-vs-S2_R1_results/INCLUSION_LEVELS_FULL-Dme2.tab")

#### Read the standard input: 

args <- commandArgs(trailingOnly = TRUE)
filename <- args[1]
Standard_input <- read.delim(file = filename)

#Standard_input <- read.delim(file = "/users/rg/ramador/D_me/RNA-seq/AS_analysis/vast_out/New_analysis/plots/Removing-batc-effects/zero.rank.events.mean.txt")

Standard_input$dPSI <- round(Standard_input$dPSI, digits = 2)

##### Function: 


f.Obtain.metadata.PSI <- function(Desired.matrix, Metadata.matrix){
  
  Result <- Metadata.matrix[which(Metadata.matrix[,2] %in% rownames(Desired.matrix)),][,1:6]
  dPSI <- data.frame(dPSI=Desired.matrix$dPSI)
  dPSI <- cbind(data.frame(AS=rownames(Desired.matrix)), dPSI)
  tmp.Result <- merge(Result, dPSI,by.x = "EVENT", by.y = "AS" )
  
  tmp.Result <- tmp.Result[order(tmp.Result$dPSI, decreasing = TRUE),]
  tmp.Result <- cbind(data.frame(GENE=tmp.Result$GENE), tmp.Result[,c(1, 3:ncol(tmp.Result))])
  rownames(tmp.Result) <- 1:nrow(tmp.Result)

  return(tmp.Result)
  
}

Result <- f.Obtain.metadata.PSI(Desired.matrix = Standard_input, Metadata.matrix = Inclusion_matrix)


for(i in 1:ncol(Result)){
    
    Col_name <- colnames(Result)[i]
    print(Col_name)
    print(data.frame(Name=Result[,i]), row.names = FALSE, colnames=FALSE)
    cat("\n\n")
  
}

q(save='no')
