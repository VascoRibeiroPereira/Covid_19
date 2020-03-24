
# Comparing China and Italy Deaths per Day

# Filter the data and add num of Day since first death
ITdata <- filter(data, GeoId == "IT", DateRep >= "2020-01-31")
ITdata <- mutate(ITdata, DayNum = length(ITdata$DateRep):1)

CNdata <- filter(data, GeoId == "CN")
CNdata <- mutate(CNdata, DayNum = length(CNdata$DateRep):1)

# Merging the data frames for comparison
IT_CN_merged <- rbind(ITdata, CNdata)

IT_CN_merged$GeoId <- factor(IT_CN_merged$GeoId)

# Ploting the Data
gIT_CN <- ggplot(IT_CN_merged, aes(DayNum, Deaths))
IT_CN_merged_Graph <- gIT_CN + geom_smooth(aes(color = GeoId)) + geom_vline(xintercept = c(1,32), col = c(rgb(.1, .5, .6),rgb(1,.1,.3))) + coord_cartesian(ylim = c(0, 700)) + labs(x = "Days") + labs(y = "Deaths") + labs(title = "Italy vs China death rate") + theme(plot.title = element_text(hjust = 0.5))

png(filename = "IT_CN_merged_Graph.png")
IT_CN_merged_Graph
dev.off()

# Comparing China and Italy Cases per Day

# Ploting the Data
gIT_CN_Cases <- ggplot(IT_CN_merged, aes(DayNum, Cases))
IT_CN_merged_Graph_Cases <- gIT_CN_Cases + geom_smooth(aes(color = GeoId)) + geom_vline(xintercept = c(1,32), col = c(rgb(.1, .5, .6),rgb(1,.1,.3))) + coord_cartesian(ylim = c(0, 6000)) + labs(x = "Days") + labs(y = "Cases") + labs(title = "Italy vs China new cases rate") + theme(plot.title = element_text(hjust = 0.5))

png(filename = "IT_CN_merged_Graph_Cases.png")
IT_CN_merged_Graph_Cases
dev.off()

## source("IT_CN.R", echo = TRUE)

