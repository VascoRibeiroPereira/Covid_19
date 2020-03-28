## Debbuging the code, not working yet

UKdataArranged <- arrange(UKdata, DateRep) ## it may be better to arrange the data in ascending order

CasesUK <- UKdataArranged[1,5]
total_CasesUK <- tibble()
total_CasesUK <- bind_rows(total_CasesUK, CasesUK)
for (i in 2:length(UKdataArranged$Cases)){
        
        CasesUK <- (CasesUK + UKdataArranged[i, 5])
        total_CasesUK <- bind_rows(total_CasesUK, CasesUK)
        
}
UKdataArranged <- bind_cols(UKdataArranged, "Total Cases" = total_CasesUK$CasesUK)

PercentageUK <- data.frame("Total Cases" = NA)
Percentage_CasesUK <- as_tibble()
Percentage_CasesUK <- bind_rows(Percentage_CasesUK, PercentageUK)
for (i in 2:length(UKdataArranged$Cases)){
        
        PercentageUK <- ((UKdataArranged[i, 10]-UKdataArranged[i-1, 10])*100/UKdataArranged[i-1, 10])
        Percentage_CasesUK <- bind_rows(Percentage_CasesUK, PercentageUK)
        
}

UKdataArranged <- bind_cols(UKdataArranged, "Percentage Cases" = Percentage_CasesUK$`Total Cases`)

gPercentageUK <- ggplot(UKdataArranged, aes(DateRep, `Percentage Cases`))
percentageNewCasesUK <- gPercentageUK + stat_smooth(span = 3, col = "red", fullrange = TRUE) + geom_point() + labs(title = "% New Cases in UK") + theme(plot.title = element_text(hjust = 0.5))
percentageNewCasesUK

png(filename = "~/R/Covid_19/Covid_19/graphs/percentageNewCasesUK.png")
percentageNewCasesUK
dev.off()