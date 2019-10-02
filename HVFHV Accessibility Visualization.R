################################################################
# Author: Jean Chang
# Date created: 10/2/2019
# Purpose: Create a report about FHV accessibility for Medium
################################################################


################################################################
#             Clean up and set up
################################################################
# clean up
rm(list=ls())
graphics.off()

# load packages
library(ggplot2)
library(ggmap)
library(rgdal)
library(tmaptools)
library(sf)
library(tidyverse)
library(wesanderson)

# set working directory
loc = "H:/FHV Accessibility/Research Projects/A Look into For Hire Vehicles Accessibility"
setwd(loc)

################################################################
#             Read csv into R
################################################################

preq_coords <- read.csv(file="H:/FHV Accessibility/Research Projects/A Look into For Hire Vehicles Accessibility/Data/HVFHV Accessibility Predictive Coordinates.csv", header=TRUE, sep=",")

################################################################
#             Data Cleaning
################################################################

# Convert long and lat to numeric
preq_coords$Pickup_longitude <- as.numeric(as.character(preq_coords$Pickup_longitude))
preq_coords$Pickup_latitude <- as.numeric(as.character(preq_coords$Pickup_latitude))

################################################################
#             Load Shape Files
################################################################

# Load borough boundaries data
shape_files_1 <- "H:/FHV Accessibility/WAV Dispatch/Plots/Shape Files 2"
borough_boundaries <- readOGR(dsn=shape_files_1, layer="borough_boundaries")

# Load water boundaries data
shape_files_2 <- "H:/FHV Accessibility/WAV Dispatch/Plots/Shape Files 3"
nyc_Water <- readOGR(dsn=shape_files_2, layer="nyu_2451_34516")
nyc_Water$awater_num <- as.numeric(as.character(nyc_Water$awater))
nyc_Water <- subset(nyc_Water, awater_num > 1000000)
nyc_Water <- spTransform(nyc_Water, CRS("+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"))

################################################################
#             Mapping: plot map (ggmap)
################################################################

# Plot result from random forest model
preq_map <- ggmap(get_stamenmap(rbind(as.numeric(paste(geocode_OSM("New York City")$bbox))), zoom = 13, maptype = "terrain-background")) + 
  stat_density2d(data=preq_coords, aes(x=Pickup_longitude, y=Pickup_latitude, fill = ..level.., alpha = ..level..), geom = "polygon", bins = 50) +
  scale_fill_gradient(low="steelblue", high="indianred", name="Legend", breaks=c(40,80,120,160,200,240), limits=c(1,280)) +
  theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.background = element_rect(fill = 'white'),
        axis.text.x=element_blank(),
        axis.text.y=element_blank(),
        axis.ticks = element_blank(),
        plot.title = element_text(size = 30, face = 'bold', hjust = 0.5)) +
  geom_polygon(data=nyc_Water, aes(x=long, y=lat, group=group), fill = '#99b3cc', size=0.75) +
  geom_polygon(data=borough_boundaries, aes(x=long, y=lat, group=group, fill=NA), color = "black", fill=NA, size=0.5) +
  labs(x=NULL, y=NULL, 
       title='Trip Demand Forecast',
       subtitle=NULL,
       caption=NULL) +
  guides(alpha=FALSE)

# Save map as png
ggsave(preq_map,
       filename = ("H:/FHV Accessibility/Research Projects/A Look into For Hire Vehicles Accessibility/Plots/Trip_Forecast.png"),
       width = 15,
       height = 10,
       dpi = 300)