# COVID 19 data analysis

This repo is intended for the observation of the COVID 19 evolution in Portugal and comparisson with other countries.

I'm a Data Science Student, so I'm in a learning process and every input will be very appreciated.

I'll keep this repo with the graphs daily updated.

### World sars-cov-2 propagation
![propagation](https://github.com/VascoRibeiroPereira/Covid_19/blob/master/maps/propagation.gif?raw=true)

*Obtained with the script* `propagationMap.R`

### Updated World Values
__Total Deaths per Country - worst 10__

|geoId | deaths|
|:-----|------:|
|IT    |   9136|
|ES    |   4858|
|CN    |   3301|
|IR    |   2378|
|FR    |   1995|
|US    |   1707|
|UK    |    759|
|NL    |    546|
|DE    |    325|
|BE    |    289|

__Total Death Count__: 26990

### Scripts
`script.R` performs the data preparation and then followed by the steps required as described:

- Download of the data
- Subset the countries for more than 30 observations and make a plot of date vs death for each remaining country
- Filter and merges Portugal and China data from day 1 to present
- Plot the Day vs Death and Day vs New Cases for the China and Portugal data comparison
- Sources the script for Portugal hospital capacity calculations and plot a graph of new cases each day with the hospital capacity threshold
- Calculates the total number of cases in Portugal and plot it with the hospital capacity threshold
- Transform the new cases per day into percentage and plot it
- Plots the nem cases actual data and simulates the next 5 day new cases detected in Portugal based on the mean of the last 5 days percentage of new cases
- Finally, it sources out the scripts that compares the new cases and deaths between selected countries:

        1. ES_CN.R
        2. IT_CN.R
        3. UK_CN.R
        4. ES_PT_IT.R

### Graphs

In the folder __graphs__ you'll find the grahs:

Country comparisons of deaths and new cases

- `ES_CN_merged_Graph_cases.png`
- `ES_CN_merged_Graph.png`
- `ES_PT_IT_merged_Graph_cases.png`
- `ES_PT_IT_merged_Graph.png`
- `IT_CN_merged_Graph_cases.png`
- `IT_CN_merged_Graph.png`
- `PT_CN_merged_Graph_cases.png`
- `PT_CN_merged_Graph.png`
- `UK_CN_merged_Graph_cases.png`
- `UK_CN_merged_Graph.png`

Countries with more than 30 observations: plot of deaths and new cases
- `subsetGraphs.png`
- `subsetGraphscases.png`

Analysis of COVID-19 in Portugal
- `percentageNewcasesPT.png`
- `PTData_Graph_cases.png `   
- `PTData_Graph_Simcases.png`
- `PTData_Graph_Totalcases.png`


### The data source is from:

[Here](https://www.ecdc.europa.eu/en/publications-data/download-todays-data-geographic-distribution-covid-19-cases-worldwide)


### Portugal New Cases Evolution

Simulation of new cases for the next 5 days in Portugal. The horizontal line is the hospital capacity.

![PTData_Graph_SimCases](https://github.com/VascoRibeiroPereira/Covid_19/blob/master/graphs/PTData_Graph_Simcases.png?raw=true)


![percentageNewCasesPT](https://github.com/VascoRibeiroPereira/Covid_19/blob/master/graphs/percentageNewcasesPT.png?raw=true)


#### Notes on the countries comparisons and PT hospital capacity
Vertical Lines represent the **emergency state** declaration for each country

With the script `PT_hospitals_capacity.R` , we can check how many available beds are in the Portuguese hospitals in the present day. As for January 2020 we have about **2389** available hospital beds in Portugal, hopefully more due to the COVID-19 preparations.
Data from [Here](https://transparencia.sns.gov.pt/).

__Be safe,__

__Stay Home!__

- *31/01/2020, Emergency state was declared by WHO in CN*
- *31/01/2020, Emergency state was declared by IT*
- *16/03/2020, Emergency state was declared in ES*
- *16/03/2020, Emergency state was declared in DE*
- *18/03/2020, Emergency state was declared in PT*
- *23/03/2020, Lock Down was declared in UK*