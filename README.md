Updated: 2020-05-25

Synopsis
--------

This is a data analysis report of the **public available** data about
Covid19 in Portugal. The report demonstrates how to download and process
data, ranks Portugal by cases and deaths and demonstrates the pandemic
evolution in this country. Some final remarks are made about the limited
availability of the data provided.

This report is also an example of reproducible research in data analysis
making it possible to anyone to reproduce or adapt for any country.

Raw Data
--------

### World Data Source

The primarily data source used for this work was available by the
**European Centre for Disease Prevention and Control**. By analyzing
this data we can get a gist of the evolution of covid19 in the world.
Some information were added trough time to this data, such as new
formats. I choose the JSON format.

    library(jsonlite)
    library(dplyr)
    url <- "https://opendata.ecdc.europa.eu/covid19/casedistribution/json"
    dataRaw <- read_json(url, simplifyVector = TRUE)
    data <- as_tibble(dataRaw$records)
    str(data)

    ## Classes 'tbl_df', 'tbl' and 'data.frame':    19248 obs. of  11 variables:
    ##  $ dateRep                : chr  "25/05/2020" "24/05/2020" "23/05/2020" "22/05/2020" ...
    ##  $ day                    : chr  "25" "24" "23" "22" ...
    ##  $ month                  : chr  "5" "5" "5" "5" ...
    ##  $ year                   : chr  "2020" "2020" "2020" "2020" ...
    ##  $ cases                  : chr  "584" "782" "540" "531" ...
    ##  $ deaths                 : chr  "2" "11" "12" "6" ...
    ##  $ countriesAndTerritories: chr  "Afghanistan" "Afghanistan" "Afghanistan" "Afghanistan" ...
    ##  $ geoId                  : chr  "AF" "AF" "AF" "AF" ...
    ##  $ countryterritoryCode   : chr  "AFG" "AFG" "AFG" "AFG" ...
    ##  $ popData2018            : chr  "37172386" "37172386" "37172386" "37172386" ...
    ##  $ continentExp           : chr  "Asia" "Asia" "Asia" "Asia" ...

#### World Data Pre-Processing - getting Tiddy

Since all available variables are in character format I transformed the
numeric values and date values into their respective formats.

    library(lubridate)
    data$dateRep <- dmy(data$dateRep)
    data$day <- as.numeric(data$day)
    data$month <- as.numeric(data$month)
    data$year <- as.numeric(data$year)
    data$cases <- as.numeric(data$cases)
    data$deaths <- as.numeric(data$deaths)
    data$popData2018 <- as.numeric(data$popData2018)
    str(data)

    ## Classes 'tbl_df', 'tbl' and 'data.frame':    19248 obs. of  11 variables:
    ##  $ dateRep                : Date, format: "2020-05-25" "2020-05-24" ...
    ##  $ day                    : num  25 24 23 22 21 20 19 18 17 16 ...
    ##  $ month                  : num  5 5 5 5 5 5 5 5 5 5 ...
    ##  $ year                   : num  2020 2020 2020 2020 2020 2020 2020 2020 2020 2020 ...
    ##  $ cases                  : num  584 782 540 531 492 ...
    ##  $ deaths                 : num  2 11 12 6 9 5 4 1 0 32 ...
    ##  $ countriesAndTerritories: chr  "Afghanistan" "Afghanistan" "Afghanistan" "Afghanistan" ...
    ##  $ geoId                  : chr  "AF" "AF" "AF" "AF" ...
    ##  $ countryterritoryCode   : chr  "AFG" "AFG" "AFG" "AFG" ...
    ##  $ popData2018            : num  37172386 37172386 37172386 37172386 37172386 ...
    ##  $ continentExp           : chr  "Asia" "Asia" "Asia" "Asia" ...

Now we can work with these numbers and make some exploratory analysis.
Let’s check out a summary of our data:

    summary(data)

    ##     dateRep                day            month             year     
    ##  Min.   :2019-12-31   Min.   : 1.00   Min.   : 1.000   Min.   :2019  
    ##  1st Qu.:2020-03-12   1st Qu.: 9.00   1st Qu.: 3.000   1st Qu.:2020  
    ##  Median :2020-04-09   Median :16.00   Median : 4.000   Median :2020  
    ##  Mean   :2020-04-01   Mean   :15.79   Mean   : 3.574   Mean   :2020  
    ##  3rd Qu.:2020-05-02   3rd Qu.:23.00   3rd Qu.: 5.000   3rd Qu.:2020  
    ##  Max.   :2020-05-25   Max.   :31.00   Max.   :12.000   Max.   :2020  
    ##                                                                      
    ##      cases             deaths        countriesAndTerritories    geoId          
    ##  Min.   :-2461.0   Min.   :   0.00   Length:19248            Length:19248      
    ##  1st Qu.:    0.0   1st Qu.:   0.00   Class :character        Class :character  
    ##  Median :    2.0   Median :   0.00   Mode  :character        Mode  :character  
    ##  Mean   :  279.1   Mean   :  17.91                                             
    ##  3rd Qu.:   44.0   3rd Qu.:   1.00                                             
    ##  Max.   :48529.0   Max.   :4928.00                                             
    ##                                                                                
    ##  countryterritoryCode  popData2018        continentExp      
    ##  Length:19248         Min.   :1.000e+03   Length:19248      
    ##  Class :character     1st Qu.:2.119e+06   Class :character  
    ##  Mode  :character     Median :9.631e+06   Mode  :character  
    ##                       Mean   :5.053e+07                     
    ##                       3rd Qu.:3.370e+07                     
    ##                       Max.   :1.393e+09                     
    ##                       NA's   :261

Ok, something awkward is going on. The **new cases** and **deaths**
variable have negative values, because, as one may notice, the minimum
value is **-2461** and **0** for each. There shouldn’t be negative
values, the only explanation available is mistakes in counts that are
then corrected this way. This is possible the wrongest way to correct
mistakes because one doesn’t know for sure the real values of the
mistaken day nor the negative cases/deaths day.

One thing to always have in mind is the source of the data: our source
must be **reliable and trustworthy**.

Now that I have a **somewhat** tidy data, I can think a bit about the
variables available:

    names(data)

    ##  [1] "dateRep"                 "day"                    
    ##  [3] "month"                   "year"                   
    ##  [5] "cases"                   "deaths"                 
    ##  [7] "countriesAndTerritories" "geoId"                  
    ##  [9] "countryterritoryCode"    "popData2018"            
    ## [11] "continentExp"

The most interesting data I will address will be the number of detected
**cases** and **deaths**, by **date reported**.

Portugal in the World
---------------------

How is Portugal rated in death and cases counts? There is some social
media discussion about how to address this rates. Let us compare
absolute numbers with percentages related to country population:

    CasesRank <- data %>% 
            group_by(countriesAndTerritories) %>%
            summarise("TotalCases" = sum(cases)) %>%
            arrange(desc(TotalCases))

    PTrankCases <- grep("Portugal", CasesRank$countriesAndTerritories)

    numberofCases <- CasesRank %>% filter(countriesAndTerritories == "Portugal")
    numberofCases <- as.integer(numberofCases[2])

    knitr::kable(head(CasesRank, 10))

<table>
<thead>
<tr class="header">
<th style="text-align: left;">countriesAndTerritories</th>
<th style="text-align: right;">TotalCases</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;">United_States_of_America</td>
<td style="text-align: right;">1643238</td>
</tr>
<tr class="even">
<td style="text-align: left;">Brazil</td>
<td style="text-align: right;">363211</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Russia</td>
<td style="text-align: right;">344481</td>
</tr>
<tr class="even">
<td style="text-align: left;">United_Kingdom</td>
<td style="text-align: right;">259559</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Spain</td>
<td style="text-align: right;">235772</td>
</tr>
<tr class="even">
<td style="text-align: left;">Italy</td>
<td style="text-align: right;">229858</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Germany</td>
<td style="text-align: right;">178570</td>
</tr>
<tr class="even">
<td style="text-align: left;">Turkey</td>
<td style="text-align: right;">156827</td>
</tr>
<tr class="odd">
<td style="text-align: left;">France</td>
<td style="text-align: right;">144921</td>
</tr>
<tr class="even">
<td style="text-align: left;">India</td>
<td style="text-align: right;">138845</td>
</tr>
</tbody>
</table>

The above table reflects the ranked 10 worst countries in COVID-19
diagnosed cases. Portugal is ranked **28**, with **30623** total cases.

    DeathsRank <- data %>% 
            group_by(countriesAndTerritories) %>%
            summarise("TotalDeaths" = sum(deaths)) %>%
            arrange(desc(TotalDeaths))

    PTrankDeaths <- grep("Portugal", DeathsRank$countriesAndTerritories)

    numberofDeaths <- DeathsRank %>% filter(countriesAndTerritories == "Portugal")
    numberofDeaths <- as.integer(numberofDeaths[2])

    knitr::kable(head(DeathsRank, 10))

<table>
<thead>
<tr class="header">
<th style="text-align: left;">countriesAndTerritories</th>
<th style="text-align: right;">TotalDeaths</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;">United_States_of_America</td>
<td style="text-align: right;">97720</td>
</tr>
<tr class="even">
<td style="text-align: left;">United_Kingdom</td>
<td style="text-align: right;">36793</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Italy</td>
<td style="text-align: right;">32785</td>
</tr>
<tr class="even">
<td style="text-align: left;">Spain</td>
<td style="text-align: right;">28752</td>
</tr>
<tr class="odd">
<td style="text-align: left;">France</td>
<td style="text-align: right;">28367</td>
</tr>
<tr class="even">
<td style="text-align: left;">Brazil</td>
<td style="text-align: right;">22666</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Belgium</td>
<td style="text-align: right;">9280</td>
</tr>
<tr class="even">
<td style="text-align: left;">Germany</td>
<td style="text-align: right;">8257</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Iran</td>
<td style="text-align: right;">7417</td>
</tr>
<tr class="even">
<td style="text-align: left;">Mexico</td>
<td style="text-align: right;">7394</td>
</tr>
</tbody>
</table>

The above table reflects the ranked 10 worst countries in COVID-19
deaths. Portugal is ranked **23**, with **1316** total deaths.

Let us now check the same rates in percentage.

    CasesPerRank <- data %>% 
            group_by(countriesAndTerritories) %>%
            summarise("TotalCases" = sum(cases), "Pop" = unique(popData2018)) %>%
            mutate("PercentageCases" = TotalCases/Pop * 100) %>%
            arrange(desc(PercentageCases))

    DeathsPerRank <- data %>% 
            group_by(countriesAndTerritories) %>%
            summarise("TotalDeaths" = sum(deaths), "Pop" = unique(popData2018)) %>%
            mutate("PercentageDeaths" = TotalDeaths/Pop * 100) %>%
            arrange(desc(PercentageDeaths))


    PTPerRankCases <- grep("Portugal", CasesPerRank$countriesAndTerritories)
    PTPerRankDeaths <- grep("Portugal", CasesPerRank$countriesAndTerritories)

    knitr::kable(head(CasesPerRank, 10))

<table>
<thead>
<tr class="header">
<th style="text-align: left;">countriesAndTerritories</th>
<th style="text-align: right;">TotalCases</th>
<th style="text-align: right;">Pop</th>
<th style="text-align: right;">PercentageCases</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;">Cases_on_an_international_conveyance_Japan</td>
<td style="text-align: right;">696</td>
<td style="text-align: right;">3000</td>
<td style="text-align: right;">23.2000000</td>
</tr>
<tr class="even">
<td style="text-align: left;">San_Marino</td>
<td style="text-align: right;">665</td>
<td style="text-align: right;">33785</td>
<td style="text-align: right;">1.9683291</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Qatar</td>
<td style="text-align: right;">43714</td>
<td style="text-align: right;">2781677</td>
<td style="text-align: right;">1.5714981</td>
</tr>
<tr class="even">
<td style="text-align: left;">Holy_See</td>
<td style="text-align: right;">12</td>
<td style="text-align: right;">1000</td>
<td style="text-align: right;">1.2000000</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Andorra</td>
<td style="text-align: right;">763</td>
<td style="text-align: right;">77006</td>
<td style="text-align: right;">0.9908319</td>
</tr>
<tr class="even">
<td style="text-align: left;">Luxembourg</td>
<td style="text-align: right;">3992</td>
<td style="text-align: right;">607728</td>
<td style="text-align: right;">0.6568728</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Bahrain</td>
<td style="text-align: right;">9138</td>
<td style="text-align: right;">1569439</td>
<td style="text-align: right;">0.5822463</td>
</tr>
<tr class="even">
<td style="text-align: left;">Singapore</td>
<td style="text-align: right;">31616</td>
<td style="text-align: right;">5638676</td>
<td style="text-align: right;">0.5606990</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Kuwait</td>
<td style="text-align: right;">21302</td>
<td style="text-align: right;">4137309</td>
<td style="text-align: right;">0.5148757</td>
</tr>
<tr class="even">
<td style="text-align: left;">Iceland</td>
<td style="text-align: right;">1804</td>
<td style="text-align: right;">353574</td>
<td style="text-align: right;">0.5102185</td>
</tr>
</tbody>
</table>

    knitr::kable(head(DeathsPerRank, 10))

<table>
<thead>
<tr class="header">
<th style="text-align: left;">countriesAndTerritories</th>
<th style="text-align: right;">TotalDeaths</th>
<th style="text-align: right;">Pop</th>
<th style="text-align: right;">PercentageDeaths</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;">Cases_on_an_international_conveyance_Japan</td>
<td style="text-align: right;">7</td>
<td style="text-align: right;">3000</td>
<td style="text-align: right;">0.2333333</td>
</tr>
<tr class="even">
<td style="text-align: left;">San_Marino</td>
<td style="text-align: right;">42</td>
<td style="text-align: right;">33785</td>
<td style="text-align: right;">0.1243155</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Belgium</td>
<td style="text-align: right;">9280</td>
<td style="text-align: right;">11422068</td>
<td style="text-align: right;">0.0812462</td>
</tr>
<tr class="even">
<td style="text-align: left;">Andorra</td>
<td style="text-align: right;">51</td>
<td style="text-align: right;">77006</td>
<td style="text-align: right;">0.0662286</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Spain</td>
<td style="text-align: right;">28752</td>
<td style="text-align: right;">46723749</td>
<td style="text-align: right;">0.0615362</td>
</tr>
<tr class="even">
<td style="text-align: left;">United_Kingdom</td>
<td style="text-align: right;">36793</td>
<td style="text-align: right;">66488991</td>
<td style="text-align: right;">0.0553370</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Italy</td>
<td style="text-align: right;">32785</td>
<td style="text-align: right;">60431283</td>
<td style="text-align: right;">0.0542517</td>
</tr>
<tr class="even">
<td style="text-align: left;">France</td>
<td style="text-align: right;">28367</td>
<td style="text-align: right;">66987244</td>
<td style="text-align: right;">0.0423469</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Sweden</td>
<td style="text-align: right;">3998</td>
<td style="text-align: right;">10183175</td>
<td style="text-align: right;">0.0392608</td>
</tr>
<tr class="even">
<td style="text-align: left;">Sint_Maarten</td>
<td style="text-align: right;">15</td>
<td style="text-align: right;">41486</td>
<td style="text-align: right;">0.0361568</td>
</tr>
</tbody>
</table>

There are evident differences from percentage to absolute numbers in the
extremes (but in fact Portugal doesn’t change much at the time of this
report writing). In percentage Portugal is in **27** place for cases and
**27** for deaths. Is this a fair comparison? There may be missing
variables to understand our data: some index of number of urban centers
per country for example, and also the predominance of respiratory
diseases, atmospheric pollution and elderly people percentage. Also, the
number of tests each country do highly influence the reported cases. All
this summed together can cause a great impact at the political level for
managing the emergency states of each countries and interpreting the
results. With too many unknown factors the effectiveness of some
policies may result only by chance.

Since there are just too many unknown factors in the percentage rate
maybe the fairest way to compare is the absolute numbers (aware of not
being ideal as well).

Evolution of the Disease in Portugal and Simulations
----------------------------------------------------

In the next lines I try to simulate new cases and deaths from COVID-19
in Portugal with a 15 day advance from the last data reported and to
identify a peak, where we could consider a turning point for the
pandemic in Portugal, meaning that the contingency politics are taking
effect.

    PTdata <- filter(data, geoId == "PT")
    PTdataArranged <- arrange(PTdata, dateRep)

    library(ggpmisc)

    x <- 1:length(PTdataArranged$dateRep)
    y <- log10(PTdataArranged$cases)
    y <- gsub("[-InfNaN]", 0, y)

    xsq <- x^2
    xcub <- x^3

    fit <- lm(y~x+xsq+xcub)

    xv <- seq(min(x), 100, 1)
    yv <- predict(fit, list(x = xv, xsq = xv^2, xcub = xv^3))

    #Prediction <- tibble(Day = xv, logCases = yv)
    PredictionCases <- tibble(Day = as.Date("2020-03-02")+xv, 
                              SimCases = as.integer(10^yv), 
                              RealCases = c(PTdataArranged$cases, rep(NA,
                                                            100-length(PTdataArranged$cases))))
    PredictionCases$Day <- as.POSIXct(PredictionCases$Day)

    CasesMaxDay <- as.Date(PredictionCases$Day[
            grep(max(PredictionCases$SimCases[1:length(PTdataArranged$cases)]), 
                 PredictionCases$SimCases)])

    curvePredict <- ggplot(PredictionCases, aes(Day, SimCases))
    PTgSimCasesNEW <- curvePredict + geom_line() +
                    geom_point(aes(Day, RealCases), col = "springgreen4", pch = 15) +
                    geom_line(aes(Day, RealCases), col = "springgreen4") +
                    labs(y = "Cases per Day", x = "Date", 
                         title = "Portugal new Cases Simulation") +
                    stat_peaks(col = "tomato3", ignore_threshold = .9) +
                    theme(plot.title = element_text(hjust = 0.5)) +
                    coord_cartesian(xlim = c(PredictionCases$Day[1], as.POSIXct(Sys.Date() + 15)),
                                    ylim = c(0, 2000))
    PTgSimCasesNEW

![](README_files/figure-markdown_strict/new%20cases%20with%20sim-1.png)

    z <- log10(PTdataArranged$deaths)
    z <- sub("-Inf", "0", z)

    fitD <- lm(z~x+xsq+xcub)

    xv <- seq(min(x), 100, 1)
    zv <- predict(fitD, list(x = xv, xsq = xv^2, xcub = xv^3))

    PredictionDeaths <- tibble(Day = as.Date("2020-03-02")+xv, 
                              SimDeaths = as.integer(10^zv), 
                              RealDeaths = c(PTdataArranged$deaths, rep(NA,
                                                            100-length(PTdataArranged$deaths))))

    PredictionDeaths$Day <- as.POSIXct(PredictionDeaths$Day)

    DeathsMaxDay <- as.Date(PredictionDeaths$Day[
            grep(max(PredictionDeaths$SimDeaths[1:length(PTdataArranged$deaths)]),
                 PredictionDeaths$SimDeaths)])

    curvePredictDeaths <- ggplot(PredictionDeaths, aes(Day, SimDeaths))
    PTgSimDeaths <- curvePredictDeaths + geom_line() +
                    geom_point(aes(Day, RealDeaths), col = "springgreen4", pch = 15) +
                    geom_line(aes(Day, RealDeaths), col = "springgreen4") +
                    labs(y = "Deaths per Day", x = "Date", 
                         title = "Portugal Deaths Simulation") +
                    stat_peaks(col = "tomato3", ignore_threshold = .7) +
                    theme(plot.title = element_text(hjust = 0.5)) +
                    coord_cartesian(xlim = c(PredictionDeaths$Day[1], as.POSIXct(Sys.Date() + 15)))
    PTgSimDeaths

![](README_files/figure-markdown_strict/deaths%20with%20sim-1.png)

As we can observe from the graphs, the worst seems to have passed. The
peak for new cases detected was in **2020-04-06** and the peak for
deaths in Portugal was in **2020-04-14, 2020-04-15, 2020-04-16,
2020-04-17, 2020-04-18, 2020-04-19, 2020-04-20, 2020-04-21, 2020-04-22,
2020-04-23, 2020-04-24**.

Conclusions
-----------

-   Cases: Portugal is ranked **28** in 207 countries, with **30623**
    total cases. Portugal had the peak of cases in **2020-04-06**.  
-   Deaths: Portugal is ranked **23** in 207 countries, with **1316**
    total deaths. Portugal had the peak of deaths in **2020-04-14,
    2020-04-15, 2020-04-16, 2020-04-17, 2020-04-18, 2020-04-19,
    2020-04-20, 2020-04-21, 2020-04-22, 2020-04-23, 2020-04-24**.

The fact that the “peaks” have passed for the cases and deaths in
Portugal doesn’t mean that the problem is over. For example, the peaks
are always moving around because every day the simulations are iterated
with the new information available, and new policies and the end of the
confinement may produce more peaks for new cases and deaths.  
From comparing our country with the others, we are quite better than
most countries. This is due to several factors, not only policies but
also with our peripheric geo-location. Also, it must be observed the
predominance of the disease in the north hemisphere of the planet - so
our rank my improve greatly for the next months (our rank in the end of
April is about 18th to 19th place), if there is some influence with the
flu-season.

Final Considerations
--------------------

There is a lack of trustworthy data sources that would complement this
data and give us detailed information about the **how’s** and **why’s**
of SARS-CoV-2 behavior. Interesting variables that I would consider
worth studying would be: **Active Cases**, **Recovered Cases**, **ICU
Cases**, **Non-ICU Hospitalized Cases**, and also some information about
patients, like: **Known Diseases**, a logical or more informative
**IfSmoker** variable and **Air Pollution Exposure**.

Some of this information is retained by the “Sistema nacional de
vigilância epidemiológica”
[**SINAVE**](https://www.google.com/search?client=safari&rls=en&q=sistema+nacional+de+vigil%C3%A2ncia+epidemiol%C3%B3gica&ie=UTF-8&oe=UTF-8)

I’ve applied for access in 2020-04-27 from an institutional e-mail but
not a reply until today.
