# Comparing China and UK Deaths per Day

# Filter the data and add num of Day since first death
UKdata <- filter(data, GeoId == "UK", DateRep >= "2020-01-31")
UKdata <- mutate(UKdata, DayNum = length(UKdata$DateRep):1)

CNdata <- filter(data, GeoId == "CN")
CNdata <- mutate(CNdata, DayNum = length(CNdata$DateRep):1)

# Merging the data frames for comparison
UK_CN_merged <- rbind(UKdata, CNdata)

UK_CN_merged$GeoId <- factor(UK_CN_merged$GeoId)

# Ploting the Data
gUK_CN <- ggplot(UK_CN_merged, aes(DayNum, Deaths))
UK_CN_merged_Graph <- gUK_CN + geom_smooth(aes(color = GeoId)) + geom_vline(xintercept = c(53,32), col = c(rgb(.1, .5, .6),rgb(1,.1,.3))) + coord_cartesian(ylim = c(0, 700)) + labs(x = "Days") + labs(y = "Deaths") + labs(title = "UK vs China death rate") + theme(plot.title = element_text(hjust = 0.5))

png(filename = "UK_CN_merged_Graph.png")
UK_CN_merged_Graph
dev.off()

# Comparing China and UK Cases per Day

# Ploting the Data
gUK_CN_Cases <- ggplot(UK_CN_merged, aes(DayNum, Cases))
UK_CN_merged_Graph_Cases <- gUK_CN_Cases + geom_smooth(aes(color = GeoId)) + geom_vline(xintercept = c(53,32), col = c(rgb(.1, .5, .6),rgb(1,.1,.3))) + coord_cartesian(ylim = c(0, 6000)) + labs(x = "Days") + labs(y = "Cases") + labs(title = "UK vs China new cases rate") + theme(plot.title = element_text(hjust = 0.5))

png(filename = "UK_CN_merged_Graph_Cases.png")
UK_CN_merged_Graph_Cases
dev.off()

## source("UK_CN.R", echo = TRUE)

