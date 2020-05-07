library(ggpmisc)

###### Simulation of new cases #####

x <- 1:length(PTdataArranged$dateRep)

y <- log10(PTdataArranged$cases)
y <- gsub("[-InfNaN]", 0, y)


xsq <- x^2
xcub <- x^3

fit <- lm(y~x+xsq+xcub)


xv <- seq(min(x), 100, 1)
yv <- predict(fit, list(x = xv, xsq = xv^2, xcub = xv^3))
#lines(xv, yv, col="green")

Prediction <- tibble(Day = xv, logCases = yv)
PredictionCases <- tibble(Day = as.Date("2020-03-02")+xv, SimCases = as.integer(10^yv), 
                          RealCases = c(PTdataArranged$cases, rep(NA, 100-length(PTdataArranged$cases))))

PredictionCases$Day <- as.POSIXct(PredictionCases$Day)

curvePredict <- ggplot(PredictionCases, aes(Day, SimCases))
PTgSimCasesNEW <- curvePredict + geom_line() +
                geom_point(aes(Day, RealCases), col = "springgreen4", pch = 15) +
                geom_line(aes(Day, RealCases), col = "springgreen4") +
                labs(y = "Cases per Day", x = "Date", title = "Portugal new Cases Simulation") +
                stat_peaks(col = "tomato3", ignore_threshold = .9) +
                stat_peaks(geom="text", ignore_threshold = .9, hjust=-0.1) +
                theme(plot.title = element_text(hjust = 0.5)) +
                coord_cartesian(xlim = c(PredictionCases$Day[1], as.POSIXct(Sys.Date() + 15)))
                
        
png(filename = "~/R/Covid_19/Covid_19/graphs/PTgSimCases.png")
PTgSimCasesNEW
dev.off()

################ Simulation of total Cases ##### With another aproach

y <- PTdataArranged$`Total cases`
x <- 1:length(PTdataArranged$dateRep)


fit <- nls(y ~ SSlogis(x, Asym, xmid, scal), data = data.frame(x, y))
simulatedTotalCases <- predict(fit, newdata = data.frame(x = seq(1, 100, length.out = 100)))

PredictionTotalCases <- tibble(Day = as.Date("2020-03-02")+(1:100), SimCases = as.integer(simulatedTotalCases), 
                               RealCases = c(PTdataArranged$`Total cases`, rep(NA, 100-length(PTdataArranged$`Total cases`))))

PredictionTotalCases$Day <- as.POSIXct(PredictionTotalCases$Day)

curveTotalPredict <- ggplot(PredictionTotalCases, aes(Day, SimCases))
PTgSimTotalCasesNEW <- curveTotalPredict + geom_line() +
        geom_point(aes(Day, RealCases), col = "springgreen4", pch = 15) +
        labs(y = "Total Cases", x = "Date", title = "Portugal total Cases Simulation") +
        theme(plot.title = element_text(hjust = 0.5))

png(filename = "~/R/Covid_19/Covid_19/graphs/PTData_Graph_Simcases.png")
PTgSimTotalCasesNEW
dev.off()

