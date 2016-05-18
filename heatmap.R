library("ggmap")
library("ggplot2")

dfDemographics2011 <- csv.read("2011.csv", head=TRUE, as.is=TRUE)
dfDemographics2012 <- csv.read("2012.csv", head=TRUE, as.is=TRUE)
dfDemographics2013 <- csv.read("2013.csv", head=TRUE, as.is=TRUE)
dfDemographics2014 <- csv.read("2014.csv", head=TRUE, as.is=TRUE)

dfDemographics <- rbind(dfDemographics2011,dfDemographics2012,dfDemographics2013,dfDemographics2014)

theme_set(theme_bw(16))
indiaMap <- qmap("India", zoom = 8, color = "bw", legend = "topleft")
indiaMap + 
geom_point(aes(x = Longitude, y = Latitude, colour = Program), data = dfDemographics2012)