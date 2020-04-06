# Comparing China and Spain deaths per Day

# Filter the data and add num of Day since first death
ESdata <- filter(data, geoId == "ES", dateRep >= "2020-02-01")
ESdata <- mutate(ESdata, DayNum = length(ESdata$dateRep):1)

CNdata <- filter(data, geoId == "CN")
CNdata <- mutate(CNdata, DayNum = length(CNdata$dateRep):1)

# Merging the data frames for comparison
ES_CN_merged <- rbind(ESdata, CNdata)

ES_CN_merged$geoId <- factor(ES_CN_merged$geoId)

# Ploting the Data
gES_CN <- ggplot(ES_CN_merged, aes(DayNum, deaths))
ES_CN_merged_Graph <- gES_CN + geom_smooth(aes(color = geoId)) + geom_vline(xintercept = c(45,32), col = c(rgb(.1, .5, .6),rgb(1,.1,.3))) + coord_cartesian(ylim = c(0, 1500)) + labs(x = "Days") + labs(y = "deaths") + labs(title = "Spain vs China death rate") + theme(plot.title = element_text(hjust = 0.5))

png(filename = "~/R/Covid_19/Covid_19/graphs/ES_CN_merged_Graph.png")
ES_CN_merged_Graph
dev.off()

# Comparing China and Spain cases per Day

# Ploting the Data
gES_CN_cases <- ggplot(ES_CN_merged, aes(DayNum, cases))
ES_CN_merged_Graph_cases <- gES_CN_cases + geom_smooth(aes(color = geoId)) + geom_vline(xintercept = c(45,32), col = c(rgb(.1, .5, .6),rgb(1,.1,.3))) + coord_cartesian(ylim = c(0, 12000)) + labs(x = "Days") + labs(y = "cases") + labs(title = "Spain vs China new cases rate") + theme(plot.title = element_text(hjust = 0.5))

png(filename = "~/R/Covid_19/Covid_19/graphs/ES_CN_merged_Graph_cases.png")
ES_CN_merged_Graph_cases
dev.off()

## source("ES_CN.R", echo = TRUE)

