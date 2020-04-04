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

#NewObs <- tibble(country = ExOffndrsRaw$`Country,Other`, cases = as.numeric(ExOffndrsRaw$`Tot Cases/1M pop`), tests = as.numeric(ExOffndrsRaw$`Tests/1M pop`), deaths = ExOffndrsRaw$`Deaths/1M pop` )
#NewObsNArm <- remove_missing(NewObs)
#NewObsMatrix <- as.matrix(column_to_rownames(NewObsNArm, var = "country"))
#image(NewObsMatrix)
#png(filename = "~/R/Covid_19/Covid_19/graphs/heatmapNewObsMatrix.png", width = 600, height = 800)
#heatmap(NewObsMatrix)
#dev.off()
