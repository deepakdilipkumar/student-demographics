library("ggmap")
library("ggplot2")
library("sp")

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



# District wise grouping

#theme_set(theme_bw(16))
#indiaMap <- qmap("India", zoom = 5, source = "google", maptype = "hybrid", legend = "topright") #terrain, satellite, roadmap, hybrid
#indiaMap + 
#geom_point(aes(x = Longitude, y = Latitude, size= numStudents, darken=0.5), data = dfDistrictDemographics2012)
#facet_wrap(~ year)
#+ stat_density2d(aes(x = Longitude, y = Latitude),size = 2, bins = 4, data = dfDemographics,geom = "polygon")

# Heat Map

statecolor={}
heat={}
statewise= table(dfDemographics2012$State)
for (state in names(statewise)) {
	heat=c(heat,statewise[state]/max(statewise))
	#statecolor = c(statecolor,rgb(1,0,0,heat))
}
heatdf = data.frame(names(statewise),heat)
india<- readRDS("IND_adm2.rds")
indiaMapdf <- india@data

#table(dfDemographics2012$State)
#table(indiaMapdf$NAME_1)
#heatdf
locColor=rep(0,length(indiaMapdf$OBJECTID))
locColor
for (id in indiaMapdf$OBJECTID){
	print(id)
	if (length(heatdf[heatdf[,1]==toupper(indiaMapdf$NAME_1[id]),2])>0) {
	locColor[id] <- heatdf[heatdf[,1]==toupper(indiaMapdf$NAME_1[id]),2]
}
}


print(locColor)
pdf(file="india.pdf")
plot(india, col=rgb(1,0,0,locColor))
dev.off()
