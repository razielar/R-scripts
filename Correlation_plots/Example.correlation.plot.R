### Example of Correlation plot: 
### January 20th 2020

library(tidyverse)
library(magrittr)
library(grid)
library(gridExtra)
options(stringsAsFactors = F)
setwd('/users/rg/ramador/D_me/RNA-seq/Covariable_analysis/dm6_r6.29/')

### input data:
datExpr <- readRDS("Results//india.GE.TPM.replicates.L3.cutoff.1TPM.RDS")

### 1) --- L3 replicates analysis: 

pearson <- cor(datExpr[,1], datExpr[,2], method = "pearson") %>% as.numeric
spearman <- cor(datExpr[,1], datExpr[,2], method = "spearman")%>% as.numeric

pearson <- grobTree(textGrob(
    paste("Pearson Correlation : ", round(pearson, 4) ),
    x = 0.63, y = 0.97, hjust = 0, gp = gpar(col = "black", fontsize = 9, fontface = "bold")))
spearman <- grobTree(textGrob(
    paste("Spearman Correlation : ", round(spearman, 4) ),
    x = 0.63, y = 0.93, hjust = 0, gp = gpar(col = "black", fontsize = 9, fontface = "bold")))

## pdf(file = "Plots//Correlation_plots/correlation.L3.pdf", paper = "a4r",
##     width = 0, height=0)

p5 <- ggplot(data = log10(datExpr+0.01),
       aes(x=`L3-R1-India`, y=`L3-R2-India`, color=`L3-R1-India`))+
    geom_point(size=1)+
    scale_color_gradient2(midpoint=1.5, low="gold", mid="forestgreen",high="darkgreen")+
    xlab("log10(TPM+0.01)_L3-R1-India")+ylab("log10(TPM+0.01)_L3-R2-India")+
    geom_smooth(method = "lm", color="black")+ggtitle("L3-replicates")+
    annotation_custom(pearson)+ annotation_custom(spearman)+
    theme(plot.title = element_text(hjust = 0.5,face = "bold"),
          axis.text.y = element_text(face = "bold"), axis.text.x = element_text(face = "bold"),
          text = element_text(size=9), axis.title.x = element_text(face = "bold"),
          axis.title.y = element_text(face="bold"))+
    labs(colour = "log10(TPM+0.01)")


### 1) --- Early replicates analysis: 

### Control: 

pearson <- cor(datExpr[,3], datExpr[,4], method = "pearson") %>% as.numeric
spearman <- cor(datExpr[,3], datExpr[,4], method = "spearman")%>% as.numeric
pearson <- grobTree(textGrob(
    paste("Pearson: ", round(pearson, 4) ),
    x = 0.05, y = 0.97, hjust = 0, gp = gpar(col = "black", fontsize = 7, fontface = "bold")))
spearman <- grobTree(textGrob(
    paste("Spearman: ", round(spearman, 4) ),
    x = 0.05, y = 0.93, hjust = 0, gp = gpar(col = "black", fontsize = 7, fontface = "bold")))


## pdf(file = "Plots//Correlation_plots/correlation.early.pdf", paper = "a4r",
##     width = 0, height=0)

p_early_control <- ggplot(data = log10(datExpr+0.01),
       aes(x=`Control-0h-R1-India`, y=`Control-0h-R2-India`, color=`Control-0h-R1-India`))+
    geom_point(size=0.3)+
    scale_color_gradient2(midpoint=1.5, low="gold", mid="forestgreen",high="darkgreen")+
    xlab("Control-0h-R1-India")+ylab("Control-0h-R2-India")+
    geom_smooth(method = "lm", color="black", size=0.6)+ggtitle("Early-replicates")+
    annotation_custom(pearson)+ annotation_custom(spearman)+
    theme(plot.title = element_text(hjust = 0.5,face = "bold"),
          axis.text.y = element_text(face = "bold"), axis.text.x = element_text(face = "bold"),
          text = element_text(size=8))+labs(colour = "")+
    guides(color = guide_colourbar(barwidth = 0.5, barheight = 5))

## dev.off()

### Regeneration: 

pearson <- cor(datExpr[,5], datExpr[,6], method = "pearson") %>% as.numeric
spearman <- cor(datExpr[,5], datExpr[,6], method = "spearman")%>% as.numeric
pearson <- grobTree(textGrob(
    paste("Pearson: ", round(pearson, 4) ),
    x = 0.05, y = 0.97, hjust = 0, gp = gpar(col = "black", fontsize = 7, fontface = "bold")))
spearman <- grobTree(textGrob(
    paste("Spearman: ", round(spearman, 4) ),
    x = 0.05, y = 0.93, hjust = 0, gp = gpar(col = "black", fontsize = 7, fontface = "bold")))

p_early_reg <- ggplot(data = log10(datExpr+0.01),
                      aes(x=`Regeneration-0h-R1-India`, y=`Regeneration-0h-R2-India`,
                          color=`Regeneration-0h-R1-India`))+
    geom_point(size=0.3)+
    scale_color_gradient2(midpoint=1.5, low="gold", mid="forestgreen",high="darkgreen")+
    xlab("Regeneration-0h-R1-India")+
    ylab("Regeneration-0h-R2-India")+
    geom_smooth(method = "lm", color="black", size=0.6)+
    annotation_custom(pearson)+ annotation_custom(spearman)+
    theme(axis.text.y = element_text(face = "bold"), axis.text.x = element_text(face = "bold"),
          text = element_text(size=8))+labs(colour = "")+
    guides(color = guide_colourbar(barwidth = 0.5, barheight = 5))


### 2) --- Mid replicates analysis: 
### Control: 

pearson <- cor(datExpr[,7], datExpr[,8], method = "pearson") %>% as.numeric
spearman <- cor(datExpr[,7], datExpr[,8], method = "spearman")%>% as.numeric
pearson <- grobTree(textGrob(
    paste("Pearson: ", round(pearson, 4) ),
    x = 0.05, y = 0.97, hjust = 0, gp = gpar(col = "black", fontsize = 7, fontface = "bold")))
spearman <- grobTree(textGrob(
    paste("Spearman: ", round(spearman, 4) ),
    x = 0.05, y = 0.93, hjust = 0, gp = gpar(col = "black", fontsize = 7, fontface = "bold")))

p_mid_control <- ggplot(data = log10(datExpr+0.01),
                        aes(x=`Control-15h-R1-India`, y=`Control-15h-R2-India`,
                            color=`Control-15h-R1-India`))+ geom_point(size=0.3)+
    scale_color_gradient2(midpoint=1.5, low="gold", mid="forestgreen",high="darkgreen")+
    xlab("Control-15h-R1-India")+
    ylab("Control-15h-R2-India")+
    geom_smooth(method = "lm", color="black",size=0.6)+ggtitle("Mid-replicates")+
    annotation_custom(pearson)+ annotation_custom(spearman)+
    theme(plot.title = element_text(hjust = 0.5,face = "bold"),
          axis.text.y = element_text(face = "bold"), axis.text.x = element_text(face = "bold"),
          text = element_text(size=8))+labs(colour = "")+
    guides(color = guide_colourbar(barwidth = 0.5, barheight = 5))
    


### Regeneration: 
pearson <- cor(datExpr[,9], datExpr[,10], method = "pearson") %>% as.numeric
spearman <- cor(datExpr[,9], datExpr[,10], method = "spearman")%>% as.numeric
pearson <- grobTree(textGrob(
    paste("Pearson: ", round(pearson, 4) ),
    x = 0.05, y = 0.97, hjust = 0, gp = gpar(col = "black", fontsize = 7, fontface = "bold")))
spearman <- grobTree(textGrob(
    paste("Spearman: ", round(spearman, 4) ),
    x = 0.05, y = 0.93, hjust = 0, gp = gpar(col = "black", fontsize = 7, fontface = "bold")))

p_mid_reg <- ggplot(data = log10(datExpr+0.01),
                    aes(x=`Regeneration-15h-R1-India`, y=`Regeneration-15h-R2-India`,
                        color=`Regeneration-15h-R1-India`))+
    geom_point(size=0.3)+
    scale_color_gradient2(midpoint=1.5, low="gold", mid="forestgreen",high="darkgreen")+
    xlab("Regeneration-15h-R1-India")+
    ylab("Regeneration-15h-R2-India")+
    geom_smooth(method = "lm", color="black", size=0.6)+
    annotation_custom(pearson)+ annotation_custom(spearman)+
    theme(axis.text.y = element_text(face = "bold"), axis.text.x = element_text(face = "bold"),
          text = element_text(size=8))+labs(colour = "")+
    guides(color = guide_colourbar(barwidth = 0.5, barheight = 5))


### 3) --- Late replicates analysis: 

### Control: 
pearson <- cor(datExpr[,11], datExpr[,12], method = "pearson") %>% as.numeric
spearman <- cor(datExpr[,11], datExpr[,12], method = "spearman")%>% as.numeric
pearson <- grobTree(textGrob(
    paste("Pearson: ", round(pearson, 4) ),
    x = 0.05, y = 0.97, hjust = 0, gp = gpar(col = "black", fontsize = 7, fontface = "bold")))
spearman <- grobTree(textGrob(
    paste("Spearman: ", round(spearman, 4) ),
    x = 0.05, y = 0.93, hjust = 0, gp = gpar(col = "black", fontsize = 7, fontface = "bold")))

p_late_control <- ggplot(data = log10(datExpr+0.01),
                         aes(x=`Control-25h-R1-India`, y=`Control-25h-R2-India`,
                             color=`Control-25h-R1-India`))+geom_point(size=0.3)+
    scale_color_gradient2(midpoint=1.5, low="gold", mid="forestgreen",high="darkgreen")+
    xlab("Control-25h-R1-India")+
    ylab("Control-25h-R2-India")+
    geom_smooth(method = "lm", color="black", size=0.6)+ggtitle("Late-replicates")+
    annotation_custom(pearson)+ annotation_custom(spearman)+
    theme(plot.title = element_text(hjust = 0.5,face = "bold"),
          axis.text.y = element_text(face = "bold"), axis.text.x = element_text(face = "bold"),
          text = element_text(size=8))+labs(colour = "")+
    guides(color = guide_colourbar(barwidth = 0.5, barheight = 5))


### Regeneration: 
pearson <- cor(datExpr[,13], datExpr[,14], method = "pearson") %>% as.numeric
spearman <- cor(datExpr[,13], datExpr[,14], method = "spearman")%>% as.numeric
pearson <- grobTree(textGrob(
    paste("Pearson: ", round(pearson, 4) ),
    x = 0.05, y = 0.97, hjust = 0, gp = gpar(col = "black", fontsize = 7, fontface = "bold")))
spearman <- grobTree(textGrob(
    paste("Spearman: ", round(spearman, 4) ),
    x = 0.05, y = 0.93, hjust = 0, gp = gpar(col = "black", fontsize = 7, fontface = "bold")))

p_late_reg <- ggplot(data = log10(datExpr+0.01),
       aes(x=`Regeneration-25h-R1-India`, y=`Regeneration-25h-R2-India`,
           color=`Regeneration-25h-R1-India`))+
    geom_point(size=0.3)+
    scale_color_gradient2(midpoint=1.5, low="gold", mid="forestgreen",high="darkgreen")+
    xlab("Regeneration-25h-R1-India")+
    ylab("Regeneration-25h-R2-India")+
    geom_smooth(method = "lm", color="black", size=0.6)+
    annotation_custom(pearson)+ annotation_custom(spearman)+
    theme(axis.text.y = element_text(face = "bold"), axis.text.x = element_text(face = "bold"),
          text = element_text(size=8))+labs(colour = "")+
    guides(color = guide_colourbar(barwidth = 0.5, barheight = 5))

## pdf(file ="Plots//Correlation_plots/correlation.all.time.points.pdf" , paper = "a4r",
##     width = 0, height = 0)

## grid.arrange(p_early_control,p_mid_control,p_late_control, p_early_reg,
##              p_mid_reg, p_late_reg, ncol=3)

## dev.off()



