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
  make_option(c("-o", "--outout"), type = "character", default = "Venn.Diagram.output.png",
              help = "output file name. Must have a png extension (e.g. 'What.ever.png')
              [default= %default]", metavar= "character"),
  make_option(c("-t", "--title"), type = "character", default = "Input Matrix",
              help = "Title of the Venn Diagram [default= %default]")
  
)

opt_parser <-  OptionParser(option_list=option_list)
opt <- parse_args(opt_parser)













