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
  
  make_option(c("-i", "--input"), type = "character", default = "stdin",
              help = "input file [default=%default]", metavar = "character"),
  make_option("--header", default = TRUE, 
              help = "the input file has header [default=%default]"),
  make_option(c("-o", "--output"), type = "character", default = "Pie.plot.out.pdf",
              help="output file name. Must have a pdf extension (e.g. 'What.ever.pdf') [default= %default]", 
              metavar="character"),
  make_option(c("-t", "--title"), type="character", default = "Input Matrix",
              help = "Title of Pie plot [default=%default]")
  
)

opt_parser <-  OptionParser(option_list=option_list)
opt <- parse_args(opt_parser)

### Read the Input file:  

if (opt$input == "stdin") {
  
  Input <- read.delim(file("stdin"), h=opt$header)
  
} else {
  
  Input <- read.delim(opt$input, h=opt$header)
  
}

##### Pie plot program: For debugging inside RStudio

# Input <- read.delim("/users/rg/ramador/D_me/RNA-seq/AS_analysis/vast_out/New_analysis/India-samples/0_hours/Merge_Regeneration_Replicates/DiffAS-Dme2-dPSI25-range5-p_IR_Control-vs-Regeneration.tab")
# Input$COMPLEX <- Input$COMPLEX
# Input <- data.frame(COMPLEX=Input$COMPLEX)


Input[,1] <- as.character(Input[,1])

labels <- names(table(Input[,1]))
counts <- table(Input[,1]) %>% as.vector()
full_labels <- paste(labels, counts, sep = ": ")

### Plot:

pdf(file = opt$output, width = 0, height = 0, paper = "a4r")
pie(x=counts, labels = full_labels, main=opt$title,
    col = brewer.pal(length(full_labels), "Set1"), cex=1.5 )
dev.off()

