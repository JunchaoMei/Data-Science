# Part_A

#import libraries
library(rgdal)
library(ggplot2)
library(spatstat)
library(maptools)
library(ape)
library(spdep)
library(spgwr)
library(sp)

#read shape files
Council <- readOGR(dsn="G:/GIS/Project4/AlleghenyCounty_Council", layer="AlleghenyCounty_Council")
Municipal <- readOGR(dsn="G:/GIS/Project4/AlleghenyCounty_Municipal", layer="AlleghenyCounty_Municipal")
#number of ploygons
nrow(Council)
nrow(Municipal)
plot(Council)
plot(Municipal)

#Council Rook's Adjacency
Council.nb.rook=poly2nb(Council,queen = FALSE)
Council.w.rook=nb2listw(Council.nb.rook,style = "B")
moran.test(Council@data$SHAPE_area,Council.w.rook)
geary.test(Council@data$SHAPE_area,Council.w.rook)

#Council Queen's Adjacency
Council.nb.queen=poly2nb(Council,queen = TRUE)
Council.w.queen=nb2listw(Council.nb.queen,style = "B")
moran.test(Council@data$SHAPE_area,Council.w.queen)
geary.test(Council@data$SHAPE_area,Council.w.queen)

#plot Council - Rook's & Queen's Adjacency
plot(Council,col="grey")
plot(Council.nb.rook,coords=coordinates(Council),add=T,col='blue',lwd=3)
title(main="AlleghenyCounty_Council - Rook's Adjacency")
plot(Council,col="grey")
plot(Council.nb.queen,coords=coordinates(Council),add=T,col='red',lwd=3)
title(main="AlleghenyCounty_Council - Queen's Adjacency")

#Municipal Rook's Adjacency
Municipal.nb.rook=poly2nb(Municipal,queen = FALSE)
Municipal.w.rook=nb2listw(Municipal.nb.rook,style = "B")
moran.test(Municipal@data$SHAPE_area,Municipal.w.rook)
geary.test(Municipal@data$SHAPE_area,Municipal.w.rook)

#Municipal Queen's Adjacency
Municipal.nb.queen=poly2nb(Municipal,queen = TRUE)
Municipal.w.queen=nb2listw(Municipal.nb.queen,style = "B")
moran.test(Municipal@data$SHAPE_area,Municipal.w.queen)
geary.test(Municipal@data$SHAPE_area,Municipal.w.queen)

#plot Municipal - Rook's & Queen's Adjacency
plot(Municipal,col="grey")
plot(Municipal.nb.rook,coords=coordinates(Municipal),add=T,col='blue',lwd=3)
title(main="AlleghenyCounty_Municipal - Rook's Adjacency")
plot(Municipal,col="grey")
plot(Municipal.nb.queen,coords=coordinates(Municipal),add=T,col='red',lwd=3)
title(main="AlleghenyCounty_Municipal - Queen's Adjacency")