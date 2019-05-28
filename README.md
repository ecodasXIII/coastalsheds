# coastalsheds

Making shapefiles for points in the NARS coastal dataset. 

* `01-load-data.Rmd` makes a shapefile called ncaa_coords_sf that has a consistent coordinate reference system, assuming WGS84 for not reported
* `02-get-huc12shed.Rmd` uses the watershed boundary dataset to identify the HUC-12 the point is located in and all upstream HUC 12s, and saves a shapefile for each using the site ID. 
* `map.Rmd` combines shapefiles for each point and plots

**Issues**

* Great lakes points include the entire lake and are therefore artificially large. Consider separating points with "GL" in site ID to run separately, or if there is a way to use HUC Type for not including the entire lake.