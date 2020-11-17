#### Author: Alexander Abuabara
#### Date: 2020 November 17
#### Project: TxGISday2020
#### Available at: https://github/abuabara/TxGISday2020

setwd("/Users/alexander/Library/Mobile Documents/com~apple~CloudDocs/R/GISday2020/Tue_R/")

###### RASTER ######

###### Slide 19 - Creating Raster objects from scratch ###### 
library(raster)

r <- raster(ncol=10, nrow=10)
ncell(r)
hasValues(r)
values(r) <- 1:ncell(r)
set.seed(0)
values(r) <- runif(ncell(r))
hasValues(r)
inMemory(r)
values(r)[1:10]
plot(r, main='Raster with 100 cells')

###### Slide 20 - Raster algebra ######
r
values(r)[1:10]
s <- r + 10
values(s)[1:10]
s <- sqrt(s)
values(s)[1:10]
s <- s * r + 5
values(s)[1:10]
r[] <- runif(ncell(r))
values(r)[1:10]
r <- round(r)
values(r)[1:10]
r <- r == 1
values(r)[1:10]

###### Slide 21 - Raster histogram ######
hist(s,
     main="Distribution of Raster Data\n Histogram of 10x10 pixels values",
     xlab="Elevation Value (m)",
     ylab="Frequency",
     col="wheat")

###### Slide 22 - Multiple layers ######
r <- raster(ncol=10, nrow=10)
r[] <- runif(ncell(r))
s <- stack(r, r+1)
q <- stack(r, r+2, r+4, r+6)
x <- r + s + q
x
plot(x, main='Stack of rasters')

###### Slide 24 - Multiple layers ######
b <- brick(system.file("external/rlogo.grd", package="raster"))
plot(b)
plotRGB(b, r=1, g=2, b=3)

###### Slide 25 - Summary functions ######
?mean
mean(0:10)

a <- mean(r,s)
values(a)[1:10]

b <- sum(r,s)
values(b)[1:10]

st <- stack(r, s, a, b)
sst <- sum(st)
values(sst)[1:10]

cellStats(st, "sum")
cellStats(sst, "sum")

###### Spatial vector data ######

###### Slide 32 - Basics ######
library(tidyverse)
library(sf)

###### Slide 33 - Line example ######
storms_xyz_feature <- system.file("shape/storms_xyz_feature.shp", package="sf") %>%
   st_read() %>%
   st_as_sf()

plot(storms_xyz_feature, graticule = TRUE, axes = TRUE)

# or
# ggplot(storms_xyz_feature) +
#    geom_sf(aes(color = Track))

###### Slide 34 - Polygon example ######
nc <- system.file("shape/nc.shp", package="sf") %>%
   st_read() %>%
   st_as_sf()

plot(nc$geometry, graticule = TRUE, axes = TRUE)

###### Slide 35 - Attributes ######
plot(nc, graticule = TRUE, axes = TRUE)

###### Slide 36 - ggplot ######
ggplot(nc) +
   geom_sf(aes(fill = NAME))

###### Slide 37 & 38- Dissolve features ######
nc %>%
   group_by() %>%
   summarise() %>%
   # plot(graticule = TRUE, axes = TRUE)
   ggplot() +
   geom_sf(fill = "#4B9CD3",
           color = "red")

###### Slide 39 - Filter attributes ######
nc %>%
   filter(NAME %in% c("Alexander", "Beaufort", "Lee", "Jackson", "Washington")) %>%
   ggplot() +
   geom_sf(aes(fill = NAME))

###### Mapping ######

###### Slide 41 - ggplot ######
ggplot() +
   geom_sf(data = nc,
           fill = "#4B9CD3", alpha = 0.2,
           color = "black") +
   geom_sf(data = nc %>%
              filter(NAME %in% c("Alexander", "Beaufort", "Lee", "Jackson", "Washington")),
           aes(fill = NAME)) +
   labs(title = "North Caroline Counties",
        legend = "Selected Counties") +
   theme_minimal()

###### Slide 42 - ggplot ######
ggplot() +
   geom_sf(data = nc %>%
              group_by() %>%
              summarise(),
           fill = "#4B9CD3", alpha = 0.2,
           color = "red") +
   geom_sf(data = nc %>%
              filter(NAME %in% c("Alexander", "Beaufort", "Lee", "Jackson", "Washington")),
           aes(fill = NAME)) +
   labs(title = "North Caroline Counties",
        legend = "Selected Counties") +
   theme_minimal()

###### Slide 43 - ggplot ######
library(maps)

some_point <- data.frame(longitude = c(-96.30),
                         latitude  = c(30.63))

us <- st_as_sf(map("state", plot = FALSE, fill = TRUE))
us

class(us)

ggplot(data = us) +
   geom_sf()

###### Slide 44 - ggplot ######
ggplot() +
   geom_sf(data = us) +
   geom_sf(data = us %>% filter(ID == "texas"), fill = "gold") +
   geom_point(data = some_point,
              aes(x = longitude, y = latitude),
              size = 4, shape = 23, fill = "darkred")

###### Slide 45 - leaflet ######
library(leaflet)

TxGIS = c("TAMU College Station")

leaflet() %>%
   addProviderTiles("OpenStreetMap.Mapnik") %>% # OpenStreetMap.Mapnik NASAGIBS.ViirsEarthAtNight2012
   addMarkers(lng = some_point$longitude,
              lat = some_point$latitude, 
              popup = TxGIS)

###### Walking, Cycling, and Driving Distances ######

###### Step 1 install libraries and obtain a API ######
# To get started, sign up for a Mapbox account and generate an access token.
# Set your public or secret token for use in the package with mb_access_token():
# Once you’ve set your token, you are ready to get started using the package.
# https://docs.mapbox.com/api/
# https://account.mapbox.com

###### Slide 48 - leaflet ######
# remotes::install_github("walkerke/mapboxapi")
library(mapboxapi)
# mb_access_token("pk.ey...", install = TRUE)
# library(sf)
# library(ggplot2)
# library(tidyverse)

###### Slide 49 - Step 2 geocode an address ######
address <- "Texas A&M University, Langford Architecture Bldg 3137, College Station, TX 77843"
address <- c(-96.301250, 30.624556)

walk_5min <- mb_isochrone(address,
                          profile = "walking",
                          time = 5)

bike_5min <- mb_isochrone(address,
                          profile = "cycling",
                          time = 5)

drive_5min <- mb_isochrone(address,
                           profile = "driving",
                           time = 5)

###### Slide 50 - Step 2 geocode an address ######
library(ggmap)
library(gridExtra)

bbox = c(left = as.numeric(st_bbox(drive_5min)$xmin-0.05),
         bottom = as.numeric(st_bbox(drive_5min)$ymin-0.025),
         right = as.numeric(st_bbox(drive_5min)$xmax+0.05),
         top = as.numeric(st_bbox(drive_5min)$ymax+0.025))

map <- get_stamenmap(bbox,
                     maptype = "toner-2011",
                     zoom = 13)

theme_set(theme_bw())

###### Slide 51 - Step 3: pick a basemap ######
ggmap(map) +
   theme_void() +
   theme(plot.title = element_text(colour = "orange"), 
         panel.border = element_rect(colour = "black",
                                     fill = NA, size = .7))

###### Slide 52 - Step 4: the distance map ######
ggmap(map) +
   geom_sf(data = drive_5min,
           aes(fill = "driving"),
           color = "white", alpha=0.6, linetype = "blank",
           show.legend = TRUE, inherit.aes = FALSE) +
   geom_sf(data=bike_5min,
           aes(fill="cycling"),
           color="white", alpha=0.8, linetype = "blank",
           show.legend = TRUE, inherit.aes = FALSE) +
   geom_sf(data=walk_5min,
           aes(fill="walking"),
           color="white", alpha=0.7, linetype = "blank",
           show.legend = TRUE, inherit.aes = FALSE) +
   scale_fill_manual(values = c("walking" = "green",
                                "cycling" = "blue2",
                                "driving" = "red"),
                     breaks =  c("walking", "cycling", "driving")) +
   labs(x="",
        y="",
        title="5-minute time-distances",
        fill="") +
   theme(legend.justification="left",
         panel.background=element_rect(fill="grey", colour="grey", size=0.5, linetype="solid"),
         panel.grid.major=element_line(size=0.2, linetype="solid", colour="white"), 
         panel.grid.minor=element_line(size=0.2, linetype="solid", colour="white")) # -> temp2

# ggsave("Example_5_min_dist.png")

###### Slide 53 - Step 5: an interactive Leaflet map ######
leaflet(walk_5min) %>%
   addMapboxTiles(style_id = "streets-v11",
                  username = "mapbox") %>%
   addPolygons()

###### Slide 54 - Step 6: a more complex interactive Leaflet map ######
leaflet() %>%
   addMapboxTiles(style_id = "streets-v11",
                  username = "mapbox") %>%
   addProviderTiles(providers$Stamen) %>% # Stamen Stamen.Toner Stamen.TonerHybrid OpenTopoMap Esri.WorldImagery
   addPolygons(data = drive_5min, color = "red", group = "Driving") %>%
   addPolygons(data = bike_5min, color = "green", group = "Cycling") %>%
   addPolygons(data = walk_5min, color = "blue", group = "Walking") %>%
   addLayersControl(overlayGroups = c("Driving", "Cycling", "Walking"),
                    options = layersControlOptions(collapsed = FALSE)) # -> m

###### Slide 54 - Step 7: save it ######
library(htmlwidgets)
# saveWidget(m, file="m.html")

library(webshot)
# webshot("m.html", file = "Rplot1.png", cliprect = "viewport")

###### Elevation Analysis ######

###### Slide 61 - Step 1: Load packages and define a boundary box ######
if(!require(pacman)){install.packages("pacman"); library(pacman)}
p_load(dplyr, elevatr, haven, lwgeom, maps, raster, rgdal, rgeos, sf, sp, tigris)

bbox
aux <- as.numeric(bbox)
e <- as(raster::extent(aux[1], aux[3], aux[2], aux[4]), "SpatialPolygons")
proj4string(e) <- st_crs(drive_5min)$proj4string
# proj4string(e) <- CRS("+proj=utm +zone=10 +datum=WGS84")

###### Slide 62 - Step 2: Get elevation ######
x <- get_elev_raster(e, prj=sp::proj4string(e), z=11, src="aws") # 1 to 14
plot(x)

###### Slide 63 - Step 3: 20 m elevation mask ######
min_value <- minValue(x)
maxValue(x)

x2 <- x

x2[x2 <= min_value] <- NA; x2[x2 >= (min_value + 20)] <- NA
plot(x2)

writeRaster(x, filename="elev_z12.tif", format="GTiff", overwrite=T)

###### Slide 64 - Step 4: 20 m elevation polygonized ######
x2_poly <- spex::polygonize(x2) %>% 
   group_by() %>%
   st_union() %>% 
   st_make_valid()

st_area(x2_poly)

plot(st_geometry(x2_poly), graticule=TRUE, axes=TRUE)

###### Slide 65 & 66 - Step 5: Plot ######
bbox = c(left = as.numeric(st_bbox(x2_poly)$xmin-0.05),
         bottom = as.numeric(st_bbox(x2_poly)$ymin-0.025),
         right = as.numeric(st_bbox(x2_poly)$xmax+0.05),
         top = as.numeric(st_bbox(x2_poly)$ymax+0.025))

map <- get_stamenmap(bbox,
                     maptype = "toner-2011",
                     zoom = 12)

# ggplot() +
   ggmap(map) +
   geom_sf(data = x2_poly,
           aes(fill = "low areas"),
           color = "white", alpha = 0.6, linetype = "blank",
           show.legend = TRUE, inherit.aes = FALSE) +
   geom_sf(data = drive_5min,
           aes(fill = "driving distance"),
           color = "white", alpha = 0.6, linetype = "blank",
           show.legend = TRUE, inherit.aes = FALSE) +
   scale_fill_manual(values = c("driving distance" = "red",
                                "low areas" = "blue"),
                     breaks =  c("driving distance",
                                 "low areas")) +
   labs(x="",
        y="",
        title="5-minute driving-distance and low areas",
        fill="") +
   theme(legend.justification="left",
         panel.background=element_rect(fill="grey", colour="grey", size=0.5, linetype="solid"),
         panel.grid.major=element_line(size=0.2, linetype="solid", colour="white"), 
         panel.grid.minor=element_line(size=0.2, linetype="solid", colour="white"))
