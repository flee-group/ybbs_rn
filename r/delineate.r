library(watershed)
library(terra)
library(raster)

dem = rast("data/dhm_at_lamb_10m_2018_epsg3035.tif")
ext = c(4680000, 4720000, 2740000, 2780000)
dem = crop(dem, ext)
outlet = c(4690462, 2756217)
ybbs = delineate(raster(dem), threshold = 1e5, outlet = outlet, reach_len = 500)

writeRaster(ybbs, file="output/ybbs.grd", overwrite = TRUE, gdal=c("COMPRESS=DEFLATE"))
