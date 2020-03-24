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
numberObs <- table(data$GeoId)

## Graphics of the number of Deaths by day in the countries with more than 30 days of data

        #subset the data for countries with more than 30 observations and plot
subset <- data[data$GeoId %in% names(numberObs[numberObs > 30]),]
subset$GeoId<- factor(subset$GeoId)
g <- ggplot(subset, aes(DateRep, Deaths))
subsetGraphs <- g + geom_line() + facet_wrap(.~GeoId, nrow = 8, ncol = 9)

png(filename = "subsetGraphs.png")
subsetGraphs
dev.off()

# Comparing China and Portugal Deaths per Day

        # Filter the data and add num of Day since first death
PTdata <- filter(data, GeoId == "PT")
PTdata <- mutate(PTdata, DayNum = length(PTdata$DateRep):1)

CNdata <- filter(data, GeoId == "CN")
CNdata <- mutate(CNdata, DayNum = length(CNdata$DateRep):1)

        # Merging the data frames for comparison
PT_CN_merged <- rbind(PTdata, CNdata)

PT_CN_merged$GeoId <- factor(PT_CN_merged$GeoId)

        # Ploting the Data
gPT_CN <- ggplot(PT_CN_merged, aes(DayNum, Deaths))
PT_CN_merged_Graph <- gPT_CN + geom_smooth(aes(color = GeoId)) + geom_vline(xintercept = c(16,32), col = c(rgb(.1, .5, .6),rgb(1,.1,.3))) + coord_cartesian(ylim = c(0, 120)) + labs(x = "Days") + labs(y = "Deaths") + labs(title = "Portugal vs China death rate") + theme(plot.title = element_text(hjust = 0.5))

png(filename = "PT_CN_merged_Graph.png")
PT_CN_merged_Graph
dev.off()

# study data with more than 30 days of observations
numberObs <- table(data$GeoId)

## Graphics of the number of Cases by day in the countries with more than 30 days of data

# Plot the data
gCases <- ggplot(subset, aes(DateRep, Cases))
subsetGraphsCases <- gCases + geom_line() + facet_wrap(.~GeoId, nrow = 8, ncol = 9)

png(filename = "subsetGraphsCases.png")
subsetGraphsCases
dev.off()

# Comparing China and Portugal Cases per Day

# Ploting the Data
gPT_CN_Cases <- ggplot(PT_CN_merged, aes(DayNum, Cases))
PT_CN_merged_Graph_Cases <- gPT_CN_Cases + geom_smooth(aes(color = GeoId)) + geom_vline(xintercept = c(16,32), col = c(rgb(.1, .5, .6),rgb(1,.1,.3))) + coord_cartesian(ylim = c(0, 4000)) + labs(x = "Days") + labs(y = "Cases") + labs(title = "Portugal vs China new cases rate") + theme(plot.title = element_text(hjust = 0.5))

png(filename = "PT_CN_merged_Graph_Cases.png")
PT_CN_merged_Graph_Cases
dev.off()

## Only Portugal Data with the horizontal line for the limit capacity of the PT hospitals

source("PT_hospitals_capacity.R", echo = TRUE)

gPTData_Cases <- ggplot(PTdata, aes(DayNum, Cases))
PTData_Graph_Cases <- gPTData_Cases + geom_smooth() + geom_hline(yintercept = capacity_PT) + coord_cartesian(ylim = c(0, 4000)) + labs(x = "Days") + labs(y = "Cases") + labs(title = "Portugal new cases") + theme(plot.title = element_text(hjust = 0.5))

png(filename = "PTData_Graph_Cases.png")
PTData_Graph_Cases
dev.off()

## Portugal total cases

PTdataArranged <- arrange(PTdata, DateRep) ## it may be better to arrange the data in ascending order

Cases <- PTdataArranged[1,5]
total_Cases <- tibble()
total_Cases <- bind_rows(total_Cases, Cases)
for (i in 2:length(PTdataArranged$Cases)){
        
        Cases <- (Cases + PTdataArranged[i, 5])
        total_Cases <- bind_rows(total_Cases, Cases)
        
}
PTdataArranged <- bind_cols(PTdataArranged, "Total Cases" = total_Cases$Cases)

source("PT_hospitals_capacity.R", echo = TRUE)

gPTData_TotalCases <- ggplot(PTdataArranged, aes(DayNum, `Total Cases`))
PTData_Graph_TotalCases <- gPTData_TotalCases + geom_smooth() + geom_hline(yintercept = capacity_PT) + coord_cartesian(ylim = c(0, 4000)) + labs(x = "Days") + labs(y = "Total Cases") + labs(title = "Portugal Total cases") + theme(plot.title = element_text(hjust = 0.5))

png(filename = "PTData_Graph_TotalCases.png")
PTData_Graph_TotalCases
dev.off()

## SIMULATING DATA

source("PT_Cases_percentage.R", echo = TRUE)

increasePercentage <- as.numeric(PTdataArranged[length(PTdataArranged$DateRep),11])/100

simulationNewCasesPT <- data.frame(DateRep = PTdataArranged$DateRep, `Total Cases` = PTdataArranged$`Total Cases`, ID = rep("Real", length(PTdataArranged$DateRep)))
TotalCasesSim <- simulationNewCasesPT$Total.Cases[length(simulationNewCasesPT$Total.Cases)]
lastDate <- as.Date(simulationNewCasesPT$DateRep[length(simulationNewCasesPT$DateRep)])
simDate <- seq.Date(lastDate+1, lastDate+5, by = "day")

for (i in 1:5) {
        
        TotalCasesSim[i+1] <- TotalCasesSim[i] + TotalCasesSim[i] * increasePercentage
        #simTemp <- bind_cols(simTemp, TotalCasesSim)

}
simTemp <- data.frame(DateRep = simDate, `Total Cases` = TotalCasesSim[2:6], ID = rep("Simulated", 5))

simulationNewCasesPT$DateRep <- as.Date(simulationNewCasesPT$DateRep)
simulationNewCasesPT <- bind_rows(simulationNewCasesPT, simTemp)
simulationNewCasesPT <- as_tibble(simulationNewCasesPT)

gPTData_SimCases <- ggplot(simulationNewCasesPT, aes(DateRep, Total.Cases))
PTData_Graph_SimCases <- gPTData_SimCases + geom_point(aes(color = ID)) + geom_hline(yintercept = capacity_PT) + labs(y = "Total Cases") + labs(title = "Portugal 5-day Simulation") + theme(plot.title = element_text(hjust = 0.5))

png(filename = "PTData_Graph_SimCases.png")
PTData_Graph_SimCases
dev.off()


## source("script.R", echo = TRUE)
source("ES_CN.R", echo = TRUE)
source("IT_CN.R", echo = TRUE)
source("UK_CN.R", echo = TRUE)



