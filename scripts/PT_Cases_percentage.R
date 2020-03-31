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

###############################################################
# How the percentage of new cases detected varies day by day? #
###############################################################


Percentage.Data <- PTdataArranged$`Percentage cases`[3:length(PTdataArranged$`Percentage cases`)]
Dates.Data <- PTdataArranged$dateRep[3:(length(PTdataArranged$dateRep)-1)]

Dates.Data <- Dates.Data+1 ## correction to get real dates - we have a delay of one day 

Wday.Data <- wday(Dates.Data, label = TRUE)

diffPercentage.Data <- diff(Percentage.Data)

TablePercentageDiff <- tibble(Dates = Dates.Data, WeekDay = Wday.Data, PercentageDiff = diffPercentage.Data)

png(filename = "~/R/Covid_19/Covid_19/graphs/PercentageDiffStudy.png")

par(mfrow = c(2,1), mar = c(4,1,2,1), mai = c(.8,1,0,.2))
hist(TablePercentageDiff$PercentageDiff, breaks = 20, xlab = "% Difference", main = "")
rug(TablePercentageDiff$PercentageDiff)
plot(TablePercentageDiff$WeekDay, TablePercentageDiff$PercentageDiff, xlab = "weekday", ylab = "% Difference")

dev.off()
