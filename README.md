# coastalsheds

Making shapefiles for points in the NARS coastal dataset. 

* `01-load-data.Rmd` makes a shapefile called ncaa_coords_sf that has a consistent coordinate reference system, assuming WGS84 for not reported
* `02-get-huc12shed.Rmd` uses the watershed boundary dataset to identify the HUC-12 the point is located in and all upstream HUC 12s, and saves a shapefile for each using the site ID. 
* `map.Rmd` combines shapefiles for each point and plots

Notes

* Points falling in HUC 12s of the great lakes were adjusted to find the HUC12 (and any upstream) associated with the closest shoreline point. Closest shoreline points were identified by buffering the lake polygon 500m. Frontal watersheds around lakes make this complicated. 