#!/usr/bin/env Rscript

############################### GO enrichment analysis

##### Libraries:
suppressPackageStartupMessages(library(optparse))
suppressPackageStartupMessages(library(dplyr))
suppressPackageStartupMessages(library(GO.db))
suppressPackageStartupMessages(library(GOstats))
suppressPackageStartupMessages(library(DBI))
options(stringsAsFactors = FALSE)

##### Option list using Python's style: 

option_list <- list(
  
  make_option(c("-u", "--universe"), help = "a list of gene identifiers, WITH header"),
  make_option(c("-G", "--genes"), default = "stdin",
              help = "a list of gene identifiers for the foreground, NO header [default=%default]"),
  make_option(c("-O", "--ontology"), help = "choose the Gene Ontology <(BP,MF,CC)> [default=%default]", 
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
  G <- read.delim(file("stdin"), header = FALSE, col.names = "hs") 
} else{
  G <- read.delim(opt$genes, header = FALSE, col.names = "hs")
}

######### Debuggin purposes: 
# U <- read.delim("/nfs/users2/rg/ramador/D_me/Data/Genes/GeneUniverse.16392.txt", col.names = "hs")
# G <- read.delim("/nfs/users2/rg/ramador/D_me/RNA-seq/ERC_data/K_means/Results/35.PCG.overlapping.genic.lncRNAs.txt", 
#                 header = FALSE, col.names = "hs")
######### Debuggin purposes

# Take the Flybase IDs for all orthologous genes which will be my universe
if(opt$species == "Dme"){
  universe <- unlist(mget(U$hs, org.Dm.egENSEMBL2EG, ifnotfound = NA))
}

if(opt$species == "Human"){
  universe <- unlist(mget(U$hs, org.Hs.egENSEMBL2EG, ifnotfound = NA))
}

sprintf("%s background genes; with %s with a corresponding ID", nrow(U), 
        length(unique(universe)))

 
createParams <- function(x, species= "Dme"){
  
  if(species == "Dme"){
    geneset <- unlist(mget(x, org.Dm.egENSEMBL2EG, ifnotfound = NA))
  }
  sprintf("%s foreground genes; %s with a corresponding entrez id", length(x),
          length(unique(geneset)))
  pv <- 1-(1-0.05)**length(x)
  print(pv)
  params <- new("GOHyperGParams",
                geneIds= geneset,
                universeGeneIds=universe,
                annotation=ann,
                ontology= opt$ontology,
                pvalueCutoff= pv,
                conditional= TRUE,
                testDirection="over")
  
  return(params)
}

res <- hyperGTest(createParams(unique(G$hs), opt$species))

cat("Finished Hypergeometric test", "\n")

# Reformat the output table: 
df <- summary(res)
df$Pvalue <- round(df$Pvalue, digits = 2)
df$OddsRatio <- round(df$OddsRatio, 2)
df$ExpCount <- round(df$ExpCount, 2)

htmlReport(res)



