#!/usr/bin/env Rscript

############################### GO enrichment analysis

##### Libraries:
suppressPackageStartupMessages(library(optparse))
suppressPackageStartupMessages(library(dplyr))
suppressPackageStartupMessages(library(GO.db))
suppressPackageStartupMessages(library(GOstats))
options(stringsAsFactors = FALSE)

##### Option list using Python's style: 

option_list <- list(
  
  make_option(c("-u", "--universe"), help = "a list of gene identifiers, NO header"),
  make_option(c("-G", "--genes"), default = "stdin",
              help = "a list of gene identifiers for the foreground, NO header [default=%default]"),
  make_option(c("-O", "--ontology"), help = "choose the Gene Ontology < (BP,MF,CC) > [default=%default]", 
              default= "BP"),
  make_option(c("-s", "--species"), help = "choose the species <(Dmel, Human)> [default=%default]",
              default = "Dme"),
  make_option(c("-o", "--output"), help = "name of the output [default=%default]", 
              default = "GO.enrich.txt")
)

opt_parser <- OptionParser(option_list = option_list)
opt <- parse_args(opt_parser)
















