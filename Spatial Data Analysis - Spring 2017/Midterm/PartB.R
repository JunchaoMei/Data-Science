library(spatstat)
library(lattice)

#Read shapefile
PALocs <- readOGR(dsn="G:/GIS/Midterm/PALocs", layer="PALocs")
PACoals <- readOGR(dsn="G:/GIS/Midterm/PACoals", layer="PACoals")

#G function
rG <- seq(from = 0, to = sqrt(2)/6, by = 0.005)
Genv_PALocs <- envelope(as(PALocs, "ppp"), fun=Gest, r=rG, nrank=2, nsim=99)
Genv_PACoals <- envelope(as(PACoals, "ppp"), fun=Gest, r=rG, nrank=2, nsim=99)
Gresults <- rbind(Genv_PALocs, Genv_PACoals) 
Gresults <- cbind(Gresults, DATASET=rep(c("PALocs", "PACoals"), each=length(rG)))
print(xyplot(obs~theo|y , data=Gresults, type="l", 
  panel=function(x, y, subscripts)
  {
   lpolygon(c(x, rev(x)), 
            c(Gresults$lo[subscripts], rev(Gresults$hi[subscripts])),
            border="gray", fill="gray"
   )
   
   llines(x, y, col="black", lwd=2)
  }
))
title(main="G Function")

#F function
rF <- seq(from = 0, to = sqrt(2)/6, by = 0.003)
Fenv_PALocs <- envelope(as(PALocs, "ppp"), fun=Fest, r=rF, nrank=2, nsim=99)
Fenv_PACoals <- envelope(as(PACoals, "ppp"), fun=Fest, r=rF, nrank=2, nsim=99)
Fresults <- rbind(Fenv_PALocs, Fenv_PACoals)
Fresults <- cbind(Fresults, DATASET=rep(c("PALocs", "PACoals"), each=length(rF)))
print(xyplot(obs~theo|y , data=Fresults, type="l", 
  panel=function(x, y, subscripts)
  {
   lpolygon(c(x, rev(x)), 
            c(Fresults$lo[subscripts], rev(Fresults$hi[subscripts])),
            border="gray", fill="gray"
   )
   
   llines(x, y, col="black", lwd=2)
  }
))
title(main="F Function")
