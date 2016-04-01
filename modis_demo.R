# BEGIN_COPYRIGHT
# 
# Copyright © 2014 Paradigm4, Inc.
# This script is used in conjunction with the Community Edition of SciDB.
# SciDB is free software: you can redistribute it and/or modify it under the terms of the Affero General Public License, version 3, as published by the Free Software Foundation.
#
# END_COPYRIGHT 

library("scidb")
library('ggplot2')
scidbconnect()

#Some demos using the NASA MODIS radar dataset

#Try to run this first with default arguments:
#>draw_regrid()
#An experienced geographer will recognize the feature in the middle
#Then try changing zoom, lat and lon
draw_regrid = function(lat          = 36.3,
                       lon          = -112.5,
                       zoom         = 2,
                       lat_start    = lat - zoom / 2,
                       lat_end      = lat + zoom / 2,
                       lon_start    = lon - zoom,
                       lon_end      = lon + zoom,
                       image_height = 300,
                       image_width  = image_height,
                       array_scale  = 10000,
                       array_name   = "MODIS_DATA")
{
  starting_lat <- -900000
  starting_lon <- -1800000
  if ( lat_end <= lat_start || lon_end <= lon_start)
  {
    stop("Incorrect lon/lat parameters.")
  }
  arr = scidb(array_name);
  lat1 = (lat_start * array_scale)
  lat2 = (lat_end * array_scale)
  long1 = (lon_start * array_scale)
  long2 = (lon_end * array_scale)
  arr = subset(arr, latitude_e4 >= lat1 & latitude_e4 <= lat2 & 
                 longitude_e4 >= long1 & longitude_e4 <= long2)
  arr = transform(arr, lat="latitude_e4 / 10000.0", lon="longitude_e4 / 10000.0")
  d_lat <- (lat_end * array_scale - lat_start * array_scale)
  d_lon <- (lon_end * array_scale - lon_start * array_scale)
  regrid_lat <- ceiling(d_lat / image_height)
  regrid_lon <- ceiling(d_lon / image_height)
  #Of course, if I were Google, I would store images at different resolutions.
  #This recomputes the image on the fly based on the desired zoom.
  arr = regrid(arr, grid=c(regrid_lat, regrid_lon), expr="avg(altitude) as alt, avg(lat) as lat, avg(lon) as lon")
  #This is where the download from SciDB to R happens
  arr = iquery(arr, return=TRUE)
  #And I am SURE this plot statement can be made to go faster - perhaps using ggraster.
  #Leaving it as an exercise for the reader.
  ggplot(arr, aes(lon, lat)) + 
    geom_point(aes(colour=alt)) + 
    scale_colour_gradientn(colours=terrain.colors(256)) + 
    theme_bw()
}

#View the data as-is before regridding
draw = function(lat = 36.5,
                lon = -112.5,
                image_height=250,
                image_width =image_height,
                array_name = "MODIS_DATA",
                array_scale = 10000)
{
  arr = scidb(array_name);
  lat1 = (lat * array_scale - image_height / 2)
  lat2 = (lat * array_scale + image_height / 2)
  long1 = (lon * array_scale - image_width / 2)
  long2 = (lon * array_scale + image_width  / 2)
  arr = subset(arr, latitude_e4 >= lat1 & latitude_e4 <= lat2 & 
                 longitude_e4 >= long1 & longitude_e4 <= long2)
  arr = iquery(arr, return=TRUE)
  ggplot(arr, aes(latitude_e4, longitude_e4)) + 
    geom_point(aes(colour=altitude)) + 
    scale_colour_gradientn(colours=terrain.colors(256)) + 
    theme_bw()
}

find_average_height = function (lat = 36.5,
                                lon = -112.5,
                                image_height=500,
                                image_width =500,
                                array_scale =10000,
                                array_name = "MODIS_DATA")
{
  arr = scidb(array_name)
  lat1 = (lat * array_scale - image_height / 2)
  lat2 = (lat * array_scale + image_height / 2)
  long1 = (lon * array_scale - image_width / 2)
  long2 = (lon * array_scale + image_width  / 2)
  arr = subset(arr, latitude_e4 >= lat1 & latitude_e4 <= lat2 & 
                 longitude_e4 >= long1 & longitude_e4 <= long2)
  return (aggregate(arr, FUN=mean)[]$altitude_avg)
}

#Just a little cuteness.
#Try running find_place('San Francisco')
find_place  = function( place_name,
                        zoom = 1,
                        image_width = 300, 
                        image_height = image_width,
                        places_array = "MODIS_PLACES") 
{
  condition = sprintf("FEATURE_CLASS='Populated Place' and FEATURE_NAME='%s'", place_name)
  places_array = scidb(places_array)
  place = subset(places_array, condition)[]
  if ( nrow(place) == 0 )
  {
    print("Not found");
    return();
  }
  lat = as.numeric(place$PRIM_LAT_DEC)
  lon = as.numeric(place$PRIM_LONG_DEC)
  elevation = find_average_height(lat, lon)
  elev_text = sprintf("%s: %0.2f, %0.2f Elevation: %0.2fm", place_name, lat, lon, elevation);
  print(elev_text)
  res=data.frame(la=lat,lo=lon, lab=elev_text)
  draw_regrid(lat,lon,zoom, image_width= image_width, image_height=image_height) + 
    geom_point(data=res) + geom_label(data=res, aes(label=lab),  nudge_y=-0.05)
}
