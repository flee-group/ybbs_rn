network: output/ybbs.grd
vector: output/ybbs.gpkg
map: ouput/ybbs.jpg
ca: output/catchment.tif
pixels: output/neretva_pixels.rds
ws: output/neretva_ws.rds
all: network map ca pixels vector ws

output/ybbs.grd: r/delineate.r data/dhm_at_lamb_10m_2018_epsg3035.tif
	Rscript r/delineate.r

output/catchment.tif: r/catchment.r output/ybbs.grd
	Rscript r/catchment.r

output/ybbs.gpkg: r/stream_vector.r output/ybbs.grd data/dhm_at_lamb_10m_2018_epsg3035.tif data/yk_lc.gpkg data/yk_geology.gpkg
	Rscript r/stream_vector.r

ouput/ybbs.jpg: r/map.r output/ybbs.gpkg data/dhm_at_lamb_10m_2018_epsg3035.tif
	Rscript r/map.r

output/neretva_pixels.rds: r/neretva_table.r output/catchment.tif output/ybbs.grd output/ybbs.gpkg output/neretva_ws.rds
	Rscript r/neretva_table.r

output/neretva_ws.rds: r/watershed.r data/dhm_at_lamb_10m_2018_epsg3035.tif output/ybbs.grd output/catchment.tif output/ybbs.gpkg
	Rscript r/watershed.r