# Comparing China and UK deaths per Day

# Filter the data and add num of Day since first death
UKdata <- filter(data, geoId == "UK", dateRep >= "2020-01-31")
UKdata <- mutate(UKdata, DayNum = length(UKdata$dateRep):1)

CNdata <- filter(data, geoId == "CN")
CNdata <- mutate(CNdata, DayNum = length(CNdata$dateRep):1)

# Merging the data frames for comparison
UK_CN_merged <- rbind(UKdata, CNdata)

UK_CN_merged$geoId <- factor(UK_CN_merged$geoId)

# Ploting the Data
gUK_CN <- ggplot(UK_CN_merged, aes(DayNum, deaths))
UK_CN_merged_Graph <- gUK_CN + geom_smooth(aes(color = geoId)) + geom_vline(xintercept = c(53,32), col = c(rgb(.1, .5, .6),rgb(1,.1,.3))) + coord_cartesian(ylim = c(0, 700)) + labs(x = "Days") + labs(y = "deaths") + labs(title = "UK vs China death rate") + theme(plot.title = element_text(hjust = 0.5))

png(filename = "~/R/Covid_19/Covid_19/graphs/UK_CN_merged_Graph.png")
UK_CN_merged_Graph
dev.off()

# Comparing China and UK cases per Day

# Ploting the Data
gUK_CN_cases <- ggplot(UK_CN_merged, aes(DayNum, cases))
UK_CN_merged_Graph_cases <- gUK_CN_cases + geom_smooth(aes(color = geoId)) + geom_vline(xintercept = c(53,32), col = c(rgb(.1, .5, .6),rgb(1,.1,.3))) + coord_cartesian(ylim = c(0, 6000)) + labs(x = "Days") + labs(y = "cases") + labs(title = "UK vs China new cases rate") + theme(plot.title = element_text(hjust = 0.5))

png(filename = "~/R/Covid_19/Covid_19/graphs/UK_CN_merged_Graph_cases.png")
UK_CN_merged_Graph_cases
dev.off()

## source("UK_CN.R", echo = TRUE)

