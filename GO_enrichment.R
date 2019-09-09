#!/usr/bin/env Rscript

############################### GO enrichment analysis

##### Libraries:
suppressPackageStartupMessages(library(optparse))
suppressPackageStartupMessages(library(dplyr))
options(stringsAsFactors = FALSE)

##### Option list using Python's style: 

option_list <- list(
  
  make_option(c("-u", "--universe"), help = "a list of gene identifiers, NO header"),
  make_option(c("-G", "--genes"), default = "stdin",
              help = "a list of gene identifiers for the foreground, NO header [default=%default]"),
  make_option(c("-o", "--ontology"), help = "choose the Gene Ontology < BP,MF,CC > [default=%default]", 
              default= "BP")
  
)

opt_parser <- OptionParser(option_list = option_list)
opt <- parse_args(opt_parser)
















