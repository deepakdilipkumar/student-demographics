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
indiaMap <- qmap("India", zoom = 5, source = "google", maptype = "hybrid", legend = "topright") #terrain, satellite, roadmap, hybrid
indiaMap + 
geom_point(aes(x = Longitude, y = Latitude, size= numStudents, darken=0.5), data = dfDistrictDemographics2012)
#facet_wrap(~ year)
#+ stat_density2d(aes(x = Longitude, y = Latitude),size = 2, bins = 4, data = dfDemographics,geom = "polygon")

# Heat Map

load("IND_adm2.RData")
india.adm2.spdf <- get("gadm")

india.adm2.df <- fortify(india.adm2.spdf, region = "NAME_2")


india.adm2.df <- merge(india.adm2.df, unemployment.df, by.y = 'id', all.x = TRUE)
# Get centroids of spatialPolygonDataFrame and convert to dataframe
# for use in plotting  area names. 

india.adm2.centroids.df <- data.frame(long = coordinates(india.adm2.spdf)[, 1], 
   lat = coordinates(india.adm2.spdf)[, 2]) 

# Get names and id numbers corresponding to administrative areas
india.adm2.centroids.df[, 'ID_2'] <- india.adm2.spdf@data[,'ID_2']
india.adm2.centroids.df[, 'NAME_2'] <- india.adm2.spdf@data[,'NAME_2']

p <- ggplot(india.adm2.df, aes(x = long, y = lat, group = group)) + geom_polygon(aes(fill = cut(unemployment,5))) +
geom_text(data = india.adm2.centroids.df, aes(label = NAME_2, x = long, y = lat, group = NAME_2), size = 3) + 
labs(x=" ", y=" ") + 
theme_bw() + scale_fill_brewer('JEE Entrants 2012', palette  = 'PuRd') + 
coord_map() + 
theme(panel.grid.minor=element_blank(), panel.grid.major=element_blank()) + 
theme(axis.ticks = element_blank(), axis.text.x = element_blank(), axis.text.y = element_blank()) + 
theme(panel.border = element_blank())

print(p)