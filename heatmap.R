library("ggmap")
library("ggplot2")
library("sp")
library("SDMTools")

dfDemographics2011 <- read.csv("2011.csv", head=TRUE, as.is=TRUE)
dfDemographics2012 <- read.csv("2012.csv", head=TRUE, as.is=TRUE)
dfDemographics2013 <- read.csv("2013.csv", head=TRUE, as.is=TRUE)
dfDemographics2014 <- read.csv("2014.csv", head=TRUE, as.is=TRUE)

dfDemographics <- rbind(dfDemographics2011,dfDemographics2012,dfDemographics2013,dfDemographics2014)
dfDemographics <- dfDemographics[dfDemographics$Pincode!="0",]

dfDemographics[dfDemographics$State=="CHATTISGARH","State"] <- "CHHATTISGARH"
dfDemographics[dfDemographics$State=="DELHI","State"] <- "NCT OF DELHI"
dfDemographics[dfDemographics$State=="JAMMU & KASHMIR","State"] <- "JAMMU AND KASHMIR"
#dfDemographics[dfDemographics$State=="","State"] <- ""

dfDemographics2012[dfDemographics2012$State=="CHATTISGARH","State"] <- "CHHATTISGARH"
dfDemographics2012[dfDemographics2012$State=="DELHI","State"] <- "NCT OF DELHI"
dfDemographics2012[dfDemographics2012$State=="JAMMU & KASHMIR","State"] <- "JAMMU AND KASHMIR"

latFactor <- factor(dfDemographics$Latitude)
lonFactor <- factor(dfDemographics$Longitude)
dfDemographics$Latitude <- as.numeric(levels(latFactor))[latFactor]
dfDemographics$Longitude <- as.numeric(levels(lonFactor))[lonFactor]

District={}
numStudents={}
Longitude={}
Latitude={}

for (dist in levels(factor(dfDemographics2012$District))){
	distStudents =  dfDemographics[dfDemographics$District==dist,]
	numStudents=c(numStudents,length(distStudents$District))
	District=c(District,dist)
	Longitude = c(Longitude,mean(distStudents$Longitude))
	Latitude = c(Latitude, mean(distStudents$Latitude))
}

dfDistrictDemographics2012 = data.frame(District,Longitude,Latitude, numStudents)

statecolor={}
heat={}
statewise= table(dfDemographics2012$State)
statewise
for (state in names(statewise)) {
	heat=c(heat,statewise[state]/max(statewise))
	#statecolor = c(statecolor,rgb(1,0,0,heat))
}
heatdf = data.frame(names(statewise),heat)
india<- readRDS("IND_adm2.rds")
indiaMapdf <- india@data

locColor=rep(0,length(indiaMapdf$OBJECTID))
for (id in indiaMapdf$OBJECTID){
	if (length(heatdf[heatdf[,1]==toupper(indiaMapdf$NAME_1[id]),2])>0) {
	locColor[id] <- heatdf[heatdf[,1]==toupper(indiaMapdf$NAME_1[id]),2]
}
}


pal <- colorRamp(c("yellow","red"))
pal2 <- colorRampPalette(c("yellow","red"))
cols<- pal(locColor)
pdf(file="statewise.pdf")
#jpeg(file="statewise.jpeg")
plot(india, col=pal(locColor))
title(main="State Wise Distribution of 2012 IITB Entrants")
pnts = cbind(x =c(60,66,66,60), y =c(30,30,15,15))
#legend.gradient(pnts,col=c(rgb(0,0,1,0),rgb(0,0,1,0.25),rgb(0,0,1,0.5),rgb(0,0,1,0.75),rgb(0,0,1,1)),limits=c(0,max(statewise)),title="Students")
legend.gradient(pnts,col=pal2(5),limits=c(0,max(statewise)),title="Students")
dev.off()
