# Task - Distance-Based Techniques

#import libraries
library(spatstat)
library(rgdal)
library(maptools)

#read shape files
OilGasLocationPA <- readOGR(dsn="G:/GIS/Project3/OilGasLocationPA", layer="OilGasLocationPA")
OGLPA_SP <- as(OilGasLocationPA,"SpatialPoints")
OGLPA_ppp <- as(OGLPA_SP,"ppp")
IndustrialMineralMiningPA <- readOGR(dsn="G:/GIS/Project3/IndustrialMineralMiningPA", layer="IndustrialMineralMiningOperations2014_10")
IMMPA_SP <- as(IndustrialMineralMiningPA,"SpatialPoints")
IMMPA_ppp <- as(IMMPA_SP,"ppp")

#G function
G_OGLPA <- Gest(OGLPA_ppp,correction="none")
plot(G_OGLPA[,-2],main="G Function of OilGasLocationPA",col="red")
G_IMMPA <- Gest(IMMPA_ppp,correction="none")
plot(G_IMMPA[,-2],main="G Function of IndustrialMineralMiningPA",col="red")

#F function
F_OGLPA <- Fest(OGLPA_ppp,correction="none")
plot(F_OGLPA[,-2],main="F Function of OilGasLocationPA",col="green")
F_IMMPA <- Fest(IMMPA_ppp,correction="none")
plot(F_IMMPA[,-2],main="F Function of IndustrialMineralMiningPA",col="green")

#K function
K_OGLPA <- Kest(OGLPA_ppp,correction="none")
plot(K_OGLPA[,-2],main="K Function of OilGasLocationPA",col="blue")
K_IMMPA <- Kest(IMMPA_ppp,correction="none")
plot(K_IMMPA[,-2],main="K Function of IndustrialMineralMiningPA",col="blue")

#L function
L_OGLPA <- Lest(OGLPA_ppp,correction="none")
plot(L_OGLPA[,-2],main="L Function of OilGasLocationPA",col="purple")
L_IMMPA <- Lest(IMMPA_ppp,correction="none")
plot(L_IMMPA[,-2],main="L Function of IndustrialMineralMiningPA",col="purple")