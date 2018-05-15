#!/usr/bin/env Rscript

#Information provided 
  #1) from: https://jdblischak.github.io/2014-09-18-chicago/novice/r/06-cmdline.html 
  #2) from: http://tuxette.nathalievilla.org/?p=1696
  #3) Interesting comments: http://www.cureffi.org/2014/01/15/running-r-batch-mode-linux/

##### Libraries: 

suppressPackageStartupMessages(library(optparse))
suppressPackageStartupMessages(library(dplyr))
suppressPackageStartupMessages(library(RColorBrewer))

##### Option list using Python's style: 

option_list <- list(
  
  make_option(c("-f", "--file"), type = "character", default = NULL,
              help = "Name of the input file", metavar = "character"),
  make_option("--header", default = TRUE, 
              help = "the input file has header [default=%default]"),
  make_option(c("-o", "--output"), type = "character", default = "Pie.plot.out.pdf",
              help="output file name [default= %default]", metavar="character"),
  make_option(c("-t", "--title"), type="character", default = "Input Matrix",
              help = "Title of Pie plot [default=%default]")
  
)

opt_parser = OptionParser(option_list=option_list);
opt = parse_args(opt_parser);

### 

if (is.null(opt$file)){
  print_help(opt_parser)
  stop("At least one argument must be supplied (input file).\n", call.=FALSE)
}

##### Pie plot program: 

#Input <- read.delim("/users/rg/ramador/D_me/RNA-seq/AS_analysis/vast_out/New_analysis/India-samples/0_hours/Merge_Regeneration_Replicates/DiffAS-Dme2-dPSI25-range5-p_IR_Control-vs-Regeneration.tab")
#Input$COMPLEX <- Input$COMPLEX
#Input <- data.frame(COMPLEX=Input$COMPLEX)


Input <- read.delim(file = opt$file, header = opt$header)

Input[,1] <- as.character(Input[,1])

labels <- names(table(Input[,1]))
counts <- table(Input[,1]) %>% as.vector()
full_labels <- paste(labels, counts, sep = ": ")

### Plot:

pie(x=counts, labels = full_labels, main=opt$title,
    col = brewer.pal(length(full_labels), "Set1"), cex=1.5 )




##### Requirments: 

#1) If no filenames is given on the command line, read data from standard input 
#2) If one or more filenames are given, read data from them and report statistics foe each file separately
#3) Use the flags --title to determine what to print 

##### Read the input: 

# args <- commandArgs(trailingOnly = TRUE)
# for(i in args){
#   
#   Standard_input <- read.delim(file = i)
#   silly <- class(Standard_input)
#   cat(silly, sep = "\n")
#   
# }


# filename <- args[1]
# Standard_input <- read.delim(file = filename)
# class(Standard_input)

# lines <- readLines(con = file("stdin"))
# count <- length(lines)
# cat("lines in standard input: ")
# cat(count, sep = "\n")

















