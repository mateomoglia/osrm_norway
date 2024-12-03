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
  city = c("Oslo", "Bergen", "Stavanger", "Trondheim", "Drammen", "Fredrikstad", "Kristiansand", "Tromsø", "Sandnes", "Ålesund"),
  lat  = c(59.9139, 60.3920, 58.9690, 63.4305, 59.7444, 59.2115, 58.1467, 69.6496, 58.8524, 62.4722),
  lon  = c(10.7522, 5.3245, 5.7331, 10.3942, 10.2045, 10.9391, 7.9956, 18.9560, 5.7331, 6.1495)
) %>%
  st_as_sf(coords = c("lon","lat"), crs = 4326) %>%
  st_transform(crs = 4258)

  #---------------
  # Check on a plot
  #---------------

ggplot() +
  geom_sf(data = norway_shp, fill = "white") +
  geom_sf(data = norway_cities, colour = "indianred") +
  theme_bw()

# Compute a matrix of travel times -----------------------------------

travel_time = osrmTable(loc = norway_cities)

# Extract the paths --------------------------------------------------

  #---------------
  # Create an empty object that we will feed
  #---------------

route = data.frame()

  #---------------
  # For each cities in norway_cities, compute the path between this
  # city and another city
  #---------------

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
# One needs to have a rsconnect() account and tokens
# rsconnect::setAccountInfo(name='dz683z-mateo', token=<TOKEN>, secret=<SECRET>)

setwd(project)
runApp()
deployApp()
