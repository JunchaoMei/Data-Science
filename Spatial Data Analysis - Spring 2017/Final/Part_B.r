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
library(gstat)

#read shape files
setwd("G:/GIS/DataFiles_FinalExam")
Community <- readOGR(dsn="2_Community", layer="2_Community")
nrow(Community)
summary(Community)
Community_data <- Community@data
Central_Locations <- coordinates(Community)
colnames(Central_Locations) <- c("long_central","lat_central")
Intensity_sample <- cbind(Community_data$Intensity,Community_data$S_Long,Community_data$S_Lat)
colnames(Intensity_sample) <- c("intensity","long","lat")
#convert [Intensity_sample] to SpatialPointsDataFrame
Intensity_sample <- as.data.frame(Intensity_sample)
coordinates(Intensity_sample) = ~long+lat
Intensity_sample@proj4string = Community@proj4string
#convert [Community] to SpatialPointsDataFrame
Community_sp <- SpatialPointsDataFrame(coordinates(Community), data = Community@data, proj4string = CRS(proj4string(Community)))
#create SpatialGridDataFrame
set.seed(888)
Community.grid = as.data.frame(spsample(Community,"regular",n=5000))
names(Community.grid)=c("long","lat")
coordinates(Community.grid)=c("long","lat")
gridded(Community.grid)=TRUE
fullgrid(Community.grid)=TRUE
Community.grid@proj4string=Community@proj4string


## OK

g.Intensity = gstat(id = "Intensity", formula = intensity ~ 1, data = Intensity_sample)
v.Intensity = fit.variogram(variogram(g.Intensity),vgm(1,"Exp",160,1))
ok.gstat = gstat(id="Intensity",formula = intensity ~ 1, data = Intensity_sample, model = v.Intensity)
#interpolation
ok.predict = predict(ok.gstat, Community_sp)
#plot
plot(Community)
plot(ok.predict["Intensity.pred"],add=T,pch=20)
title(main="OK intepolation - map")
spplot(ok.predict['Intensity.pred'])
#table
ok.result = ok.predict@data$Intensity.pred
ok.result.table = cbind(coordinates(ok.predict),ok.result)
colnames(ok.result.table) <- c("long","lat","ok.intensity.pred")
ok.result.table

#plot surface
ok.pred.surf=predict(ok.gstat,Community.grid)
ok.map=ggplot()+geom_tile(data=as.data.frame(ok.pred.surf),aes(x=long,y=lat,fill=Intensity.pred))
ok.map=ok.map+geom_path(data=Community,aes(x=long,y=lat,group=group),colour="grey",alpha = 0.8)
ok.map=ok.map+geom_point(data=as.data.frame(coordinates(Community)),aes(x=V1,y=V2),color="black")
ok.map=ok.map+labs(title="OK Surface")
ok.map=ok.map+geom_contour(data=as.data.frame(ok.pred.surf),aes(x=long,y=lat,z=Intensity.pred))
ok.map=ok.map+scale_fill_gradientn("Value",colors =rainbow(10))+coord_equal()
ok.map


## IDW

# different k - nearest neighbors

result.k = matrix(0, nrow = nrow(Intensity_sample), ncol = nrow(Intensity_sample))
diff.k = c()

for(i in 1:nrow(Intensity_sample))
{
  idw.gstat = gstat(id = "Intensity", formula = intensity ~ 1, data = Intensity_sample, set = list(idp = 1), nmax = i)
  idw.predict = predict(idw.gstat, Community_sp)
  pred = c(idw.predict@data$Intensity.pred)
  diff = 0
  for(j in 1:nrow(Intensity_sample))
  {
    result.k[i, j] = pred[j]
    diff = diff + abs(pred[j]-ok.result[j])
  }
  diff.k = c(diff.k, diff)
}

diff.k # k=12, mostly similar
idw.k.gstat = gstat(id = "Intensity", formula = intensity ~ 1, data = Intensity_sample, set = list(idp = 1), nmax = 12)
idw.k.predict = predict(idw.gstat, Community_sp)
#plot
plot(Community)
plot(idw.k.predict["Intensity.pred"],add=T,pch=20)
title(main="IDW intepolation (k=12) - map")
spplot(idw.predict["Intensity.pred"])
#table
idw.k.result = idw.k.predict@data$Intensity.pred
idw.k.result.table = cbind(coordinates(idw.k.predict),idw.k.result)
colnames(idw.k.result.table) <- c("long","lat","idw.k.intensity.pred")
idw.k.result.table
#plot surface
idw.k.pred.surf=predict(idw.k.gstat,Community.grid)
idw.k.map=ggplot()+geom_tile(data=as.data.frame(idw.k.pred.surf),aes(x=long,y=lat,fill=Intensity.pred))
idw.k.map=idw.k.map+geom_path(data=Community,aes(x=long,y=lat,group=group),colour="grey",alpha = 0.8)
idw.k.map=idw.k.map+geom_point(data=as.data.frame(coordinates(Community)),aes(x=V1,y=V2),color="black")
idw.k.map=idw.k.map+labs(title="IDW(k=12) Surface")
idw.k.map=idw.k.map+geom_contour(data=as.data.frame(idw.k.pred.surf),aes(x=long,y=lat,z=Intensity.pred))
idw.k.map=idw.k.map+scale_fill_gradientn("Value",colors =rainbow(10))+coord_equal()
idw.k.map

# different r - circle radius

result.r = matrix(0, nrow = length(seq(30,100,5)), ncol = nrow(Intensity_sample))
diff.r = c(nrow(seq(30,100,5)))

i = 1
for(r in seq(30,100,5))
{
  idw.gstat = gstat(id = "Intensity", formula = intensity ~ 1, data = Intensity_sample, set = list(idp = 1), maxdist = r * 1.0, nmin = 1, force = T)
  idw.predict = predict(idw.gstat, Community_sp)
  pred = c(idw.predict@data$Intensity.pred)
  diff = 0
  for(j in 1:nrow(Intensity_sample))
  {
    result.r[i, j] = round(pred[j], 2)
    diff = diff + abs(pred[j]-ok.result[j])
  }
  diff.r = c(diff.r, diff)
  i = i + 1
}

diff.r # r=95, diff.r->min
idw.r.gstat = gstat(id = "Intensity", formula = intensity ~ 1, data = Intensity_sample, set = list(idp = 1), maxdist = 95 * 1.0, nmin = 1, force = T)
idw.r.predict = predict(idw.r.gstat, Community_sp)
#plot
plot(Community)
plot(idw.r.predict["Intensity.pred"],add=T,pch=20)
title(main="IDW intepolation (r=95) - map")
spplot(idw.r.predict["Intensity.pred"])
#table
idw.r.result = idw.r.predict@data$Intensity.pred
idw.r.result.table = cbind(coordinates(idw.r.predict),idw.r.result)
colnames(idw.r.result.table) <- c("long","lat","idw.r.intensity.pred")
idw.r.result.table
#plot surface
idw.r.pred.surf=predict(idw.r.gstat,Community.grid)
idw.r.map=ggplot()+geom_tile(data=as.data.frame(idw.r.pred.surf),aes(x=long,y=lat,fill=Intensity.pred))
idw.r.map=idw.r.map+geom_path(data=Community,aes(x=long,y=lat,group=group),colour="grey",alpha = 0.8)
idw.r.map=idw.r.map+geom_point(data=as.data.frame(coordinates(Community)),aes(x=V1,y=V2),color="black")
idw.r.map=idw.r.map+labs(title="IDW(r=95) Surface")
idw.r.map=idw.r.map+geom_contour(data=as.data.frame(idw.r.pred.surf),aes(x=long,y=lat,z=Intensity.pred))
idw.r.map=idw.r.map+scale_fill_gradientn("Value",colors =rainbow(10))+coord_equal()
idw.r.map
