#---------------------------------------------------------------------
#
# Open OSMR and setup.
# MM
#
#---------------------------------------------------------------------

project = "/Users/mmoglia/Dropbox/research/phd/osrm_norway"

# Load required packages ---------------------------------------------

pacman::p_load(osrm,dplyr,osmdata,ggplot2,sf,leaflet,shiny,rsconnect)
rsconnect::setAccountInfo(name='dz683z-mateo', token='78D48D02F03E1272C309A4C1EB0C61BF', secret='S9fCWMSzhxr1OYffOSoz9TYiE8dMqVb/uj8Uvpb5')

# Set-up origin and destination --------------------------------------

norway_shp = read_sf(paste0(project,"/raw/no_100km.shp"))

norway_cities <- data.frame(
  city = c("Oslo", "Bergen", "Stavanger", "Trondheim", "Dram