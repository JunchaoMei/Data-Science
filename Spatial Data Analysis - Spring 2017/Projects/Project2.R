#install packages
install.packages("sp")
install.packages("spdep")
install.packages("classInt")
install.packages("rgeos")
install.packages("maptools")
install.packages("rgdal")
install.packages("ggplot2")
install.packages("weights")
install.packages("ape") #This is will be used in your next homework for autoccorelation
install.packages("spatstat")
install.packages("GISTools")

library(sp)
library(spdep)
library(classInt)
library(rgeos)
library(maptools)
library(rgdal)
library(ggplot2)
library(weights)
library(ape)
library(spatstat)
library(knitr)
library(GISTools)

#Set workinbg directory
setwd("G:/GIS/Project2")
list.files()
dir()

#Read OilGasLocationPA shapefile
OilGasLocationPA <- readOGR(dsn="G:/GIS/Project2/OilGasLocationPA", layer="OilGasLocationPA")
summary(OilGasLocationPA)
#convert dataset to spatialopints dataset
OilGasLocationPA_SP <- as(OilGasLocationPA, "SpatialPoints")
#convert to point pattern dataset
OilGasLocationPA_ppp <- as(OilGasLocationPA_SP,"ppp")

#Extracting the minimum and maximum values of coordinates for having the extent of the point features
minX<-min(OilGasLocationPA$coords.x1)
maxX<-max(OilGasLocationPA$coords.x1)
minY<-min(OilGasLocationPA$coords.x2)
maxY<-max(OilGasLocationPA$coords.x2)
window <- owin(xrange=c(minX,maxX),yrange=c(minY,maxY))

#1.regular quadrant sampling approach.

Q <- quadratcount(OilGasLocationPA_ppp, nx=13, ny=8)
plot(OilGasLocationPA, pch=".", col="grey", main=NULL)
plot(Q, add=TRUE)
title(main="Quadrant Count of OilGasLocationPA", sub="regular quadrant sampling approach")


#2.the random quadrant sample approach.

r_x=window$xrange
r_y=window$yrange
total_x=r_x[2]-r_x[1]  
total_y=r_y[2]-r_y[1]
single_x=total_x/10
single_y=total_y/10

plot(OilGasLocationPA, pch=".", col="grey", main=NULL)
event_value=c(1)
event_value=event_value[-1]


for (m in 1:104)
{
x_rand = runif(1,r_x[1],r_x[2]-single_x)
y_rand = runif(1,r_y[1],r_y[2]-single_y)
temp = owin(c(x_rand, x_rand+single_x),c(y_rand, y_rand+single_y))
rand_sq = quadratcount(OilGasLocationPA_ppp,xbreaks = c(window$xrange[1],temp$xrange[1],temp$xrange[2],window$xrange[2]), ybreaks = c(window$yrange[1],temp$yrange[1],temp$yrange[2],window$yrange[2]))
event_value=c(event_value,rand_sq[5])
plot(temp, add = T)
}# end for loop m