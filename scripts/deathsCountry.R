groupedData <- group_by(data, geoId)
worlddeaths <- groupedData %>% summarise(deaths = sum(deaths))

WorstTen <- head(arrange(worlddeaths, desc(deaths)),10)
WorstTen

totaldeaths <- sum(worlddeaths$deaths)
totaldeaths 

tableTest <- knitr::kable(WorstTen , caption = "deaths")