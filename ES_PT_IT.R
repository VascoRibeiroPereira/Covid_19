# Comparing PT and Spain Deaths per Day

# Merging the data frames for comparison
ES_PT_IT_merged <- rbind(ESdata, PTdata, ITdata)

ES_PT_IT_merged$GeoId <- factor(ES_PT_IT_merged$GeoId)

# Ploting the Data
gES_PT_IT <- ggplot(ES_PT_IT_merged, aes(DayNum, Deaths))
ES_PT_IT_merged_Graph <- gES_PT_IT + geom_smooth(aes(color = GeoId)) + coord_cartesian(ylim = c(0, 800)) + labs(x = "Days since first case") + labs(y = "Deaths/Day") + labs(title = "Spain vs Portugal vs Italy death rate") + theme(plot.title = element_text(hjust = 0.5))

png(filename = "ES_PT_IT_merged_Graph.png")
ES_PT_IT_merged_Graph
dev.off()

# Comparing Portugal and Spain Cases per Day

# Ploting the Data
gES_PT_IT_Cases <- ggplot(ES_PT_IT_merged, aes(DayNum, Cases))
ES_PT_IT_merged_Graph_Cases <- gES_PT_IT_Cases + geom_smooth(aes(color = GeoId)) + coord_cartesian(ylim = c(0, 7000)) + labs(x = "Days since first case") + labs(y = "Cases/Day") + labs(title = "Spain vs Portugal vs Italy new cases rate") + theme(plot.title = element_text(hjust = 0.5))

png(filename = "ES_PT_IT_merged_Graph_Cases.png")
ES_PT_IT_merged_Graph_Cases
dev.off()

## source("ES_PT_IT.R", echo = TRUE)

