# Part_C

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
library(raster)

#read shape files
setwd("G:/GIS/DataFiles_FinalExam")
P1 <- readOGR(dsn="3_Area1", layer="3_Area1")
P2 <- readOGR(dsn="3_Area2", layer="3_Area2")
P3 <- readOGR(dsn="3_TrailPoints", layer="3_TrailPoints")
P4 <- readOGR(dsn="3_State_Roads", layer="3_State_Roads")
#plot P1~P4
plot(P1,col="lightyellow")
title(main="P1")
plot(P2,col="skyblue")
title(main="P2")
plot(P3,pch=20)
title(main="P3")
plot(P4)
title(main="P4")

##Part_C_a

#overlay P2 on P1
P12 <- P1 * P2
P1. <- P1 - P12
P2. <- P2 - P12
#plots
plot(P12,col="lightgreen")
title(main="P12")
plot(P1.,col="lightyellow")
title(main="P1`")
plot(P1,col="lightyellow")
plot(P12,col="lightgreen",add=T)
title(main="P1")
plot(P2.,col="skyblue")
title(main="P2`")
plot(P2,col="skyblue")
plot(P12,col="lightgreen",add=T)
title(main="P2")

##Part_C_b
P3@proj4string <- P1@proj4string

#overlay P3 on P1
P31 <- over(P3,P1)
P31 <- na.omit(cbind(P3@data,P31))
coordinates(P31) = ~LONGITUDE+LATITUDE
plot(P1,col="lightyellow")
plot(P31,pch = 20,add=T)
title(main="P3 on P1")
nrow(P31)
#overlay P3 on P2
P32 <- over(P3,P2)
P32 <- na.omit(cbind(P3@data,P32))
coordinates(P32) = ~LONGITUDE+LATITUDE
plot(P2,col="skyblue")
plot(P32,pch = 20,add=T)
title(main="P3 on P2")
nrow(P32)
#overlay P3 on P12
P312 <- over(P3,P12)
P312 <- na.omit(cbind(P3@data,P312))
coordinates(P312) = ~LONGITUDE+LATITUDE
plot(P12,col="lightgreen")
plot(P312,pch = 20,add=T)
title(main="P3 on P12")
nrow(P312)

##Part_C_c

LineOnPolygon = function(LineDF, PolygonDF)
{
  LineDF@proj4string = PolygonDF@proj4string
  overlay = over(LineDF, PolygonDF)
  data = na.omit(cbind(LineDF@data, overlay))
  print(sum(data$SEG_LNGTH_))
  lines = LineDF@lines[strtoi(row.names(LineDF)) %in% data$Se_ID]
  sl = SpatialLines(lines, PolygonDF@proj4string)
  newLineDF = SpatialLinesDataFrame(sl, data, match.ID = F)
  plot(PolygonDF)
  plot(newLineDF, col='skyblue',add=T)
}

LineOnPolygon(P4,P1)
title(main="P4 on P1")
LineOnPolygon(P4,P2)
title(main="P4 on P2")
LineOnPolygon(P4,P12)
title(main="P4 on P12")
