# Comparing China and Spain Deaths per Day

# Filter the data and add num of Day since first death
ESdata <- filter(data, GeoId == "ES", DateRep >= "2020-02-01")
ESdata <- mutate(ESdata, DayNum = length(ESdata$DateRep):1)

CNdata <- filter(data, GeoId == "CN")
CNdata <- mutate(CNdata, DayNum = length(CNdata$DateRep):1)

# Merging the data frames for comparison
ES_CN_merged <- rbind(ESdata, CNdata)

ES_CN_merged$GeoId <- factor(ES_CN_merged$GeoId)

# Ploting the Data
gES_CN <- ggplot(ES_CN_merged, aes(DayNum, Deaths))
ES_CN_merged_Graph <- gES_CN + geom_smooth(aes(color = GeoId)) + geom_vline(xintercept = c(45,32), col = c(rgb(.1, .5, .6),rgb(1,.1,.3))) + coord_cartesian(ylim = c(0, 700)) + labs(x = "Days") + labs(y = "Deaths") + labs(title = "Spain vs China death rate") + theme(plot.title = element_text(hjust = 0.5))

png(filename = "ES_CN_merged_Graph.png")
ES_CN_merged_Graph
dev.off()

# Comparing China and Spain Cases per Day

# Ploting the Data
gES_CN_Cases <- ggplot(ES_CN_merged, aes(DayNum, Cases))
ES_CN_merged_Graph_Cases <- gES_CN_Cases + geom_smooth(aes(color = GeoId)) + geom_vline(xintercept = c(45,32), col = c(rgb(.1, .5, .6),rgb(1,.1,.3))) + coord_cartesian(ylim = c(0, 6000)) + labs(x = "Days") + labs(y = "Cases") + labs(title = "Spain vs China new cases rate") + theme(plot.title = element_text(hjust = 0.5))

png(filename = "ES_CN_merged_Graph_Cases.png")
ES_CN_merged_Graph_Cases
dev.off()

## source("ES_CN.R", echo = TRUE)

