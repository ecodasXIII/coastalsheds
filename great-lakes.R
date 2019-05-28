
# great lakes options for points that are in the huc12s of the great lakes

# ncaa_siteID <- ncaa_siteIDs_toget[30]
ncaa_siteID <- ncaa_siteIDs_GL[20]

my_ncaa_pt <- dplyr::filter(ncaa_coords_sf_prj, SITE_ == ncaa_siteID) %>% slice(1)
# mypt_id <- my_ncaa_pt$SITE_
mypt_id <- ncaa_siteID

huc2 <- st_read(file.path(data_dir_wbd, "wbdhu2_a_us_september2018.gdb")) %>% st_transform(4269)
my_huc2_mat <- st_contains(huc2, my_ncaa_pt, sparse = FALSE)
my_huc2_id <- which(apply(my_huc2_mat, 1, any))
my_huc2 <- huc2[my_huc2_id,]
my_huc2_id <- my_huc2$HUC2 %>% as.character()
# if point is not within any HUC2s then need to find closest
if(length(my_huc2_id)==0){
  my_huc2 <- huc2[which.min(st_distance(my_ncaa_pt, huc2)),]
  my_huc2_id <- my_huc2$HUC2 %>% as.character()
}

# read in the corresponding huc 12s
huc12_filepath <- file.path(data_dir_wbd, sprintf("Shape_%s/Shape/WBDHU12.shp", my_huc2_id))
huc12 <- st_read(huc12_filepath) %>% st_transform(4269)

# find which huc 12 point is in
my_huc12_mat <- st_contains(huc12, my_ncaa_pt, sparse = FALSE)
my_huc12_id <- which(apply(my_huc12_mat, 1, any))
my_huc12 <- huc12[my_huc12_id,]
my_huc12_id <- my_huc12$HUC12 %>% as.character()
# if not within HUC12s then find closest
if(length(my_huc12_id)==0){
  my_huc12 <- huc12[which.min(st_distance(my_ncaa_pt, huc12)),]
  my_huc12_id <- my_huc12$HUC12 %>% as.character()
}
my_huc12 
my_huc12_id
# variable for whether point is in a great lake huc 12
# huc12 %>% arrange(desc(Shape_Area)) %>% head()
my_huc12_GL <- my_huc12_id %in% c("041800000300", # Lake superior
                                  "042400000300", # Lake Huron
                                  "041900000002", # Lake Michigan
                                  "042600000300", # Lake Erie
                                  "041502000200", # Lake Ontario
                                  "041502000100", # Frontal Lake Ontario
                                  "042600000200" # Frontal lake eries
                                  )
if(my_huc12_id %in% c("042600000300", "042600000200")){
  # combine lake erie and frontal lake erie
  my_huc12 <- st_union(filter(huc12, HUC12 == "042600000300"), 
                       filter(huc12, HUC12 == "042600000200"))
}
if(my_huc12_id %in% c("041502000200", "041502000100")){
  # combine lake ontario and frontal lake ontario
  my_huc12 <- st_union(filter(huc12, HUC12 == "041502000200"), 
                       filter(huc12, HUC12 == "041502000100"))
}
# my_huc12_GL

if(my_huc12_GL){
  # find the point on the outside of the 10m buffered lake polygon that is closest to the point
  my_huc12_ls <- my_huc12 %>% 
    st_transform(5070) %>% st_buffer(500) %>% st_transform(4269) %>%
    st_cast("POLYGON") %>% st_cast("MULTILINESTRING") # convert to line
  shoreline_pt <- st_nearest_points(my_huc12_ls, my_ncaa_pt) %>% st_cast("POINT")
  shoreline_pt_sf <- st_sf(id = 1:2, shoreline_pt)[1,]
  
  my_huc12_mat <- st_contains(huc12, shoreline_pt_sf, sparse = FALSE)
  my_huc12_id <- which(apply(my_huc12_mat, 1, any))
  my_huc12 <- huc12[my_huc12_id,]
  my_huc12_id <- my_huc12$HUC12 %>% as.character()
}
# plot(my_huc12_ls$geometry)
my_huc12_id

leaflet() %>%
  addTiles() %>%
  addMarkers(data = shoreline_pt_sf, popup = ~id) %>%
  addPolylines(data = my_huc12, opacity = 1) %>%
  # addPolygons(data = my_huc12_buff1, color = "green", opacity = 1, fillOpacity = 0) %>%
  # addPolygons(data = upstream_huc12s_sf_union) %>%
  addMarkers(data = my_ncaa_pt) %>% addMeasure(primaryLengthUnit = "meters")

plot(my_huc12$geometry)
