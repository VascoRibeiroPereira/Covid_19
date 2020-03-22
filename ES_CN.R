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
##numberObs <- table(data$GeoId)

## Graphics of the number of Deaths by day in the countries with more than 30 days of data

#subset the data for countries with more than 30 observations and plot
##subset <- data[data$GeoId %in% names(numberObs[numberObs > 30]),]
##subset$GeoId<- factor(subset$GeoId)
##g <- ggplot(subset, aes(DateRep, Deaths))
##subsetGraphs <- g + geom_line() + facet_wrap(.~GeoId, nrow = 8, ncol = 9)

##png(filename = "subsetGraphs.png")
##subsetGraphs
##dev.off()

# Comparing China and Spain Deaths per Day

# Filter the data and add num of Day since first death
ESdata <- filter(data, GeoId == "ES")
ESdata <- ESdata[1:51,]
ESdata <- mutate(ESdata, DayNum = length(ESdata$DateRep):1)

CNdata <- filter(data, GeoId == "CN")
CNdata <- mutate(CNdata, DayNum = length(CNdata$DateRep):1)

# Merging the data frames for comparison
ES_CN_merged <- rbind(ESdata, CNdata)

ES_CN_merged$GeoId <- factor(ES_CN_merged$GeoId)

# Ploting the Data
gES_CN <- ggplot(ES_CN_merged, aes(DayNum, Deaths))
ES_CN_merged_Graph <- gES_CN + geom_smooth(aes(color = GeoId)) + geom_vline(xintercept = c(45,32), col = c(rgb(.1, .5, .6),rgb(1,.1,.3))) + coord_cartesian(ylim = c(0, 700)) + labs(x = "Days") + labs(y = "Deaths") + labs(title = "Italy vs China death rate") + theme(plot.title = element_text(hjust = 0.5))

png(filename = "ES_CN_merged_Graph.png")
ES_CN_merged_Graph
dev.off()

# study data with more than 30 days of observations
##numberObs <- table(data$GeoId)

## Graphics of the number of Cases by day in the countries with more than 30 days of data

# Plot the data
##gCases <- ggplot(subset, aes(DateRep, Cases))
##subsetGraphsCases <- gCases + geom_line() + facet_wrap(.~GeoId, nrow = 8, ncol = 9)

##png(filename = "subsetGraphsCases.png")
##subsetGraphsCases
##dev.off()

# Comparing China and Spain Cases per Day

# Ploting the Data
gES_CN_Cases <- ggplot(ES_CN_merged, aes(DayNum, Cases))
ES_CN_merged_Graph_Cases <- gES_CN_Cases + geom_smooth(aes(color = GeoId)) + geom_vline(xintercept = c(45,32), col = c(rgb(.1, .5, .6),rgb(1,.1,.3))) + coord_cartesian(ylim = c(0, 6000)) + labs(x = "Days") + labs(y = "Cases") + labs(title = "Italy vs China new cases rate") + theme(plot.title = element_text(hjust = 0.5))

png(filename = "ES_CN_merged_Graph_Cases.png")
ES_CN_merged_Graph_Cases
dev.off()

## source("ES_CN.R", echo = TRUE)

