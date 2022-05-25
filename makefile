network: output/ybbs.grd
vector: output/ybbs.gpkg
map: ouput/ybbs.jpg
ca: output/catchment.tif
ws: output/ybbs_ws.rds
all: network map ca vector ws

output/ybbs.grd: r/delineate.r data/dhm_at_lamb_10m_2018_epsg3035.tif
	Rscript r/delineate.r

output/catchment.tif: r/catchment.r output/ybbs.grd
	Rscript r/catchment.r

output/ybbs.gpkg: r/stream_vector.r output/ybbs.grd data/dhm_at_lamb_10m_2018_epsg3035.tif data/ybbs_lc.gpkg data/ybbs_geo.gpkg
	Rscript r/stream_vector.r

ouput/ybbs.jpg: r/map.r output/ybbs.gpkg data/dhm_at_lamb_10m_2018_epsg3035.tif
	Rscript r/map.r

output/ybbs_ws.rds: r/watershed.r data/dhm_at_lamb_10m_2018_epsg3035.tif output/ybbs.grd output/catchment.tif output/ybbs.gpkg
	Rscript r/watershed.r