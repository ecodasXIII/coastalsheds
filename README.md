# coastalsheds

Making shapefiles for points in the NARS coastal dataset. General approach is to use the USGS Watershed boundary dataset (WBD) at the highest resolution that is available nationally, HUC-12s. Each sampling point was associated with the HUC-12 it is located in, or the nearest HUC-12 for those points farther offshore than the extent of the WBD, as well as all its upstream HUC-12s.

Where sampling points were located in one of the Great Lakes, this approach creates very large watersheds because the entire lake and all of the watersheds flowing into it are captured. Artificial "shoreline" points were created to identify the HUC-12 on the closest shoreline and all of its upstream HUC-12s. 

## Files 

* `01-load-data.Rmd` makes a shapefile called ncaa_coords_sf that has a consistent coordinate reference system, assuming WGS84 for not reported
* `02-get-huc12shed.Rmd` uses the watershed boundary dataset to identify the HUC-12 the point is located in and all upstream HUC 12s, and saves a shapefile for each using the site ID. One shapefile saved with individual HUC 12s and one with them all unioned. 
* `map.Rmd` combines shapefiles for each point and plots. Generates png maps using open street map tiles as background. 

## Issues

* Points falling in HUC 12s of the great lakes were adjusted to find the HUC12 (and any upstream) associated with the closest shoreline point. Closest shoreline points were identified by buffering the lake polygon 500m, converting to a linestring, and finding the point on the linestring closest to the original sampling point. Frontal watersheds around lakes complicate this procedure, as the frontal watersheds surround most of the lake at a varying distance. So, frontal watersheds and lake polygons were merged where this appeared to be an issue (Lake Huron, Lake Erie, Lake Superior, Lake Ontario; not for Lake Michigan where it seems frontal watersheds do not circle the entire lake)
* Some HUC-12s are multiple individual polygons, especially around lakes. Unsure why this is but it seems associated with river mouths splitting the input.  
* Delaware bay, long island sound may need the same approach as great lakes. 
* There is another lake superior frontage watershed that needs to be accounted for
* The pngs for evaluating watersheds are generated with background tiles from the extent of the HUC12shed, but the extent should also include the sampling point. 