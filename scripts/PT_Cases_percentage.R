Percentage <- data.frame("Total cases" = NA)
Percentage_cases <- as_tibble()
Percentage_cases <- bind_rows(Percentage_cases, Percentage)
for (i in 2:length(PTdataArranged$cases)){
        
        Percentage <- ((PTdataArranged[i, length(PTdataArranged)]-PTdataArranged[i-1, length(PTdataArranged)])*100/PTdataArranged[i-1, length(PTdataArranged)])
        Percentage_cases <- bind_rows(Percentage_cases, Percentage)
        
}

PTdataArranged <- bind_cols(PTdataArranged, "Percentage cases" = Percentage_cases$`Total cases`)

gPercentage <- ggplot(PTdataArranged, aes(dateRep, `Percentage cases`))
percentageNewcasesPT <- gPercentage + stat_smooth(span = 3, col = rgb(0.8,0,0), fullrange = TRUE) + geom_point(col = rgb(0,0.3,0)) + labs(title = "% New cases in Portugal") + theme(plot.title = element_text(hjust = 0.5))


png(filename = "~/R/Covid_19/Covid_19/graphs/percentageNewcasesPT.png")
percentageNewcasesPT
dev.off()