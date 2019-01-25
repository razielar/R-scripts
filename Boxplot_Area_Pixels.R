#!/usr/bin/env Rscript

######## Boxplot of Relative Wing Area in Pixels 

##### Libraries: 

suppressPackageStartupMessages(library(optparse))
suppressPackageStartupMessages(library(dplyr))
suppressPackageStartupMessages(library(reshape2))
suppressPackageStartupMessages(library(ggplot2))


##### Option list using Python's style: 

option_list <- list(
  
  make_option(c("-i", "--input"), type = "character", default = "stdin",
              help = "Input file.csv [default=%default]", metavar = "character"),
  make_option("--header", default = TRUE, 
              help = "The input file has header [default=%default]"),
  make_option(c("-o", "--output"), type = "character", default = "Wing.Regeneration.Analysis.pdf",
              help="Output file name. Must have a pdf extension (e.g. 'What.ever.pdf') [default= %default]", 
              metavar="character"),
  make_option(c("-t", "--title"), type="character", default = "Wing Regeneration Analysis",
              help = "Title of Pie plot [default=%default]"),
  make_option(c("-x", "--x_axis"), type = "character", default = " ",
              help = "Name of the x-axis [default=%default]"),
  make_option(c("-y", "--y_axis"), type = "character", default = "Relative Wing Area in Pixels",
              help = "Name of the y-axis [default=%default]"),
  make_option("--x_axis_rotation", default = FALSE,
              help = "X axis rotation [default=%default]"),
  make_option("--element_text_size", default = 12,
              help = "Font size [default=%default]")
  
)

opt_parser <-  OptionParser(option_list=option_list)
opt <- parse_args(opt_parser)

############################## 1) Read the CSV Input file:  

if (opt$input == "stdin") {

  Input <- read.csv(file("stdin"), h=opt$header, na.strings = "")

} else {

  Input <- read.delim(opt$input, h=opt$header)

}

##### Debugging inside RStudio: 

# Boxplot_data <- read.csv("/users/rg/ramador/Analysis/Carlos.boxplots/Carlos.boxplot_third.analysis.csv", 
#                          na.strings = "")

############################## 2) Apply the function to Modify the Dataframe: 

fModify.df <- function(Input_matrix){
  
  n_columns <- ncol(Input_matrix)
  
  if((n_columns %%3) == 0){
    
    j <- n_columns/3
    
    Final_DF <- c()
    
    for(i in 1:j){
      
      ### Step1: 
      jj <- i+1*(i-1)+(i-1) #Generates odd numbers
      
      tmp <- Input_matrix[-1,jj] #remove the first string row
      step_1 <- data.frame(Input=as.numeric(tmp[complete.cases(tmp)])) 
      step_1 <- cbind(step_1, data.frame(Binary=rep("Wild-type", nrow(step_1))))
      
      ### Step2:
      l <- 2*i+(i-1) #Generates even numbers
      
      tmp_2 <- Input_matrix[-1, l] #remove the first string row
      step_2 <- data.frame(Input=as.numeric(tmp_2[complete.cases(tmp_2)]))
      step_2 <- cbind(step_2, data.frame(Binary=rep("Mild", nrow(step_2))))
      
      ### Step3: 
      m <- 3*(i)
      
      tmp_3 <- Input_matrix[-1, m] #remove the first string row
      step_3 <- data.frame(Input=as.numeric(tmp_3[complete.cases(tmp_3)]))
      step_3 <- cbind(step_3, data.frame(Binary=rep("Severe", nrow(step_3))))
      
      final_df <- rbind(step_1, step_2, step_3)
      final_df <- cbind(final_df,  data.frame(Class=rep(colnames(Input_matrix)[jj], nrow(final_df) ) ) )
      Final_DF <- rbind(Final_DF, final_df) 
    }
    
  } else{ stop("The dataframe is not odd")}
  
  return(Final_DF)
  
}

Modified_matrix <- fModify.df(Input_matrix = Input)

colnames(Modified_matrix)[2] <- "Data_type:"

############################## 3) Plot: 

p <- ggplot(data = Modified_matrix , aes(x=Class, y=Input))+geom_boxplot(lwd=0.8, outlier.shape = NA)+
  xlab(opt$x_axis)+ylab(opt$y_axis)+ggtitle(opt$title)+theme_bw()+
  theme(plot.title = element_text(hjust = 0.5,face = "bold"), axis.text.y = element_text(face = "bold"),
        text = element_text(size=opt$element_text_size),
        axis.text.x = element_text(face = "bold"),
        axis.title.y = element_text(face="bold"),legend.position="bottom",
        legend.title = element_text(face = "bold"))+
  geom_jitter(aes(color=`Data_type:`), position = position_jitter(0.1), size=0.5)

############################## 4) Save the results: 

pdf(file = opt$output, width = 0, height = 0, paper = "a4r")

p

dev.off()






