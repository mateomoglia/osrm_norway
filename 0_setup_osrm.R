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
  city = c("Oslo", "Bergen", "Stavanger", "Trondheim", "Drammen", "Fredrikstad", "Kristiansand", "Tromsø", "Sandnes", "Ålesund"),
  lat  = c(59.9139, 60.3920, 58.9690, 63.4305, 59.7444, 59.2115, 58.1467, 69.6496, 58.8524, 62.4722),
  lon  = c(10.7522, 5.3245, 5.7331, 10.3942, 10.2045, 10.9391, 7.9956, 18.9560, 5.7331, 6.1495)
) %>%
  st_as_sf(coords = c("lon","lat"), crs = 4326) %>%
  st_transform(crs = 4258)

ggplot() +
  geom_sf(data = norway_shp, fill = "white") +
  geom_sf(data = norway_cities, colour = "indianred") +
  theme_bw()

# Compute a matrix of travel times -----------------------------------

travel_time = osrmTable(loc = norway_cities)

# Extract the paths --------------------------------------------------

route = data.frame()
for(x in 1:length(norway_cities$city)){
  for(y in 1:length(norway_cities$city)){
  path = osrmRoute(src = norway_cities[x,], dst = norway_cities[y,])
  path = path %>% 
    mutate(orig = norway_cities$city[x],
           dest = norway_cities$city[y])
  route = rbind(route,path)
  }
}

route = route %>% st_as_sf() 

# Export the files ---------------------------------------------------

st_write(route,dsn = paste0(project,"/output/route.shp"))
st_write(norway_cities,dsn = paste0(project,"/output/norway_cities.shp"))

# Make a shinyApp out of it ------------------------------------------

setwd(project)
runApp()
deployApp()
