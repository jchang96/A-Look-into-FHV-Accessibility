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

df <- read.csv(file="H:/FHV Accessibility/Research Projects/A Look into For Hire Vehicles Accessibility/Data/Coordinates from Random Forest Model.csv", header=TRUE, sep=",")
df_june_2019 <- read.csv(file="I:/Special Projects/_Accessibility/FHV/_Indicators/WAV Dispatch/Data/fhv_wav_201906_run-2019_08_14_.csv", header=TRUE, sep=",")
df_june_2018 <- read.csv(file="I:/Special Projects/_Accessibility/FHV/_Indicators/WAV Dispatch/Data/fhv_wav_201806_2019-07-18.csv", header=TRUE, sep=",") 

################################################################
#             Data Cleaning
################################################################

# Convert long and lat to numeric
df$long <- as.numeric(as.character(df$long))
df$lat <- as.numeric(as.character(df$lat))

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

# Load water boundaries data
shape_files_3 <- "H:/FHV Accessibility/WAV Dispatch/Plots/Shape Files 3"
nyc_Water <- readOGR(dsn=shape_files_3, layer="nyu_2451_34516")
nyc_Water$awater_num <- as.numeric(as.character(nyc_Water$awater))
nyc_Water <- subset(nyc_Water, awater_num > 1000000)
nyc_Water <- spTransform(nyc_Water, CRS("+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"))

# Load taxi zones data
shape_files <- "H:/FHV Accessibility/WAV Dispatch/Plots/Shape Files"
taxi_zones <- readOGR(dsn=shape_files, layer="taxi_zones")
taxi_zones <- st_as_sf(taxi_zones)

################################################################
#             Mapping: graph maps (ggmap)
################################################################

# June 2019 WAV trips
june_2019 <- ggmap(get_stamenmap(rbind(as.numeric(paste(geocode_OSM("New York City")$bbox))), zoom = 13, maptype = "terrain-background")) + 
  geom_point(data=df_june_2019, aes(x=Pickup_longitude, y=Pickup_latitude), color = "purple1", size=1, alpha=.25) +
  theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.background = element_rect(fill = 'white'),
        axis.text.x=element_blank(),
        axis.text.y=element_blank(),
        axis.ticks = element_blank()) +
  geom_polygon(data=borough_boundaries, aes(x=long, y=lat, group=group, fill=NA), color = "black", fill=NA, size=0.5) +
  labs(x=NULL, y=NULL, 
       title="Pickups in 2019",
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
  geom_point(data=df_june_2018, aes(x=Pickup_longitude, y=Pickup_latitude), color = "purple1", size=1.5, alpha=.5) +
  theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.background = element_rect(fill = 'white'),
        axis.text.x=element_blank(),
        axis.text.y=element_blank(),
        axis.ticks = element_blank()) +
  geom_polygon(data=borough_boundaries, aes(x=long, y=lat, group=group, fill=NA), color = "black", fill=NA, size=0.5) +
  labs(x=NULL, y=NULL, 
       title="Pickups in 2018",
       subtitle=NULL,
       caption=NULL) 

# Save map as png
ggsave(june_2018,
       filename = ("H:/FHV Accessibility/Research Projects/A Look into For Hire Vehicles Accessibility/Plots/June_2018.png"),
       width = 15,
       height = 10,
       dpi = 300)

################################################################
#             Mapping: zone maps (ggmap)
################################################################

# Check and eliminate the rows that don't have location information
df_june_2019 <- df_june_2019[!is.na(df_june_2019$Pickup_latitude),]
df_june_2019 <- subset(df_june_2019, Pickup_longitude!=0)

# Spatialize data
data_spatial <- df_june_2019 %>%
  st_as_sf(coords=c("Pickup_longitude", "Pickup_latitude"), crs = "+proj=longlat") %>%
  st_transform(crs=st_crs(taxi_zones))

points_in <- st_join(taxi_zones, data_spatial, left=T)

# Bring the data into the polygons
by_tract <- points_in %>%
  group_by(PUlocationID) %>%
  summarise(total=n())

# Create palettes for map
pal <- wes_palette("GrandBudapest1", 100, type = "continuous")

# Create choropleth map
zone_map <- ggplot() +
  geom_sf(data=by_tract, aes(fill = `total`), color=NA) +
  geom_sf(data=taxi_zones, fill=NA, color="black", size=0.1) +
  coord_sf(datum=NA) +
  scale_fill_gradientn(colours = pal) +
  theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        axis.ticks = element_blank(),
        panel.background = element_rect(fill = 'white'),
        axis.text.x=element_blank(),
        axis.text.y=element_blank()) +
  labs(x=NULL, y=NULL,
       title=NULL,
       subtitle=NULL,
       caption=NULL,
       fill="Legend")

# Save map as png
ggsave(zone_map_pickups,
       filename = ("H:/FHV Accessibility/Research Projects/A Look into For Hire Vehicles Accessibility/Plots/Zone Map.png"),
       width = 15,
       height = 10,
       dpi = 300)

################################################################
#             Mapping: pie charts (ggplot)
################################################################

# Create data frames for trips per borough
x <- data.frame("Borough" = c("Bronx","Brooklyn", "Manhattan", "Queens", "Staten Island"), "Trips" = c(1482,2228,3193,1509,22))

# Barplot
pickups <- ggplot(x, aes(x="", y=Trips, fill=Borough)) +
  geom_bar(width=1, stat="identity") +
  theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.background = element_rect(fill = 'white'),
        axis.ticks = element_blank(),
        axis.text.x=element_blank(),
        axis.text.y=element_blank(),
        axis.title.x=element_blank(),
        axis.title.y=element_blank(),
        legend.title = element_text(size = 18),
        legend.text = element_text( size = 15)) +
  labs(x=NULL, y=NULL,
       title=NULL,
       subtitle=NULL,
       caption=NULL)

# Pie Chart
pie <- pickups + coord_polar("y", start=0)

# Save map as png
ggsave(pie,
       filename = ("H:/FHV Accessibility/Research Projects/A Look into For Hire Vehicles Accessibility/Plots/Trips Pie Chart.png"),
       width = 15,
       height = 10,
       dpi = 300)

################################################################
#             Mapping: predictive maps (ggmap)
################################################################

# Create trip prediction map
heatmap <-  ggmap(get_stamenmap(rbind(as.numeric(paste(geocode_OSM("New York City")$bbox))), zoom = 13, maptype = "terrain-background")) +
  stat_density2d(data=df, aes(x=long, y=lat, fill = ..level.., alpha = ..level..), geom = "polygon", bins = 50) +
  scale_fill_gradient(low="blue", high="red") +
  geom_polygon(data=nyc_Water, aes(x=long, y=lat, group=group), fill = '#99b3cc', size=0.75) +
  geom_polygon(data=borough_boundaries, aes(x=long, y=lat, group=group), color = "black", fill=NA, size=0.75) +
  scale_size(range=c(5,20)) +
  theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.background = element_rect(fill = 'white'),
        axis.text.x=element_blank(),
        axis.text.y=element_blank(),
        axis.ticks = element_blank(),
        legend.position="none") +
  labs(x=NULL, y=NULL, 
       title="FHV Accessibility Demand Prediction",
       subtitle=NULL,
       caption=NULL) +
  guides(alpha=FALSE)

# Save map as png
ggsave(heatmap,
       filename = ("H:/FHV Accessibility/Research Projects/A Look into For Hire Vehicles Accessibility/Plots/Trip Prediction.png"),
       width = 15,
       height = 10,
       dpi = 300)
