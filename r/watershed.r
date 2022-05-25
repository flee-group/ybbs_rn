library(WatershedTools)
library(raster)
library(sf)

dem = raster("data/dhm_at_lamb_10m_2018_epsg3035.tif")
stream = stack("output/ybbs.grd")
catch_area = raster("output/catchment.tif")
vv = st_read("output/ybbs.gpkg")
dem = crop(dem, catch_area)
stream = crop(stream, catch_area)
ol = stream$id
ol = stack(ol)
names(ol) = "pixel_id"

y_ws = Watershed(stream$stream, stream$drainage, dem, stream$accum, catch_area, 
	otherLayers = ol)

# distance to outlet for all pixels
y_ws$data$dist = wsDistance(y_ws, outlets(y_ws)$id) / -1000
saveRDS(y_ws, "output/ybbs_ws.rds")


