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
              help = "the input GTF file has header [default=%default]"),
  make_option(c("-t", "--type"), default = TRUE ,
              help = "Either compute the Shannon's entropy or Isoform ratio. [default= %default]")
  
)

opt_parser <-  OptionParser(option_list=option_list)
opt <- parse_args(opt_parser)

################################# 1) Read input files: 

options(stringsAsFactors = FALSE)

#For debugging: 

# GTF_file <- read.delim("/Users/raziel/Downloads/FlyIDGene.FlyIDTranscript.GeneName.TranscriptName.GeneType.TranscriptType.txt",
#                        header = FALSE)
# GTF_file <- read.delim("/users/rg/ramador/D_me/Data/GenomeAnnotation/FlyIDGene.FlyIDTranscript.GeneName.TranscriptName.GeneType.TranscriptType.txt",
#                        header = FALSE)
# Isoform_expr <- read.delim("/Users/raziel/Downloads/regeneration.dmel.transcript.TPM.idr_NA.tsv")
# Isoform_expr <- read.delim("/nfs/no_backup/rg/cklein/dmel/regeneration/grape.pipeline/matrices/regeneration.dmel.transcript.TPM.idr_NA.tsv")
# Isoform_expr <- Isoform_expr[,18:21]

GTF_file <- read.delim(opt$annotation, header = opt$GTF_header)

Isoform_expr <- read.delim(opt$input_matrix, header = TRUE)
Isoform_expr[is.na(Isoform_expr)] <- 0

################################# 2) Functions: 

### 2.1) Isoform ratio: 

fCalculate.isoform.ratio.per.gene <- function(Input.Matrix){
  
  new_name <- strsplit(rownames(Input.Matrix), split = "-", fixed = TRUE)
  new_name <- lapply(new_name, function(x){ y <-x[1:(length(x)-1)]; paste0(y,collapse = "-")}) 
  new_name <- new_name %>% unlist()
  
  tmp.matrix <- Input.Matrix %>% mutate(Transcript=new_name)
  
  test <- function(x){
    
    glob <- x %>% select(-Transcript)
    sumvals <- colSums(glob)
    result <- sapply(1:length(sumvals), function(x){ round(glob[,x]/sumvals[x], digits = 4)}) %>% 
      do.call(rbind, .) %>% t
    
    return(as.data.frame(result))
    
    }
  
  tmp.isoform.ratio <- tmp.matrix %>% group_by(Transcript) %>% do(test(.)) 
  tmp.isoform.ratio <- tmp.isoform.ratio[,-1] %>% as.data.frame() 
  rownames(tmp.isoform.ratio) <- rownames(Input.Matrix)
  tmp.isoform.ratio[is.na(tmp.isoform.ratio)] <- 0

  return(tmp.isoform.ratio) 
  
}

### 2.2) Shannon's splicing: 

f.Calculate_Shannon_splicing <- function(Input.matrix){
  
  new_name <- strsplit(rownames(Input.matrix), split = "-", fixed = TRUE)
  new_name <- lapply(new_name, function(x){ y <-x[1:(length(x)-1)]; paste0(y,collapse = "-")}) 
  new_name <- new_name %>% unlist()
  
  tmp.matrix <- Input.matrix %>% mutate(Transcript=new_name)
  
  Shannon_splicing <- function(x){
    
    #1) Calculate the isoform ratio:
    
    glob <- x %>% select(-Transcript) #dataframe: with the replicates
    sumvals <- colSums(glob) #numeric value: sum of the columns
    result <- sapply(1:length(sumvals), function(x){ round(glob[,x]/sumvals[x], digits = 4)}) %>% 
      do.call(rbind, .) %>% t #sapply: return a vector; dataframe
    
    result[result[,1] == 0,] <- NA
    
    #2) Calculate the Shannon's entropy:
    
    shannon_entropy <- round(-colSums(result*log(result), na.rm = TRUE), digits = 4) #Shannon's formula
    shannon_entropy <- t(as.data.frame(shannon_entropy))
    shannon_entropy <- data.frame(shannon_entropy)
    
  }
  
  tmp.isoform.ratio <- tmp.matrix %>% group_by(Transcript) %>% do(Shannon_splicing(.)) 
  tmp.isoform.ratio <- tmp.isoform.ratio %>% as.data.frame()
  
  tmp.isoform.ratio[tmp.isoform.ratio == 0] <- NA
  
  return(tmp.isoform.ratio)
  
}

################################# 3) Pre-processing 

### Modify GTF file: 

GTF_file <- GTF_file[, 1:4]
colnames(GTF_file) <- c("GeneID", "TranscriptID", "Gene_Name", "Transcript_Name")

# Remove white-specases in GTF_file 

for (i in 1:ncol(GTF_file)) {GTF_file[,i] <- gsub(" ", "", GTF_file[,i])}

GTF_file <- GTF_file[order(GTF_file$Gene_Name),] 
rownames(GTF_file) <- 1:nrow(GTF_file)

### Select Genes with more than 2 isoforms: 

Isoform_frquency <- GTF_file %>% group_by(Gene_Name) %>% summarise(Frequency=n()) %>% 
  arrange(desc(Frequency))

Isoform_frquency <- Isoform_frquency[Isoform_frquency$Frequency >= 2,]
Isoform_frquency <- Isoform_frquency[order(Isoform_frquency$Gene_Name),] 

### New GTF file: 

GTF_file <- GTF_file[which(GTF_file$Gene_Name %in% Isoform_frquency$Gene_Name),]
rownames(GTF_file) <- 1:nrow(GTF_file)

### Modify the Transcript matrix: 

Isoform_expr <- Isoform_expr[ which( rownames(Isoform_expr) %in% GTF_file$TranscriptID  )  ,] 

### Change the rownames of the Transcript matrix from Transcript ID to Transcript Name

### Check the same order: 

Isoform_expr <- Isoform_expr[order(match(rownames(Isoform_expr), GTF_file$TranscriptID)),]

rownames(Isoform_expr) <- GTF_file$Transcript_Name

################################# 4) Apply the functions  

if(opt$type){
  
  Result <- f.Calculate_Shannon_splicing(Isoform_expr)
  colnames(Result)[1] <- "Gene.Name"
  Result <- cbind(data.frame(Gene.ID= unique(GTF_file$GeneID) ) , Result)
  
} else {
  
  Result <- fCalculate.isoform.ratio.per.gene(Isoform_expr)
  Result <- cbind(data.frame(Transcript.Name=rownames(Result), Result))
  Result <- cbind(data.frame(Transcript.ID=GTF_file$TranscriptID) , Result)
  rownames(Result) <- 1:nrow(Result)

}

write.table(Result, file = opt$output, sep = "\t", col.names = TRUE, row.names = FALSE)

