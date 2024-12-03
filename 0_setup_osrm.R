#---------------------------------------------------------------------
#
# Open OSMR and setup.
# MM
#
#---------------------------------------------------------------------

project = "/Users/mmoglia/Dropbox/research/phd/osrm_norway"

# Load required packages ---------------------------------------------

pacman::p_load(osrm,dplyr,osmdata,ggplot2,sf,leaflet,shiny,rsconnect)

# Set-up origin and destination --------------------------------------

  #---------------
  # Open a map of Norway for dataviz
  #---------------

norway_shp = read_sf(paste0(project,"/raw/no_100km.shp"))

  #---------------
  # Open a subsample of cities
  #---------------

norway_cities <- data.frame(
  city = c("Oslo", "Bergen", "Stavanger", "Trondheim",