library(viridis)
library(ggpmisc)
PTcases <- tibble(dateRep = PTdataArranged$dateRep, cases = PTdataArranged$cases, ID = "Real")

PTcasesSim <- PTcases$cases[length(PTcases$cases)]
lastDateCases <- as.Date(PTcases$dateRep[length(PTcases$dateRep)])
simDateCases <- seq.Date(lastDateCases+1, lastDateCases+92, by = "day")


meanPercentage <- mean(tail(PTdataArranged$`Percentage cases`,20))

## For each 20 days the % of new cases decreases for VIFactorPErcentage
## VIFactorPErcentage is calculated by subtrating the last day % to the mean of the last 20 days.

## This doesnt take the group immunity and government decisions into account. The real curve may be
## different and with a max bad defined.

VIFactorPercentage <- meanPercentage-PTdataArranged$`Percentage cases`[length(PTdataArranged$`Percentage cases`)]

VIFactor <- seq(VIFactorPercentage,VIFactorPercentage*20, by = .5)


for (i in 1:92) {
        
        PTcasesSim[i+1] <- PTcasesSim[i] + PTcasesSim[i] * (increasePercentage-VIFactor[i])/100
        
}

simCases <- tibble(dateRep = simDateCases, cases = PTcasesSim[2:93], ID = rep("Simulated", 92))


PTcases <- bind_rows(PTcases, simCases)
PTcases$dateRep <- as.POSIXct(PTcases$dateRep)

gSimCasesPT <- ggplot(PTcases, aes(dateRep, cases))
PTgSimCases <- gSimCasesPT + geom_point(aes(color = ID)) + stat_peaks(col = "red", ignore_threshold = .9) + stat_peaks(geom="text", ignore_threshold = 0.80, x.label.fmt = "%Y-%m-%d", hjust=-0.1) + labs(y = "Cases") + labs(title = "Portugal new Cases Simulation") + theme(plot.title = element_text(hjust = 0.5)) + scale_color_viridis(discrete = TRUE, option = "E", end  = 0.9, begin = 0.4)

png(filename = "~/R/Covid_19/Covid_19/graphs/PTgSimCases.png")
PTgSimCases
dev.off()

#source("PT_NewCases_SimCurve.R", echo = TRUE)
