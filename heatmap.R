library("ggmap")
library("ggplot2")

dfDemographics2011 <- read.csv("2011.csv", head=TRUE, as.is=TRUE)
dfDemographics2012 <- read.csv("2012.csv", head=TRUE, as.is=TRUE)
dfDemographics2013 <- read.csv("2013.csv", head=TRUE, as.is=TRUE)
dfDemographics2014 <- read.csv("2014.csv", head=TRUE, as.is=TRUE)

dfDemographics <- rbind(dfDemographics2011,dfDemographics2012,dfDemographics2013,dfDemographics2014)
dfDemographics <- dfDemographics[dfDemographics$Pincode!="0",]


latFactor <- factor(dfDemographics$Latitude)
lonFactor <- factor(dfDemographics$Longitude)
dfDemographics$Latitude <- as.numeric(levels(latFactor))[latFactor]
dfDemographics$Longitude <- as.numeric(levels(lonFactor))[lonFactor]

theme_set(theme_bw(16))
indiaMap <- qmap("India", zoom = 5, legend = "topleft")
indiaMap + 
geom_point(aes(x = Longitude, y = Latitude), data = dfDemographics)