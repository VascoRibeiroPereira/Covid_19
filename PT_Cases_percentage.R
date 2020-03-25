Percentage <- data.frame("Total Cases" = NA)
Percentage_Cases <- as_tibble()
Percentage_Cases <- bind_rows(Percentage_Cases, Percentage)
for (i in 2:length(PTdataArranged$Cases)){
        
        Percentage <- ((PTdataArranged[i, length(PTdataArranged)]-PTdataArranged[i-1, length(PTdataArranged)])*100/PTdataArranged[i-1, length(PTdataArranged)])
        Percentage_Cases <- bind_rows(Percentage_Cases, Percentage)
        
}

PTdataArranged <- bind_cols(PTdataArranged, "Percentage Cases" = Percentage_Cases$`Total Cases`)

gPercentage <- ggplot(PTdataArranged, aes(DateRep, `Percentage Cases`))
percentageNewCasesPT <- gPercentage + stat_smooth(span = 3, col = "red", fullrange = TRUE) + geom_point() + labs(title = "% New Cases in Portugal") + theme(plot.title = element_text(hjust = 0.5))
percentageNewCasesPT

png(filename = "percentageNewCasesPT.png")
percentageNewCasesPT
dev.off()