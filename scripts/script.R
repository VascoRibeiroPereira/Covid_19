library(readxl)
library(httr)
library(dplyr)
library(ggplot2)

#create the URL where the dataset is stored with automatic updates every day

url <- paste("https://www.ecdc.europa.eu/sites/default/files/documents/COVID-19-geographic-disbtribution-worldwide-",format(Sys.time(), "%Y-%m-%d"), ".xlsx", sep = "")

#download the dataset from the website to a local temporary file

GET(url, authenticate(":", ":", type="ntlm"), write_disk(tf <- tempfile(fileext = ".xlsx")))

#read the Dataset sheet into “R”

data <- read_excel(tf)

# study data with more than 30 days of observations
numberObs <- table(data$geoId)

## Graphics of the number of deaths by day in the countries with more than 30 days of data

        #subset the data for countries with more than 30 observations and plot
subset <- data[data$geoId %in% names(numberObs[numberObs > 30]),]
subset$geoId<- factor(subset$geoId)
g <- ggplot(subset, aes(dateRep, deaths))
subsetGraphs <- g + geom_line() + facet_wrap(.~geoId, nrow = 8, ncol = 9)

png(filename = "~/R/Covid_19/Covid_19/graphs/subsetGraphs.png")
subsetGraphs
dev.off()

# Comparing China and Portugal deaths per Day

        # Filter the data and add num of Day since first death
PTdata <- filter(data, geoId == "PT")
PTdata <- mutate(PTdata, DayNum = length(PTdata$dateRep):1)

CNdata <- filter(data, geoId == "CN")
CNdata <- mutate(CNdata, DayNum = length(CNdata$dateRep):1)

        # Merging the data frames for comparison
PT_CN_merged <- rbind(PTdata, CNdata)

PT_CN_merged$geoId <- factor(PT_CN_merged$geoId)

        # Ploting the Data
gPT_CN <- ggplot(PT_CN_merged, aes(DayNum, deaths))
PT_CN_merged_Graph <- gPT_CN + geom_smooth(aes(color = geoId)) + geom_vline(xintercept = c(16,32), col = c(rgb(.1, .5, .6),rgb(1,.1,.3))) + coord_cartesian(ylim = c(0, 120)) + labs(x = "Days") + labs(y = "deaths") + labs(title = "Portugal vs China death rate") + theme(plot.title = element_text(hjust = 0.5))

png(filename = "~/R/Covid_19/Covid_19/graphs/PT_CN_merged_Graph.png")
PT_CN_merged_Graph
dev.off()

# study data with more than 30 days of observations
numberObs <- table(data$geoId)

## Graphics of the number of cases by day in the countries with more than 30 days of data

# Plot the data
gcases <- ggplot(subset, aes(dateRep, cases))
subsetGraphscases <- gcases + geom_line() + facet_wrap(.~geoId, nrow = 8, ncol = 9)

png(filename = "~/R/Covid_19/Covid_19/graphs/subsetGraphscases.png")
subsetGraphscases
dev.off()

# Comparing China and Portugal cases per Day

# Ploting the Data
gPT_CN_cases <- ggplot(PT_CN_merged, aes(DayNum, cases))
PT_CN_merged_Graph_cases <- gPT_CN_cases + geom_smooth(aes(color = geoId)) + geom_vline(xintercept = c(16,32), col = c(rgb(.1, .5, .6),rgb(1,.1,.3))) + coord_cartesian(ylim = c(0, 4000)) + labs(x = "Days") + labs(y = "cases") + labs(title = "Portugal vs China new cases rate") + theme(plot.title = element_text(hjust = 0.5))

png(filename = "~/R/Covid_19/Covid_19/graphs/PT_CN_merged_Graph_cases.png")
PT_CN_merged_Graph_cases
dev.off()

## Only Portugal Data with the horizontal line for the limit capacity of the PT hospitals

source("PT_hospitals_capacity.R", echo = TRUE)

gPTData_cases <- ggplot(PTdata, aes(DayNum, cases))
PTData_Graph_cases <- gPTData_cases + geom_smooth() + geom_hline(yintercept = capacity_PT) + coord_cartesian(ylim = c(0, 4000)) + labs(x = "Days") + labs(y = "cases") + labs(title = "Portugal new cases") + theme(plot.title = element_text(hjust = 0.5))

png(filename = "~/R/Covid_19/Covid_19/graphs/PTData_Graph_cases.png")
PTData_Graph_cases
dev.off()

## Portugal total cases

PTdataArranged <- arrange(PTdata, dateRep) ## it may be better to arrange the data in ascending order

cases <- PTdataArranged[1,5]
total_cases <- tibble()
total_cases <- bind_rows(total_cases, cases)
for (i in 2:length(PTdataArranged$cases)){
        
        cases <- (cases + PTdataArranged[i, 5])
        total_cases <- bind_rows(total_cases, cases)
        
}
PTdataArranged <- bind_cols(PTdataArranged, "Total cases" = total_cases$cases)

source("PT_hospitals_capacity.R", echo = TRUE)

gPTData_Totalcases <- ggplot(PTdataArranged, aes(DayNum, `Total cases`))
PTData_Graph_Totalcases <- gPTData_Totalcases + geom_smooth() + geom_hline(yintercept = capacity_PT) + coord_cartesian(ylim = c(0, 4000)) + labs(x = "Days") + labs(y = "Total cases") + labs(title = "Portugal Total cases") + theme(plot.title = element_text(hjust = 0.5))

png(filename = "~/R/Covid_19/Covid_19/graphs/PTData_Graph_Totalcases.png")
PTData_Graph_Totalcases
dev.off()

## SIMULATING DATA

source("PT_cases_percentage.R", echo = TRUE)

increasePercentage <- sum(tail(PTdataArranged$`Percentage cases`,5))/5

simulationNewcasesPT <- data.frame(dateRep = PTdataArranged$dateRep, `Total cases` = PTdataArranged$`Total cases`, ID = rep("Real", length(PTdataArranged$dateRep)))
TotalcasesSim <- simulationNewcasesPT$Total.cases[length(simulationNewcasesPT$Total.cases)]
lastDate <- as.Date(simulationNewcasesPT$dateRep[length(simulationNewcasesPT$dateRep)])
simDate <- seq.Date(lastDate+1, lastDate+5, by = "day")

for (i in 1:5) {
        
        TotalcasesSim[i+1] <- TotalcasesSim[i] + TotalcasesSim[i] * increasePercentage/100
        #simTemp <- bind_cols(simTemp, TotalcasesSim)

}
simTemp <- data.frame(dateRep = simDate, `Total cases` = TotalcasesSim[2:6], ID = rep("Simulated", 5))

simTemp$Total.cases <- as.integer(simTemp$Total.cases)
simTemp$ID <- as.character(simTemp$ID)

simulationNewcasesPT$dateRep <- as.Date(simulationNewcasesPT$dateRep)
simulationNewcasesPT$Total.cases <- as.integer(simulationNewcasesPT$Total.cases)

simulationNewcasesPT <- bind_rows(simulationNewcasesPT, simTemp)
simulationNewcasesPT <- as_tibble(simulationNewcasesPT)

gPTData_Simcases <- ggplot(simulationNewcasesPT, aes(dateRep, Total.cases))
PTData_Graph_Simcases <- gPTData_Simcases + geom_point(aes(color = ID)) + geom_text(size=3, aes(label=ifelse(ID=="Simulated", Total.cases, "")), hjust=1.2, vjust=.5) + labs(y = "Total cases") + labs(title = "Portugal 5-day Simulation") + theme(plot.title = element_text(hjust = 0.5))

png(filename = "~/R/Covid_19/Covid_19/graphs/PTData_Graph_Simcases.png")
PTData_Graph_Simcases
dev.off()


## source("script.R", echo = TRUE) Run this code only
source("ES_CN.R", echo = TRUE)
source("IT_CN.R", echo = TRUE)
source("UK_CN.R", echo = TRUE)
source("ES_PT_IT.R", echo = TRUE)



