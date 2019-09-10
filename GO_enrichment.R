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
  
  make_option(c("-u", "--universe"), help = "a list of gene identifiers, WITH header"),
  make_option(c("-G", "--genes"), default = "stdin",
              help = "a list of gene identifiers for the foreground, NO header [default=%default]"),
  make_option(c("-O", "--ontology"), help = "choose the Gene Ontology < (BP,MF,CC) > [default=%default]", 
              default= "BP"),
  make_option(c("-s", "--species"), help = "choose the species <(Dme, Human)> [default=%default]",
              default = "Dme"),
  make_option(c("-o", "--output"), help = "name of the output [default=%default]", 
              default = "GO.enrich.txt")
)

opt_parser <- OptionParser(option_list = option_list)
opt <- parse_args(opt_parser)

if(opt$species == "Dme"){
  ann<- "org.Dm.eg.db"; suppressPackageStartupMessages(library(org.Dm.eg.db))
}
if(opt$species == "Human"){
  ann<- "org.Hs.eg.db"; suppressPackageStartupMessages(library(org.Hs.eg.db))
}

############################
# BEGIN
############################

#Information regarding Gene_Universe: https://www.researchgate.net/post/How_do_you_perform_a_gene_ontology_with_topGO_in_R_with_a_predefined_gene_list
U <- read.delim(opt$universe, col.names = "hs")
U$hs <- unique(U$hs)

if(opt$genes == "stdin"){
  G <- read.delim(file("stdin"), header = FALSE) 
} else{
  G <- read.delim(opt$genes, header = FALSE)
}

######### Debuggin purposes: 
# U <- read.delim("/nfs/users2/rg/ramador/D_me/Data/Genes/GeneUniverse.16392.txt", col.names = "hs")
# G <- read.delim("/nfs/users2/rg/ramador/D_me/RNA-seq/ERC_data/K_means/Results/35.PCG.overlapping.genic.lncRNAs.txt", header = FALSE)
######### Debuggin purposes

# Take the Flybase IDs for all orthologous genes which will be my universe
if(opt$species == "Dme"){
  universe <- unlist(mget(U$hs, org.Dm.egENSEMBL2EG, ifnotfound = NA))
}

sprintf("%s background genes; with %s with a corresponding ID", nrow(U), 
        length(unique(universe)))



# universe <- unlist(mget(U$hs, org.Dm.egENSEMBL2EG, ifnotfound = NA))
# nrow(U)
# length(unique(universe))




