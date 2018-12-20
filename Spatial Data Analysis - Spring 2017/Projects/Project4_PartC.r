#Part_C

#import libraries
library(rgdal)
library(ggplot2)
library(spatstat)
library(maptools)
library(ape)
library(spdep)
library(spgwr)
library(sp)
library(gstat)

#read shape files
Select <- readOGR(dsn="G:/GIS/Project4/PA_County_Select",layer = "PA_County_Select")
O_sensor <- readOGR(dsn="G:/GIS/Project4/Ozone_Sensor_Locs",layer="Ozone_Sensor_Locs")
O_value <- read.table("G:/GIS/Project4//Data/Ozone_Value.dat",header=FALSE,sep="|",quote="",fill=T,stringsAsFactors=F)
nrow(Select)
summary(Select)
nrow(O_sensor)
summary(O_sensor)
nrow(O_value)
summary(Select)

#get table of ozone values
O_value <- O_value[O_value$V3 %in% as.character(O_sensor@data$id),]
O_value <- O_value[O_value$V6 =="OZONE",]
O_value <- O_value[,c(3,8)]
O_value <- cbind(O_value,coordinates(O_sensor[as.character(O_sensor@data$id) %in% O_value$V3,]))
colnames(O_value) <- c("senor_id","ozone_value","longitude","latitude")

#convert [O_value] to SpatialPointsDataFrame
coordinates(O_value) = ~longitude+latitude
O_value
O_value@proj4string <- Select@proj4string #unify coordinate systems

#convert [Select] to SpatialPointsDataFrame
Select_sp <- SpatialPointsDataFrame(coordinates(Select), data = Select@data, proj4string = CRS(proj4string(Select)))


##IDW (use ozone values found at 5 nearest sensor around the county centroid)

idw.gstat= gstat(id = "Ozone", formula = ozone_value ~ 1, data = O_value, nmax =5, set = list(idp =1))
#interpolation
idw.predict=predict(idw.gstat, Select_sp)
#plot
plot(Select)
plot(idw.predict["Ozone.pred"],add=TRUE)
title(main="IDW intepolation - map")
spplot(idw.predict["Ozone.pred"])
#table
idw.predict["Ozone.pred"]


##OK (use all the sensor stations)

g.O_value=gstat(id="Ozone",formula=ozone_value~1,data=O_value)
v.O_value=fit.variogram(variogram(g.O_value),vgm(1,"Exp",300,1))
ok.gstat=gstat(id="Ozone",formula=ozone_value~1,data=O_value,model=v.O_value)
#interpolation
ok.predict=predict(ok.gstat, Select_sp)
#plot
plot(Select)
plot(ok.predict["Ozone.pred"],add=TRUE)
title(main="OK intepolation - map")
spplot(ok.predict["Ozone.pred"])
#table
ok.predict["Ozone.pred"]
