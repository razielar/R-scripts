#!/usr/bin/env Rscript

############################### GO enrichment analysis
##### Libraries:
suppressPackageStartupMessages(library(optparse))
suppressPackageStartupMessages(library(biomaRt))
# suppressPackageStartupMessages(library(dplyr))
suppressPackageStartupMessages(library(plyr))
suppressPackageStartupMessages(library(GO.db))
suppressPackageStartupMessages(library(GOstats))
suppressPackageStartupMessages(library(DBI))
suppressPackageStartupMessages(library(RSQLite))
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
#### 1) Convert Dme from FlyBaseID to entrez
#### 2) Convert Human from Ensembl to entrez 
ensembl <- useMart("ensembl", dataset = "hsapiens_gene_ensembl")
my_chr <- c(1:22, 'M', 'X', 'Y')
my_ensembl_gene <- getBM(attributes = "ensembl_gene_id", filters = 'chromosome_name',
                         values = my_chr, mart = ensembl)

convert_genes <-  my_ensembl_gene[which( my_ensembl_gene$ensembl_gene_id %in% G$gene_id ),]
# G[which(!(G$gene_id %in% convert_genes)),] %>% dim()
convert_genes <- getBM(attributes = c("ensembl_gene_id", "entrezgene_id"), filters = "ensembl_gene_id",
      values = convert_genes, mart = ensembl)

#Information regarding Gene_Universe: https://www.researchgate.net/post/How_do_you_perform_a_gene_ontology_with_topGO_in_R_with_a_predefined_gene_list
U <- read.delim(opt$universe, col.names = "hs")
U$hs <- unique(U$hs)

if(opt$genes == "stdin"){
  G <- read.delim(file("stdin"), header = FALSE, col.names = "hs") 
} else{
  G <- read.delim(opt$genes, header = FALSE, col.names = "hs")
}

######### Debuggin purposes: 
### D_me: 
# U <- read.delim("/nfs/users2/rg/ramador/D_me/Data/Genes/GeneUniverse.16392.txt", col.names = "hs")
# G <- read.delim("/nfs/users2/rg/ramador/D_me/RNA-seq/ERC_data/K_means/Results/35.PCG.overlapping.genic.lncRNAs.txt",
#                 header = FALSE, col.names = "hs")
# U <- read.delim("/Users/raziel/Documents/GeneUniverse.16392.txt", col.names = "hs")
# G <- read.delim("/Users/raziel/Documents/35.PCG.overlapping.genic.lncRNAs.txt",
#                 header = FALSE, col.names = "hs")
### Human:
# G <- read.delim("Documents/Home.office.2019/GO.adipose.omentum.txt")
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
  # print(length(x), length(unique(geneset)))
  sprintf("%s foreground genes; %s with a corresponding entrez id", length(x),
          length(unique(geneset)))
  # pv <- 1-(1-0.05)**length(x)
  # print(pv)
  params <- new("GOHyperGParams",
                geneIds= geneset,
                universeGeneIds=universe,
                annotation=ann,
                ontology= opt$ontology,
                pvalueCutoff= 0.01,
                conditional= TRUE,
                testDirection="over")
  
  return(params)
}

res <- suppressWarnings(hyperGTest(createParams(unique(G$hs), opt$species)))
cat("Finished Hypergeometric test", "\n")
res 

# Reformat the output table: 
df <- summary(res)

# df$Pvalue <- round(df$Pvalue, digits = 2)
df$OddsRatio <- round(df$OddsRatio, 2)
df$ExpCount <- round(df$ExpCount, 2)

df <- df[df$Count >= 3,]
print(df)

# 
# htmlReport(res)

# Get the genes for enriched GO terms

enrichGenes <- lapply(geneIdsByCategory(res, catids=sigCategories(res, pvalueCutoff(res))), 
                      data.frame)

length(enrichGenes)
# enrichGenes[[2]] <- mapIds(eval(parse(text=ann)), keys=enrichGenes[[2]], 
#                            keytype="ENTREZID", column=c("ENSEMBL"))
# colnames(enrichGenes) <- c("GO", "gene_id")
# 
# print(enrichGenes)










