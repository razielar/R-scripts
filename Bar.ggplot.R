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
  make_option(c("-o", "--output"), type = "character", default = "Bar.plot.out.pdf",
              help="output file name. Must have a pdf extension (e.g. 'What.ever.pdf') [default= %default]", 
              metavar="character"),
  make_option(c("-t", "--title"), type="character", default = "Input Matrix",
              help = "Title of Pie plot [default=%default]"),
  make_option(c("-x", "--x_axis"), type = "character", default = " ",
              help = "Name of the x-axis [default=%default]"),
  make_option(c("-y", "--y_axis"), type = "character", default = "Count",
              help = "Name of the y-axis [default=%default]"),
  make_option("--x_axis_rotation", default = FALSE,
              help = "the x axis rotation [default=%default]")
  
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

Input <- data.frame(Header=Input[order(Input[,1]),])

Input <- Input %>% group_by(Header) %>% summarise(Frequency=n()) %>% arrange(desc(Frequency))

max_value <- as.numeric(Input[1,2])
max_value <- floor(max_value+max_value*0.05)
interval_value <- floor(max_value/10)

#### Bar plot: 

if (opt$x_axis_rotation){
  
  #pdf(file = opt$output, width = 0, height = 0, paper = "a4r")
  
  p <- ggplot(data = Input, aes(x=Header, y=Frequency))+geom_bar(stat = "identity", fill= "steelblue",
                                                            alpha=0.9)+ggtitle(opt$title)+
    theme(plot.title = element_text(hjust = 0.5, face = "bold"), axis.text.y = element_text(face = "bold"),
          axis.text.x = element_text(face = "bold", angle = 45, hjust = 1), 
          text = element_text(size=13, face = "bold"))+xlab(opt$x_axis)+ylab(opt$y_axis)+
    geom_text(aes(label=Frequency), vjust=-0.35)+scale_y_continuous(breaks = seq(0, max_value, interval_value))
  
  #dev.off()
  
} else {
  
  #pdf(file = opt$output, width = 0, height = 0, paper = "a4r")
  
  p <- ggplot(data = Input, aes(x=Header, y=Frequency))+geom_bar(stat = "identity", fill= "steelblue",
                                                            alpha=0.9)+ggtitle(opt$title)+
    theme(plot.title = element_text(hjust = 0.5, face = "bold"), axis.text.y = element_text(face = "bold"),
          axis.text.x = element_text(face = "bold"), 
          text = element_text(size=13, face = "bold"))+xlab(opt$x_axis)+ylab(opt$y_axis)+
    geom_text(aes(label=Frequency), vjust=-0.35)+scale_y_continuous(breaks = seq(0, max_value, interval_value))
  
  #dev.off()
  
}

pdf(file = opt$output, width = 0, height = 0, paper = "a4r")

p

dev.off()


