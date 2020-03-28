##########################################
#              libraries                 #
##########################################

#library(viridis) # nice color palette
#library(ggplot2) # plotting
#library(ggmap) # ggplot functionality for maps
#library(dplyr) # use for fixing up data
#library(readr) # reading in data/csv
#library(RColorBrewer) # for color palettes
#library(purrr) # for mapping over a function
library(magick) # this is call to animate/read pngs

library("ggplot2")
theme_set(theme_bw())
library("sf")

library("rnaturalearth")
library("rnaturalearthdata")
library("gganimate")

##########################################
#                                        #
#  Criação de Mapa de contágio por país  #
#                                        #
##########################################

##########################################
#   Data do primeiro contágio por país   #
##########################################

study <- filter(data, data$cases >= 0)
study <- arrange(study, dateRep)

countryFirst <- filter(study, cases != 0)
countryFirstGroup <- group_by(countryFirst, geoId)
firstInfected <- countryFirstGroup %>% summarise(dateRep = min(dateRep), countryterritoryCode = unique(countryterritoryCode))
firstInfected <- arrange(firstInfected, dateRep)

##########################################
#                 Mapa                   #
##########################################

world <- ne_countries(scale = "medium", returnclass = "sf")

countryOutbreak <- read.delim("./data/countryOutbreak.csv", sep = ",")
countryOutbreak <- arrange(countryOutbreak, dateRep)
countryOutbreak$dateRep <- as.Date(countryOutbreak$dateRep)

#sitesOutbreaks <- data.frame(longitude = countryOutbreak$longitude, latitude = countryOutbreak$latitude)

gWorld <- ggplot(world)



map <- gWorld +
        geom_sf() +
        geom_point(data = countryOutbreak, aes(x = longitude, y = latitude, 
                                               group = seq_along(dateRep)), size = 2, 
                   shape = 23, fill = "darkred") +
        geom_label(data = countryOutbreak, aes(x = longitude, y = latitude, label = paste(name,dateRep))) +
        labs(x = "", y = "") +
        ggtitle("Global propagation of COVID 19") +
        transition_reveal(dateRep)

finalAnimation <- animate(map, fps=1, end_pause = 30, width = 480, height = 280)

anim_save("./Covid_19/maps/propagation.gif",animation=finalAnimation)
