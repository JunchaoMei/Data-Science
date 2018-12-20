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

library(sp)
library(spdep)
library(classInt)
library(rgeos)
library(maptools)
library(rgdal)
library(ggplot2)
library(weights)
library(ape)

#Set workinbg directory
setwd("G:/GIS/Project1")
list.files()
dir()

#Read pghstreet shapefile
pghstreet <- readOGR(dsn="G:/GIS/Project1/pgh_streets", layer="pgh_streets")
#Fibd the total number of road segments and calculate the minimum, maximum, and mean
#segment lengths. Segment lengths are in miles.
summary(pghstreet)

#Filter out the segments tha are below the mean length
pghstreet.filtered <- pghstreet[pghstreet$LENGTH>mean(pghstreet$LENGTH),]
summary(pghstreet.filtered)
#Create a map showing the remaining segments
plot(pghstreet.filtered, lwd=1, col="black")
title(main="Pittsburgh Streets", sub="roads longer than mean")

#Load data
load("G:/GIS/Project1/lnd.RData")
load("stations.RData")
str(lnd)
summary(lnd)
str(stations)
summary(stations)
names(stations)
names(lnd)
plot(lnd)
plot(stations, add=T, col="red")

#For the variable "Value" in stations, find its mean
#value for the stations in each polygon
stations.m <- aggregate(stations[c("Value")], by=lnd, FUN=mean)
#Plot stations.m and shade each polygone based on the
#attribute "Value" (which is the mean of the "Value")
#for stations falling in each polygon)
q <- cut(stations.m$Value, breaks=c(quantile(stations.m$Value)),include.lowest=T)
summary(q)
clr <- as.character(factor(q,labels=paste0("gray",seq(20,80,20))))
plot(stations.m,col=clr)
legend(legend=paste0("q",1:4),fill=paste0("gray",seq(20,80,20)),"topright")

#This part is needed before regression
#Find the number of stations in each polygon
stations.c <- aggregate(stations,lnd,length)
stations.c@data[,1]#Shows the number of stations falling in each polygon
x <- rep.int(stations.m$Value,stations.c@data[,1])
str(x)
#Run a regression on the "Value" before and after the aggregation
reg.model <- lm(stations$Value~x)
summary(reg.model)
# P-value 统计中的P值