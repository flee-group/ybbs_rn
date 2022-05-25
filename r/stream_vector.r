library(sf)
library(watershed)
library(raster)
library(data.table)

dem = raster("data/dhm_at_lamb_10m_2018_epsg3035.tif")
stream = stack("output/ybbs.grd")
corine = st_read("data/ybbs_lc.gpkg")
geo = st_read("data/ybbs_geo.gpkg")
geo = st_transform(geo, st_crs(corine))

Tp = pixel_topology(stream)
ybbs_rn = vectorise_stream(stream, Tp)
ybbs_rn$slope = river_slope(ybbs_rn, dem)

Tr = reach_topology(stream, Tp)
ybbs_rn$order = watershed::strahler(Tr)
# png("~/Desktop/ybbs.png", width = 1000, height = 1000)
# plot(st_geometry(ybbs_rn), lwd = ybbs_rn$order*0.5, col = 'blue')
# dev.off()

ybbs_lc = w_intersect(ybbs_rn, areas = corine, buff = 100,
            area_id = "code_18", drainage = stream$drainage)

ybbs_geo = w_intersect(ybbs_rn, areas = geo, buff = 100,
            area_id = "xx", drainage = stream$drainage)

ybbs_lc[, layer := "land_cover"]
ybbs_geo[, layer := "geology"]

ybbs_stats = rbind(ybbs_lc, ybbs_geo)

st_write(ybbs_rn, "output/ybbs.gpkg", append = FALSE)
saveRDS(ybbs_stats, "output/ybbs_lc_geo.rds")

