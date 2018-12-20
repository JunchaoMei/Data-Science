# Task - Autocorrelation

#import libraries
library(ape)

#read table file
ozone <- read.table("G:/GIS/Project3/ozone.csv", sep=",", header=T)
head(ozone, n=10)
summary(ozone)

#generate the inverse Euclidean distance matrix
ozone.dists <- as.matrix(dist(cbind(ozone$Lon, ozone$Lat)))
ozone.dists.inv <- 1/ozone.dists
diag(ozone.dists.inv) <- 0
ozone.dists.inv[1:5, 1:5]

#calculate Moran's I
Moran.I(ozone$Av8top, ozone.dists.inv)