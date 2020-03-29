library(xml2)
webpage_url <- "https://www.worldometers.info/coronavirus/?fbclid=IwAR0GX-fyUq3qrSVBOjAIZ5wXMbekHZRr126hIeEJtpV51pNnlG6ZzEgPXs8"
webpage <- xml2::read_html(webpage_url)

ExOffndrsRaw <- rvest::html_table(webpage)[[1]] %>% 
        tibble::as_tibble(.name_repair = "unique") # repair the repeated columns
ExOffndrsRaw %>% dplyr::glimpse(45)


Portugal <- filter(ExOffndrsRaw, `Country,Other` == "Portugal")
tablePortugal <- knitr::kable(Portugal , caption = "deaths")
tablePortugal
