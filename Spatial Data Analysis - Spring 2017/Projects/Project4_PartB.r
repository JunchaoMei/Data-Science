# Part_B

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
Crime <- readOGR(dsn="G:/GIS/Project4/Crime_PA2002", layer="Crime_PA2002")
summary(Crime)
plot(Crime)
nrow(Crime)

## global G

#Rook's Adjacency
Crime.nb.rook=poly2nb(Crime,queen = FALSE)
Crime.w.rook=nb2listw(Crime.nb.rook,style = "B")
globalG.test(Crime@data$BURG01,Crime.w.rook)

#Queen's Adjacency
Crime.nb.queen=poly2nb(Crime,queen = TRUE)
Crime.w.queen=nb2listw(Crime.nb.queen,style = "B")
globalG.test(Crime@data$BURG01,Crime.w.queen)


## GWR

#get [X] & [Y]
x1 = Crime@data$POP_CRI01
x2 = Crime@data$AG_CRI01
x3 = Crime@data$Area
y = Crime@data$INDEX01

#generate the inverse Euclidean distance matrix
Crime.dists = as.matrix(dist(coordinates(Crime)))
Crime.dists.inv <- 1/Crime.dists
diag(Crime.dists.inv) <- 0

#get the index
COUNTY=as.vector(Crime@data$COUNTY)
index = which(COUNTY == "Mifflin County", arr.ind = T)

#get weights
w <- array(0,dim=67)
for (i in 1:67)
{
  w[i] = sqrt(Crime.dists.inv[index+1,i])
}

#regression
model=lm(y~x1+x2+x3,weights=w)
model
summary(model)
plot(model)


#test
x1_Mifflin = x1[index]
x2_Mifflin = x2[index]
x3_Mifflin = x3[index]
y_calculate = 0.0585*x1_Mifflin-365.1344*x2_Mifflin-3080.3025*x3_Mifflin+579.6719
y_real = y[index]
error = abs(y_calculate-y_real)
error
y_calculate
y_real
