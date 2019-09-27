# R version: R-3.6.1

################################################################
# Author: Jean Chang
# Date Updated: 8/15/2019
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

df_june_2019 <- read.csv(file="H:/FHV Accessibility/Research Projects/A Look into For Hire Vehicles Accessibility/Data/2019-06_FHV_WAVs_on_the_road_2019-09-11_v01.csv", header=TRUE, sep=",")
df_june_2018 <- read.csv(file="H:/FHV Accessibility/Research Projects/A Look into For Hire Vehicles Accessibility/Data/2018-06_FHV_WAVs_on_the_road_2019-09-11_v01.csv", header=TRUE, sep=",") 

################################################################
#             Data Cleaning
################################################################

# Convert long and lat to numeric
df_june_2019$Pickup_longitude <- as.numeric(as.character(df_june_2019$Pickup_longitude))
df_june_2019$Pickup_latitude <- as.numeric(as.character(df_june_2019$Pickup_latitude))

df_june_2018$Pickup_longitude <- as.numeric(as.character(df_june_2018$Pickup_longitude))
df_june_2018$Pickup_latitude <- as.numeric(as.character(df_june_2018$Pickup_latitude))

################################################################
#             Load Shape Files
################################################################

# Load borough boundaries data
shape_files_2 <- "H:/FHV Accessibility/WAV Dispatch/Plots/Shape Files 2"
borough_boundaries <- readOGR(dsn=shape_files_2, layer="borough_boundaries")

################################################################
#             Mapping: graph maps (ggmap)
################################################################

# June 2019 WAV trips
june_2019 <- ggmap(get_stamenmap(rbind(as.numeric(paste(geocode_OSM("New York City")$bbox))), zoom = 13, maptype = "terrain-background")) + 
  geom_point(data=df_june_2019, aes(x=Pickup_longitude, y=Pickup_latitude), color = "indianred1", size=1, alpha=.25) +
  theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.background = element_rect(fill = 'white'),
        axis.text.x=element_blank(),
        axis.text.y=element_blank(),
        axis.ticks = element_blank(),
        plot.title = element_text(size = 15, face = 'bold', hjust = 0.5)) +
  geom_polygon(data=borough_boundaries, aes(x=long, y=lat, group=group, fill=NA), color = "black", fill=NA, size=0.5) +
  labs(x=NULL, y=NULL, 
       title='2019 Pickups',
       subtitle=NULL,
       caption=NULL) 

# Save map as png
ggsave(june_2019,
       filename = ("H:/FHV Accessibility/Research Projects/A Look into For Hire Vehicles Accessibility/Plots/June_2019.png"),
       width = 15,
       height = 10,
       dpi = 300)

# June 2018 WAV trips
june_2018 <- ggmap(get_stamenmap(rbind(as.numeric(paste(geocode_OSM("New York City")$bbox))), zoom = 13, maptype = "terrain-background")) + 
  geom_point(data=df_june_2018, aes(x=Pickup_longitude, y=Pickup_latitude), color = "indianred1", size=1.5, alpha=.5) +
  theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.background = element_rect(fill = 'white'),
        axis.text.x=element_blank(),
        axis.text.y=element_blank(),
        axis.ticks = element_blank(),
        plot.title = element_text(size = 15, face = 'bold', hjust = 0.5)) +
  geom_polygon(data=borough_boundaries, aes(x=long, y=lat, group=group, fill=NA), color = "black", fill=NA, size=0.5) +
  labs(x=NULL, y=NULL, 
       title='2018 Pickups',
       subtitle=NULL,
       caption=NULL) 

# Save map as png
ggsave(june_2018,
       filename = ("H:/FHV Accessibility/Research Projects/A Look into For Hire Vehicles Accessibility/Plots/June_2018.png"),
       width = 15,
       height = 10,
       dpi = 300)