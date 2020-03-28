# Comparing PT and Spain deaths per Day

# Merging the data frames for comparison
ES_PT_IT_merged <- rbind(ESdata, PTdata, ITdata)

ES_PT_IT_merged$geoId <- factor(ES_PT_IT_merged$geoId)

# Ploting the Data
gES_PT_IT <- ggplot(ES_PT_IT_merged, aes(DayNum, deaths))
ES_PT_IT_merged_Graph <- gES_PT_IT + geom_smooth(aes(color = geoId)) + coord_cartesian(ylim = c(0, 800)) + labs(x = "Days since first case") + labs(y = "deaths/Day") + labs(title = "Spain vs Portugal vs Italy death rate") + theme(plot.title = element_text(hjust = 0.5))

png(filename = "~/R/Covid_19/Covid_19/graphs/ES_PT_IT_merged_Graph.png")
ES_PT_IT_merged_Graph
dev.off()

# Comparing Portugal and Spain cases per Day

# Ploting the Data
gES_PT_IT_cases <- ggplot(ES_PT_IT_merged, aes(DayNum, cases))
ES_PT_IT_merged_Graph_cases <- gES_PT_IT_cases + geom_smooth(aes(color = geoId)) + coord_cartesian(ylim = c(0, 7000)) + labs(x = "Days since first case") + labs(y = "cases/Day") + labs(title = "Spain vs Portugal vs Italy new cases rate") + theme(plot.title = element_text(hjust = 0.5))

png(filename = "~/R/Covid_19/Covid_19/graphs/ES_PT_IT_merged_Graph_cases.png")
ES_PT_IT_merged_Graph_cases
dev.off()

## source("ES_PT_IT.R", echo = TRUE)

