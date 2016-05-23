library("ggmap")
library("ggplot2")
library("sp")
library("SDMTools")

dfDemographics2011 <- read.csv("2011.csv", head=TRUE, as.is=TRUE)
dfDemographics2012 <- read.csv("2012.csv", head=TRUE, as.is=TRUE)
dfDemographics2013 <- read.csv("2013.csv", head=TRUE, as.is=TRUE)
dfDemographics2014 <- read.csv("2014.csv", head=TRUE, as.is=TRUE)

dfDemographics <- rbind(dfDemographics2011,dfDemographics2012,dfDemographics2013,dfDemographics2014)
dfDemographics <- dfDemographics[dfDemographics$Pincode!="0",]							# Remove entries without a pin code

dfDemographics[dfDemographics$State=="CHATTISGARH","State"] <- "CHHATTISGARH"			# To match GADM data
dfDemographics[dfDemographics$State=="DELHI","State"] <- "NCT OF DELHI"
dfDemographics[dfDemographics$State=="JAMMU & KASHMIR","State"] <- "JAMMU AND KASHMIR"

dfDemographics2011 <- dfDemographics[dfDemographics$Year=="2011",]		# Update
dfDemographics2012 <- dfDemographics[dfDemographics$Year=="2012",]
dfDemographics2013 <- dfDemographics[dfDemographics$Year=="2013",]
dfDemographics2014 <- dfDemographics[dfDemographics$Year=="2014",]

latFactor <- factor(dfDemographics$Latitude)
lonFactor <- factor(dfDemographics$Longitude)
dfDemographics$Latitude <- as.numeric(levels(latFactor))[latFactor]		#Convert from character to numeric
dfDemographics$Longitude <- as.numeric(levels(lonFactor))[lonFactor]

relStudents={}
statewise= table(dfDemographics2012$State)
for (state in names(statewise)) {
	relStudents=c(relStudents,statewise[state]/max(statewise))			#Fraction of students relative to maximum
}

relStudentsdf = data.frame(names(statewise),relStudents)

india <- readRDS("IND_adm2.rds")									#Read GADM data
indiaMapdf <- india@data

locColor=rep(0,length(indiaMapdf$OBJECTID))			
for (id in indiaMapdf$OBJECTID){				# Loop over all the locations stored in indiaMapdf
	if (length(relStudentsdf[relStudentsdf[,1]==toupper(indiaMapdf$NAME_1[id]),2])>0) {				# If the state corresponding to the location in indiaMapdf matches some state in relStudentsdf
	locColor[id] <- relStudentsdf[relStudentsdf[,1]==toupper(indiaMapdf$NAME_1[id]),2]				# Assign the corresponding relative value for that state and store it in locColor
}
}

extremeColors <- c("gray","black")			#Gradient to choose from
pal <- colorRamp(extremeColors)
pal2 <- colorRampPalette(extremeColors)
pdf(file="statewise.pdf")
plot(india, col=rgb(pal(locColor),maxColorValue=255))
title(main="State Wise Distribution of 2012 IITB Entrants")
pnts = cbind(x =c(60,66,66,60), y =c(30,30,15,15))
legend.gradient(pnts,col=pal2(5),limits=c(0,max(statewise)),title="Students")
dev.off()
