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
dfDemographics$Latitude <- as.numeric(levels(latFactor))[latFactor]		#Convert from character to numeric
dfDemographics$Longitude <- as.numeric(levels(lonFactor))[lonFactor]

year="2012"
District={}
numStudents={}
Longitude={}
Latitude={}

dfDemographicsBatch = dfDemographics[dfDemographics$Year==year,]

total=0
for (dist in levels(factor(dfDemographicsBatch$District))){						#Loop over districts
	distStudents =  dfDemographicsBatch[dfDemographicsBatch$District==dist,]
	numStudents=c(numStudents,length(distStudents$District))					#Count number of students in the district
	total=total+length(distStudents$District)
	District=c(District,dist)
	Longitude = c(Longitude,mean(distStudents$Longitude))						#Take location of district as average of all pincodes in that district
	Latitude = c(Latitude, mean(distStudents$Latitude))
}

total
dfDistrictDemographics = data.frame(District,Longitude,Latitude, numStudents)
numStudents
sum(numStudents)
# District wise grouping

pdf(file=paste("district grouping",year,".pdf"))
indiaMap <- qmap("India", zoom = 5, source = "google", maptype = "hybrid", legend = "topright") #terrain, satellite, roadmap or hybrid
indiaMap + 
geom_point(aes(x = Longitude, y = Latitude, size= numStudents, darken=0.5), data = dfDistrictDemographics)
dev.off()
