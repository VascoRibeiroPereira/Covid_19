
# Comparing China and Italy deaths per Day

# Filter the data and add num of Day since first death
ITdata <- filter(data, geoId == "IT", dateRep >= "2020-01-31")
ITdata <- mutate(ITdata, DayNum = length(ITdata$dateRep):1)

CNdata <- filter(data, geoId == "CN")
CNdata <- mutate(CNdata, DayNum = length(CNdata$dateRep):1)

# Merging the data frames for comparison
IT_CN_merged <- rbind(ITdata, CNdata)

IT_CN_merged$geoId <- factor(IT_CN_merged$geoId)

# Ploting the Data
gIT_CN <- ggplot(IT_CN_merged, aes(DayNum, deaths))
IT_CN_merged_Graph <- gIT_CN + geom_smooth(aes(color = geoId)) + geom_vline(xintercept = c(1,32), col = c(rgb(.1, .5, .6),rgb(1,.1,.3))) + coord_cartesian(ylim = c(0, 700)) + labs(x = "Days") + labs(y = "deaths") + labs(title = "Italy vs China death rate") + theme(plot.title = element_text(hjust = 0.5))

png(filename = "IT_CN_merged_Graph.png")
IT_CN_merged_Graph
dev.off()

# Comparing China and Italy cases per Day

# Ploting the Data
gIT_CN_cases <- ggplot(IT_CN_merged, aes(DayNum, cases))
IT_CN_merged_Graph_cases <- gIT_CN_cases + geom_smooth(aes(color = geoId)) + geom_vline(xintercept = c(1,32), col = c(rgb(.1, .5, .6),rgb(1,.1,.3))) + coord_cartesian(ylim = c(0, 6000)) + labs(x = "Days") + labs(y = "cases") + labs(title = "Italy vs China new cases rate") + theme(plot.title = element_text(hjust = 0.5))

png(filename = "IT_CN_merged_Graph_cases.png")
IT_CN_merged_Graph_cases
dev.off()

## source("IT_CN.R", echo = TRUE)

