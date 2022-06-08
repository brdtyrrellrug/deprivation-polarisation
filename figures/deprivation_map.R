## NUTS_Level_2_(January_2015)_Boundaries used from https://geoportal.statistics.gov.uk/

rm(list=ls())
setwd("PATH")

library(maps)
library(mapdata)
library(maptools)
library(rgdal)
library(ggmap)
library(ggplot2)
library(rgeos)
library(broom)
library(plyr)
library(gridExtra)
library(grid)

## Import shapefile
shapefile <- readOGR(dsn="./Trends/NUTS2_shapefilesgen",
                     layer="NUTS_Level_2_(January_2015)_Boundaries")
mapdata <- tidy(shapefile, region="nuts215cd")

## Import data from year
data <- read.csv("complete-final.csv")

## Join datasets
colnames(data)[3] <- "id"
data$id <- toupper(data$id)
mapdata$id <- toupper(mapdata$id)
mapdatafull <- join(mapdata, data, by="id")

mapdata0 <- subset(mapdatafull, yearstart == 2005)
mapdata1 <- subset(mapdatafull, yearstart == 2017)

rng = range(c((mapdata0$deprivation), (mapdata1$deprivation)))


##### 2005 Plot #####

## Create map
gg0 <- ggplot() + geom_polygon(data = mapdata0, aes(x = long, y = lat, group = group,
                                                  fill = deprivation),
                              color = "#FFFFFF", size = 0.25)

gg0 <- gg0 + scale_fill_gradient2(low="#edf8b1", mid="#41b6c4", high="#0c2c84",
                                  midpoint=mean(rng),
                                  breaks=c(0.8,1,1.2,1.4),
                                  limits=c(rng[1], rng[2]))

gg0 <- gg0 + ggtitle("2005-2006")

gg0 <- gg0 + coord_fixed(1)
gg0 <- gg0 + theme_minimal()
gg0 <- gg0 + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), 
                   plot.title = element_text(hjust = 0.5), legend.position = 'bottom')
gg0 <- gg0 + theme(axis.title.x=element_blank(), axis.text.x = element_blank(), axis.ticks.x = element_blank())
gg0 <- gg0 + theme(axis.title.y=element_blank(), axis.text.y = element_blank(), axis.ticks.y = element_blank())

##### 2018 Plot #####

## Create map
gg1 <- ggplot() + geom_polygon(data = mapdata1, aes(x = long, y = lat, group = group,
                                                    fill = deprivation),
                               color = "#FFFFFF", size = 0.25)

gg1 <- gg1 + scale_fill_gradient2(low="#edf8b1", mid="#41b6c4", high="#0c2c84",
                                  midpoint=mean(rng),
                                  breaks=c(0.8,1,1.2,1.4),
                                  limits=c(rng[1], rng[2]))

gg1 <- gg1 + ggtitle("2017-2018")

gg1 <- gg1 + coord_fixed(1)
gg1 <- gg1 + theme_minimal()
gg1 <- gg1 + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), 
                   plot.title = element_text(hjust = 0.5),legend.position = 'bottom')
gg1 <- gg1 + theme(axis.title.x=element_blank(), axis.text.x = element_blank(), axis.ticks.x = element_blank())
gg1 <- gg1 + theme(axis.title.y=element_blank(), axis.text.y = element_blank(), axis.ticks.y = element_blank())


##### Print plots #####

grid.arrange(gg0, gg1, ncol=2, top=textGrob("Relative Economic Deprivation, England & Wales",gp=gpar(fontsize=18)))
