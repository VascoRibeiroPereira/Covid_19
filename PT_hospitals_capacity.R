library(readr)
##library(dplyr)
library(lubridate)

#create the URL where the dataset is stored with automatic updates every day

urlHospitals <- "https://transparencia.sns.gov.pt/explore/dataset/lotacao-praticada-por-tipo-de-cama/download/?format=csv&timezone=Europe/London&lang=pt&use_labels_for_header=true&csv_separator=%3B"

download.file(urlHospitals, destfile = "./hospitals.csv", method = "curl")

dataHospitals <- read_delim("./hospitals.csv", delim = ";")
dataHospitals$Período <- parse_date(dataHospitals$Período, "%Y-%m")

## bedFilters <- filter(dataHospitals, dataHospitals$`Tipo de Camas` == "Outras Camas" | dataHospitals$`Tipo de Camas` == "Camas Neutras" | dataHospitals$Período == "2020-01-01")
bedFilters <- filter(dataHospitals, dataHospitals$Período >= "2020-01-01", dataHospitals$`Tipo de Camas` == "Outras Camas" | dataHospitals$`Tipo de Camas` == "Camas Neutras" )

capacity_PT <- sum(bedFilters$Lotação)
