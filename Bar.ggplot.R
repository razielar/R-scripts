#!/usr/bin/env Rscript

######## Bar_plot R script 

##### Libraries: 

suppressPackageStartupMessages(library(optparse))
suppressPackageStartupMessages(library(ggplot2))
suppressPackageStartupMessages(library(dplyr))

##### Option list using Python's style: 

option_list <- list(
  
  make_option(c("-i", "--input"), type = "character", default = "stdin",
              help = "input file [default=%default]", metavar = "character"),
  make_option("--header", default = TRUE, 
              help = "the input file has header [default=%default]"),
  make_option(c("-o", "--output"), type = "character", default = "Pie.plot.out.pdf",
              help="output file name. Must have a pdf extension (e.g. 'What.ever.pdf') [default= %default]", 
              metavar="character"),
  make_option(c("-t", "--title"), type="character", default = "Input Matrix",
              help = "Title of Pie plot [default=%default]"),
  make_option(c("-x", "--x_axis"), type = "character", default = " ",
              help = "Name of the x-axis [default=%default]"),
  make_option(c("-y", "--y_axis"), type = "character", default = "Count",
              help = "Nmae of the y-axis [default=%default]")
  
)

opt_parser <-  OptionParser(option_list=option_list)
opt <- parse_args(opt_parser)

### Read the Input file:  

if (opt$input == "stdin") {
  
  Input <- read.delim(file("stdin"), h=opt$header)
  
} else {
  
  Input <- read.delim(opt$input, h=opt$header)
  
}

########### Bar plot using ggplot2 

#For debugging inside RStudio
#Input <- read.delim("/users/rg/ramador/utils/tmp.Input.Bar.ggplot.R")

Input[,1] <- as.character(Input[,1])

print(Input[1,1])














