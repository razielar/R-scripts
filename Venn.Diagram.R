#!/usr/bin/env Rscript

###### Perfom a Venn Diagram and produce a table of intersections and non-intersections from a 
###### dataframe/table 

options(stringsAsFactors =  FALSE)

###### Libraries

suppressPackageStartupMessages(library(dplyr))
suppressPackageStartupMessages(library(VennDiagram))
suppressPackageStartupMessages(library(optparse))

###### Option list using Python's style

option_list <- list(
  
  make_option(c("-i", "--input"), type = "character", default = "stdin",
              help = "input file [default= %default]", metavar = "character"),
  make_option("--header", default = TRUE, 
              help = "the input file has a header [default= %default]"),
  make_option(c("-o", "--outout"), type = "character", default = "Venn.Diagram.Output.tiff",
              help = "output file name. Must have a tiff extension (e.g. 'What.ever.tiff')
              [default= %default]", metavar= "character"),
  make_option(c("-t", "--title"), type = "character", default = "Input Matrix",
              help = "Title of the Venn Diagram [default= %default]")
  
)

opt_parser <-  OptionParser(option_list=option_list)
opt <- parse_args(opt_parser)

### Read the Input file:  

if (opt$input == "stdin") {
  
  Input <- read.delim(file("stdin"), h=opt$header, na.strings = "")
  
} else {
  
  Input <- read.delim(opt$input, h=opt$header, na.strings = "")
  
}

### For debugging inside Rstudio

#Input <- read.delim("/users/rg/ramador/Scripts/tmp_files/Venn.R.out.txt", h=TRUE, na.strings = "")

### This script can only do 5 comparisons 

if( ncol(Input) <= 1 | ncol(Input) <= 5){
  
  cat("The number of comparisons is:", ncol(Input), "\n" )
  
  
} else{
  
  stop("The number of comparisons is", ncol(Input), "and this script can only do between 2 and 5 comparisons", "\n")
  
}

############### Draw the Venn Diagram: 

if(ncol(Input) == 5){
  
  cat("no")
  
} else if (ncol(Input) == 4){
  
  cat("no")
  
} else if (ncol(Input) == 3){
  
  cat("Drawing the Venn Diagram with", ncol(Input), "comparisons", "\n")
  
  venn.diagram(list("hola"= Input[,1][complete.cases(Input[,1])] , "adios"=Input[,2][complete.cases(Input[,2])],
                    "bye"= Input[,3][complete.cases(Input[,3])] ),
               filename = opt$outout ,
               col="transparent", fill=c("darkorchid1", "green", "yellow"), alpha=0.4,
               cex=1.1, cat.cex=0.9, main = opt$title)
  
  
  
} else if (ncol(Input) == 2){
  
  cat("Drawing the Venn Diagram with", ncol(Input), "comparisons", "\n")
  
  venn.diagram(list("1"=Input[,1][complete.cases(Input[,1])] , "2"=Input[,2][complete.cases(Input[,2])]),
               filename = opt$outout , col="transparent",
               fill=c("darkorchid1", "green"), alpha=0.4, cex=1.1, cat.cex= 0.9,
               main = opt$title, cat.pos= c(0,0), cat.dist = rep(0.025, 2), scaled= FALSE)
  
}







































