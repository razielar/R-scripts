

ggplot(results, aes(x=time_point, y=n, fill=DGE))+
    geom_bar(stat= "identity", position = position_dodge(),
             alpha=0.85)+
    facet_wrap(~gene_type, scales="free")+xlab("")+ylab("Number of genes")+
    geom_text(aes(y=n, label=n), position = position_dodge(0.9),
              vjust=-0.5)+ ggtitle("Genome Research Results")+
    theme(legend.position = "bottom", strip.text= element_text(size=12),
          plot.title = element_text(hjust = 0.5, face = "bold"))+
    scale_fill_manual(values= c(dge_up, dge_down))+labs(fill= "")




