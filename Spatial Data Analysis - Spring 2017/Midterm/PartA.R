#import libraries
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
setwd("G:/GIS/Midterm")
list.files()
dir()

#Read shapefile (comment out alternatively)
   ShapeFile <- readOGR(dsn="G:/GIS/Midterm/PACoals", layer="PACoals")
  #ShapeFile <- readOGR(dsn="G:/GIS/Midterm/PALocs", layer="PALocs")
summary(ShapeFile)
#using nrow() to calculate the number of points in this dataset
n <-nrow(ShapeFile)
#convert dataset to spatialopints dataset
ShapeFile_SP <- as(ShapeFile, "SpatialPoints")
#convert to point pattern dataset
ShapeFile_ppp <- as(ShapeFile,"ppp")

#define 10*10=100 quadrats
a=10
b=10
x=a*b
window=as.owin(ShapeFile_ppp)
dataset <- data.frame(quadratcount(ShapeFile_ppp,a,b))
#get size of a single quadrat
range_x=window$xrange
range_y=window$yrange
total_x=range_x[2]-range_x[1]
total_y=range_y[2]-range_y[1]
single_x=total_x/a
single_y=total_y/b

#plot points
plot(ShapeFile, pch=20, col="grey", main=NULL)
#add title (comment out alternatively)
  #title(main="PALocs")
  title(main="PACoals")
#eval: values of events K
eval=c(1)[-1]

#plot quadrats
for (m in 1:x)
{
  x_rand = runif(1,range_x[1],range_x[2]-single_x)
  y_rand = runif(1,range_y[1],range_y[2]-single_y)
  tempWindow = owin(c(x_rand, x_rand+single_x),c(y_rand, y_rand+single_y))
  rand_sq = quadratcount(ShapeFile_ppp,xbreaks = c(window$xrange[1],tempWindow$xrange[1],tempWindow$xrange[2],window$xrange[2]), ybreaks = c(window$yrange[1],tempWindow$yrange[1],tempWindow$yrange[2],window$yrange[2]))
  eval=c(eval,rand_sq[5])
  plot(tempWindow, add = T)
}# end for loop m

#build data frame
evalue = data.frame(K=c(NA),X=c(NA))[-1,]
#get values of K & X
for (m in 0:n)
{
  j=0
  j=nrow(dataset[eval == m,])
  if(j != 0)
    evalue=rbind(evalue,data.frame(m,j)) 
}
e2 = c(1)[-1]
e3 = c(1)[-1]
e4 = c(1)[-1]
#get values of 'K-μ', '(K-μ)^2', 'X*(K-μ)^2'
p = nrow(evalue)
μ = n/x
for (m in 1:p)
{ #K-μ
  ev2 = evalue[m,1] - μ
  e2 =c(e2,ev2)
  #(K-μ)^2
  ev3 = (evalue[m,1] - μ)^2
  e3 = c(e3,ev3)
  #X*(K-μ)^2
  ev4 = evalue[m,2]*ev3
  e4 = c(e4,ev4)
}

#build table
df<-data.frame(evalue$m,evalue$j,e2,e3,e4)
colnames(df) = c('No. of Events (K)','Number of Quadrats (X)', 'K-μ', '(K-μ)^2', 'X*(K-μ)^2')
kable(df, caption = 'Table with Statistics')

#Calculate VMR
sum_e4 = sum(df$`X*(K-μ)^2`)
s2 = sum_e4/(x-1) #variance
VMR=s2/μ
n
x
μ
s2
VMR