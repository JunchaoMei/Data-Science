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
setwd("G:/GIS/DataFiles_FinalExam")
Neighbor1 <- readOGR(dsn="1_Neighbor1", layer="1_Neighbor1")
Neighbor2 <- readOGR(dsn="1_Neighbor2", layer="1_Neighbor2")
nrow(Neighbor1)
summary(Neighbor1)
nrow(Neighbor2)
summary(Neighbor2)

#Neighbor1 - Rook's Adjacency
Neighbor1.nb.rook=poly2nb(Neighbor1,queen = FALSE)
Neighbor1.w.rook=nb2listw(Neighbor1.nb.rook,style = "B")
moran.test(Neighbor1@data$POP_ARR02,Neighbor1.w.rook)
geary.test(Neighbor1@data$POP_ARR02,Neighbor1.w.rook)
#Neighbor1 - Queen's Adjacency
Neighbor1.nb.queen=poly2nb(Neighbor1,queen = TRUE)
Neighbor1.w.queen=nb2listw(Neighbor1.nb.queen,style = "B")
moran.test(Neighbor2@data$POP_ARR02,Neighbor1.w.queen)
geary.test(Neighbor2@data$POP_ARR02,Neighbor1.w.queen)

#Neighbor2 - Rook's Adjacency
Neighbor2.nb.rook=poly2nb(Neighbor2,queen = FALSE)
Neighbor2.w.rook=nb2listw(Neighbor2.nb.rook,style = "B")
moran.test(Neighbor2@data$POP_ARR02,Neighbor2.w.rook)
geary.test(Neighbor2@data$POP_ARR02,Neighbor2.w.rook)
#Neighbor2 - Queen's Adjacency
Neighbor2.nb.queen=poly2nb(Neighbor2,queen = TRUE)
Neighbor2.w.queen=nb2listw(Neighbor2.nb.queen,style = "B")
moran.test(Neighbor2@data$POP_ARR02,Neighbor2.w.queen)
geary.test(Neighbor2@data$POP_ARR02,Neighbor2.w.queen)

#plot Neighbor1 - Rook's & Queen's Adjacency
plot(Neighbor1,col="grey")
plot(Neighbor1.nb.rook,coords=coordinates(Neighbor1),add=T,col='blue',lwd=3)
title(main="Neighbor1 - Rook's Adjacency")
plot(Neighbor1,col="grey")
plot(Neighbor1.nb.queen,coords=coordinates(Neighbor1),add=T,col='red',lwd=3)
title(main="Neighbor1 - Queen's Adjacency")
#plot Neighbor2 - Rook's & Queen's Adjacency
plot(Neighbor2,col="grey")
plot(Neighbor2.nb.rook,coords=coordinates(Neighbor2),add=T,col='blue',lwd=3)
title(main="Neighbor2 - Rook's Adjacency")
plot(Neighbor2,col="grey")
plot(Neighbor2.nb.queen,coords=coordinates(Neighbor2),add=T,col='red',lwd=3)
title(main="Neighbor2 - Queen's Adjacency")

#plot Neighbor1 - POP_ARR02
map1 = ggplot()+geom_polygon(data=Neighbor1,aes(x=long,y=lat,group=group,color=I("black"),fill=I("lightgrey")),alpha = 0.8)
map1 = map1+geom_text(aes(x=coordinates(Neighbor1)[,1],y=coordinates(Neighbor1)[,2]),position = "identity",label=Neighbor1$POP_ARR02,color="red",cex=2.5)
map1 = map1+labs(title="Neighbor1")
map1 = map1+theme(plot.title = element_text(hjust=0.5,vjust=0.5,face="bold",size = 13.5),plot.subtitle = element_text(hjust=0.5,vjust=0.5))
map1
#plot Neighbor2 - POP_ARR02
map2 = ggplot()+geom_polygon(data=Neighbor2,aes(x=long,y=lat,group=group,color=I("black"),fill=I("lightgrey")),alpha = 0.8)
map2 = map2+geom_text(aes(x=coordinates(Neighbor2)[,1],y=coordinates(Neighbor2)[,2]),position = "identity",label=Neighbor2$POP_ARR02,color="red",cex=2.5)
map2 = map2+labs(title="Neighbor2")
map2 = map2+theme(plot.title = element_text(hjust=0.5,vjust=0.5,face="bold",size = 13.5),plot.subtitle = element_text(hjust=0.5,vjust=0.5))
map2
