# COVID 19 Amateur data analysis

This repo is intended for the observation of the COVID 19 evolution in Portugal and comparisson with other countries.

I'm a Data Science Student, so I'm in a learning process and every input will be very appreciated.

I'll keep this repo with the graphs daily updated.

### Updated World Values
__Total Deaths per Country - worst 10__

|GeoId | Deaths|
|:-----|------:|
|IT    |   7505|
|ES    |   3434|
|CN    |   3293|
|IR    |   2077|
|FR    |   1331|
|US    |   1050|
|UK    |    422|
|NL    |    356|
|DE    |    198|
|BE    |    178|


### Files
`script.R` performs the data preparation and then followed by the steps required as described:

- Download of the data
- Subset the countries for more than 30 observations and make a plot of date vs death for each remaining country
- Filter and merges Portugal and China data from day 1 to present
- Plot the Day vs Death and Day vs New Cases for the China and Portugal data comparison

`PT_CN_merged_Graph.png` is the death comparison between China and Portugal

`PT_CN_merged_Graph_Cases.png` is the new cases comparison between China and Portugal

`subsetGraphs.png` is the death comparison for all countries with more than 30 observations of data

`subsetGraphsCases.png` is the new cases comparison for all countries with more than 30 observations of data

### The data source is from:

[Here](https://www.ecdc.europa.eu/en/publications-data/download-todays-data-geographic-distribution-covid-19-cases-worldwide)


### Portugal New Cases Evolution

Simulation of new cases for the next 5 days in Portugal. The horizontal line is the hospital capacity.

![PTData_Graph_SimCases](https://github.com/VascoRibeiroPereira/Covid_19/blob/master/PTData_Graph_SimCases.png?raw=true)

![PTData_Graph_Cases](https://github.com/VascoRibeiroPereira/Covid_19/blob/master/PTData_Graph_Cases.png?raw=true)

Horizontal line represent the available beds in the Portuguese hospitals.
**Let's keep the new cases curve under this line!**

![percentageNewCasesPT](https://github.com/VascoRibeiroPereira/Covid_19/blob/master/percentageNewCasesPT.png?raw=true)

#### China Vs Portugal day to day death comparison
![Graph_CN_vs_PT](https://github.com/VascoRibeiroPereira/Covid_19/blob/master/PT_CN_merged_Graph.png?raw=true)

Vertical Lines represent the **emergency state** declaration for CN (red) and PT (blue).

#### China Vs Portugal day to day new cases comparison
![Graph_CN_vs_PT_Cases](https://github.com/VascoRibeiroPereira/Covid_19/blob/master/PT_CN_merged_Graph_Cases.png?raw=true)

Vertical Lines represent the **emergency state** declaration for CN (red) and PT (blue).

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