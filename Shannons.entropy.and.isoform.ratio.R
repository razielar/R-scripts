#!/usr/bin/env Rscript

############# Calculate Shannon's entropy and/or Isoform ratio giving a GTF file and isoform matrix

######### Libraries:

suppressPackageStartupMessages(library(dplyr))
suppressPackageStartupMessages(library(optparse))

######### Option list using Python's style: 

option_list <- list(
  
  make_option(c("-i", "--input_matrix"), type = "character",
              help = "The matrix with transcript expression you want to analyze ", metavar = "character"),
  make_option(c("-a", "--annotation"), type = "character",
              help = "GTF file with 4 columns: GeneID, TranscriptID, Gene_Name and Transcrip_Name"),
  make_option(c("-o", "--output"), type = "character", default = "Shannon.isoform.ratio.Output.txt",
              help="output file name. [default= %default]", metavar="character"),
  make_option("--GTF_header", default = FALSE, 
              help = "the input GTF file has header [default=%default]")
  
)

opt_parser <-  OptionParser(option_list=option_list)
opt <- parse_args(opt_parser)

######### Read input files: 

#For debugging: 

# GTF_file <- read.delim("/users/rg/ramador/D_me/Data/GenomeAnnotation/FlyIDGene.FlyIDTranscript.GeneName.TranscriptName.GeneType.TranscriptType.txt",
#                        header = FALSE)
# Isoform_expr <- read.delim("/nfs/no_backup/rg/cklein/dmel/regeneration/grape.pipeline/matrices/regeneration.dmel.transcript.TPM.idr_NA.tsv")
# Isoform_expr <- Isoform_expr[,18:21]

GTF_file <- read.delim(opt$annotation, header = opt$GTF_header)

Isoform_expr <- read.delim(opt$input_matrix, header = TRUE)
Isoform_expr[is.na(Isoform_expr)] <- 0

##### Modify GTF file: 

GTF_file <- GTF_file[, 1:4]
colnames(GTF_file) <- c("GeneID", "TranscriptID", "Gene_Name", "Transcript_Name")

GTF_file <- GTF_file[order(GTF_file$Gene_Name),] 
rownames(GTF_file) <- 1:nrow(GTF_file)
GTF_file$Gene_Name <- as.character(GTF_file$Gene_Name)

### Select Genes with more than 2 isoforms: 

Isoform_frquency <- GTF_file %>% group_by(Gene_Name) %>% summarise(Frequency=n()) %>% 
  arrange(desc(Frequency))

Isoform_frquency$Gene_Name <- gsub(" ", "", Isoform_frquency$Gene_Name)

Isoform_frquency <- Isoform_frquency[Isoform_frquency$Frequency >= 2,]
Isoform_frquency <- Isoform_frquency[order(Isoform_frquency$Gene_Name),] 




