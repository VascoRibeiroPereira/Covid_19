library(xml2)
webpage_url <- "https://www.worldometers.info/coronavirus/?fbclid=IwAR0GX-fyUq3qrSVBOjAIZ5wXMbekHZRr126hIeEJtpV51pNnlG6ZzEgPXs8"
webpage <- xml2::read_html(webpage_url)

ExOffndrsRaw <- rvest::html_table(webpage)[[1]] %>% 
        tibble::as_tibble(.name_repair = "unique") # repair the repeated columns
ExOffndrsRaw %>% dplyr::glimpse(45)


Portugal <- filter(ExOffndrsRaw, `Country,Other` == "Portugal")
tablePortugal <- knitr::kable(Portugal , caption = "deaths")
tablePortugal

## source("worldmeterScrap.R", echo = TRUE)


### Uniformity of names in both tables
#groupedData$countriesAndTerritories <- gsub("_", " ", groupedData$countriesAndTerritories)
#groupedData$countriesAndTerritories <- gsub("Timor Leste", "Timor-Leste", groupedData$countriesAndTerritories)
#groupedData$countriesAndTerritories <- gsub("Saint Barthelemy", "St. Barth", groupedData$countriesAndTerritories)

#dataInterest <- unique(tibble(countriesAndTerritories = groupedData$countriesAndTerritories, pop = as.numeric(groupedData$popData2018)))


#ExOffndrsRaw$`Country,Other` <- gsub("S. Korea", "South Korea", ExOffndrsRaw$`Country,Other`)

### join data frames
#colnames(ExOffndrsRaw)[1] <- "countriesAndTerritories"

#joinedDF <- inner_join(ExOffndrsRaw, dataInterest, by = "countriesAndTerritories")






#NewObs <- tibble(country = joinedDF$`countriesAndTerritories`, cases = as.numeric(joinedDF$`Tot Cases/1M pop`), tests = as.numeric(joinedDF$`Tests/1M pop`), deaths = joinedDF$`Deaths/1M pop`, pop = joinedDF$pop*10^-3)
#NewObsNArm <- remove_missing(NewObs)
#NewObsMatrix <- as.matrix(column_to_rownames(NewObsNArm, var = "country"))
#image(NewObsMatrix)
#png(filename = "~/R/Covid_19/Covid_19/graphs/heatmapNewObsMatrix.png", width = 600, height = 800)
#heatmap(NewObsMatrix)
#dev.off()

