#!/usr/bin/env Rscript

###### Perfom a Venn Diagram and produce a table of intersections and non-intersections from a 
###### dataframe/table 

options(stringsAsFactors =  FALSE)

###### Libraries

suppressPackageStartupMessages(library(dplyr))
suppressPackageStartupMessages(library(VennDiagram))
suppressPackageStartupMessages(library(optparse))
suppressPackageStartupMessages(library(plyr))

###### Option list using Python's style

option_list <- list(
  
  make_option(c("-i", "--input"), type = "character", default = "stdin",
              help = "input file [default= %default]", metavar = "character"),
  make_option("--header", default = TRUE, 
              help = "the input file has a header [default= %default]"),
  make_option(c("-o", "--output"), type = "character", default = "Venn.Diagram.Output.tiff",
              help = "output file name. Must have a tiff extension (e.g. 'What.ever.tiff')
              [default= %default]", metavar= "character"),
  make_option(c("-t", "--title"), type = "character", default = "Input Matrix",
              help = "Title of the Venn Diagram [default= %default]")
  
)

opt_parser <-  OptionParser(option_list=option_list)
opt <- parse_args(opt_parser)

#############################

### Read the Input file:  

if (opt$input == "stdin") {
  
  Input <- read.delim(file("stdin"), h=opt$header, na.strings = "")
  
} else {
  
  Input <- read.delim(opt$input, h=opt$header, na.strings = "")
  
}

############################# Function: 

f.Print.the.txt.output <- function(out.put.name){
  
  new_name <- strsplit(out.put.name, split = ".", fixed = TRUE)
  new_name <- lapply(new_name, function(x){y <- x[1:(length(x)-1)]; paste0(y, collapse = ".")})
  new_name <- new_name %>% unlist()
  new_name <- paste0(new_name, ".txt")
  
  return(new_name)
  
}

### For debugging inside Rstudio

#Input <- read.delim("/users/rg/ramador/Scripts/tmp_files/Venn.R.out.txt", h=TRUE, na.strings = "")
#Input <- read.delim("/users/rg/ramador/Scripts/tmp_files/Venn.4.fields.txt", h=TRUE, na.strings = "")

Input <- Input[,1:2]
### This script can only do 5 comparisons 

if( ncol(Input) > 1 && ncol(Input) <= 5 ){
  
  cat("The number of comparisons is:", ncol(Input), "\n" )
  
  
} else{
  
  stop("The number of comparisons is ", ncol(Input), " and this script can only do between 2 and 5 comparisons", "\n")
  
}

############### Draw the Venn Diagram: 


if(ncol(Input) == 5){
  
  cat("Not available yet")
  
} else if (ncol(Input) == 4){
  
  cat("Drawing the Venn Diagram with", ncol(Input), "comparisons", "\n")
  
  venn.diagram(list( "1"=Input[,1][complete.cases(Input[,1])], "2"=Input[,2][complete.cases(Input[,2])],
                     "3"=Input[,3][complete.cases(Input[,3])], "4"=Input[,4][complete.cases(Input[,4])]),
               filename = opt$output,
               col="transparent", fill=c("darkorchid1", "green", "yellow", "cornflowerblue"), alpha=0.4,
               cex=1.3, cat.cex=0.9, main = opt$title )
  
  ### Print the Intersections: 
  
  Intersection <- data.frame(Four_intersections=Reduce(intersect, 
                                                        list(Input[,1][complete.cases(Input[,1])], 
                                                                        Input[,2][complete.cases(Input[,2])], 
                                                                        Input[,3][complete.cases(Input[,3])],
                                                             Input[,4][complete.cases(Input[,4])] ) ) )
  
  new_name <- f.Print.the.txt.output(opt$output)
  
  write.table(Intersection, file = new_name, sep = "/t", col.names = TRUE, quote = FALSE, row.names = FALSE)
  
} else if (ncol(Input) == 3){
  
  cat("Drawing the Venn Diagram with", ncol(Input), "comparisons", "\n")
  
  venn.diagram(list("1"= Input[,1][complete.cases(Input[,1])],
                    "2"= Input[,2][complete.cases(Input[,2])], 
                    "3"= Input[,3][complete.cases(Input[,3])] ),
               filename = opt$output ,
               cex=1.3, col="transparent", fill=c("darkorchid1", "green", "yellow"), alpha=0.4,
               main = opt$title  )
  
  ### Print the Intersections: 
  
  Intersection <- data.frame(Three_intersections=Reduce(intersect, list(Input[,1][complete.cases(Input[,1])], 
                                                                        Input[,2][complete.cases(Input[,2])], 
       Input[,3][complete.cases(Input[,3])]) ) )
  
  new_name <- f.Print.the.txt.output(opt$output)
  
  write.table(Intersection, file = new_name, sep = "/t", col.names = TRUE, quote = FALSE, row.names = FALSE)

  
} else if (ncol(Input) == 2){
  
  cat("Drawing the Venn Diagram with", ncol(Input), "comparisons", "\n")
  
  venn.diagram(list("1"=Input[,1][complete.cases(Input[,1])] , "2"=Input[,2][complete.cases(Input[,2])]),
               filename = opt$output , col="transparent",
               fill=c("darkorchid1", "green"), alpha=0.4, cex=1.3, cat.cex= 0.9,
               main = opt$title, cat.pos= c(0,0), cat.dist = rep(0.025, 2), scaled= FALSE )
  
  ### Print the Intersections: 
  
  Intersection <- data.frame(Intersection=intersect(Input[,1], Input[,2]))
  
  new_name <- f.Print.the.txt.output(opt$output)
  
  write.table(Intersection, file = new_name, col.names = TRUE, row.names = FALSE,
              quote = FALSE, sep = "\t")
  
}






# 
# Final <- rbind(Intersection, Non_intersection)

### Put the name of the subsets: 

# venn.diagram(list("1"=Input[,1][complete.cases(Input[,1])] , "2"=Input[,2][complete.cases(Input[,2])]),
#              filename = opt$output , col="transparent",
#              fill=c("darkorchid1", "green"), alpha=0.4, cex=1.3, cat.cex= 0.9,
#              main = opt$title, cat.pos= c(0,0), cat.dist = rep(0.025, 2), scaled= FALSE,
#              category.names = c( opt$subset_titles[1:2] ))



