##PTdataArranged <- arrange(PTdata, DateRep) ## it may be better to arrange the data in ascending order

##Cases <- PTdataArranged[1,5]
##total_Cases <- tibble()
##total_Cases <- bind_rows(total_Cases, Cases)
##for (i in 2:length(PTdataArranged$Cases)){
        
  ##      Cases <- (Cases + PTdataArranged[i, 5])
  ##    total_Cases <- bind_rows(total_Cases, Cases)
        
##}
##PTdataArranged <- bind_cols(PTdataArranged, "Total Cases" = total_Cases$Cases)

Percentage <- data.frame("Total Cases" = NA)
Percentage_Cases <- as_tibble()
Percentage_Cases <- bind_rows(Percentage_Cases, Percentage)
for (i in 2:length(PTdataArranged$Cases)){
        
        Percentage <- ((PTdataArranged[i, 10]-PTdataArranged[i-1, 10])*100/PTdataArranged[i-1, 10])
        Percentage_Cases <- bind_rows(Percentage_Cases, Percentage)
        
}

PTdataArranged <- bind_cols(PTdataArranged, "Percentage Cases" = Percentage_Cases$`Total Cases`)

gPercentage <- ggplot(PTdataArranged, aes(DateRep, `Percentage Cases`))
percentageNewCasesPT <- gPercentage + stat_smooth(span = 3, col = "red", fullrange = TRUE) + geom_point() + labs(title = "% New Cases in Portugal") + theme(plot.title = element_text(hjust = 0.5))
percentageNewCasesPT

png(filename = "percentageNewCasesPT.png")
percentageNewCasesPT
dev.off()