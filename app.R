# Load the librairies ------------------------------------------------

library(leaflet)
library(sf)
library(shiny)
library(dplyr)

# Load the data ------------------------------------------------------

norway_cities = read_sf("output/norway_cities.shp")
route         = read_sf("output/route.shp")

# Shiny app to display interactive map -------------------------------

ui = fluidPage(
  leafletOutput("map", height = "800px")
)

server = function(input, output, session) {
  # Reactive values to store selected cities
  selected_cities = reactiveValues(city1 = NULL, city2 = NULL)
  route_data = reactiveVal(NULL)
  
  # Render leaflet map
  output$map = renderLeaflet({
    leaflet() %>%
      addTiles() %>%
      addMarkers(
        data = norway_cities %>% st_transform('+proj=longlat +datum=WGS84'),
        popup = ~ as.character(city),
        layerId = ~ as.character(city)
      )
  })
  
  # Handle city clicks
  observeEvent(input$map_marker_click, {
    clicked_city =input$map_marker_click$id
    if (is.null(selected_cities$city1)) {
      selected_cities$city1 =clicked_city
    } else if (is.null(selected_cities$city2)) {
      selected_cities$city2 =clicked_city
      
      # Fetch coordinates of the selected cities
      city1_coords = norway_cities %>% filter(city == selected_cities$city1) %>% st_coordinates()
      city2_coords = norway_cities %>% filter(city == selected_cities$city2) %>% st_coordinates()
      
      # Calculate route, distance, and duration
      route    = route %>% filter(orig == selected_cities$city1, dest == selected_cities$city2)
      distance = round(route$distance,2)
      duration = round(route$duration,2)/60
      
      leafletProxy("map") %>%
        clearShapes()
      
      # Update map with polyline
      leafletProxy("map") %>%
        clearShapes() %>%
        addPolylines(
          data = route %>% st_transform('+proj=longlat +datum=WGS84')
        ) 
      
      # Remove previous label if it exists
      if (!is.null(selected_cities$control_id)) {
        leafletProxy("map") %>%
          removeControl(selected_cities$control_id)
      }
      
      # Add custom label with a white background at the midpoint of the route
      label_id =paste0("route_label_", Sys.time())  # Create a unique ID for each label
      selected_cities$control_id =label_id  # Store the label ID for future removal
      
      leafletProxy("map") %>%
        addControl(
          html = paste(
            "<div style='background-color:white; padding:10px; border-radius:5px; border:1px solid #ccc;'>",
            "From ", selected_cities$city1, " to ", selected_cities$city2, "<br>",
            "Time: ", round(duration, 2), " hours <br>",
            "Length: ", round(distance, 2), " km",
            "</div>"
          ),
          position = "topright",
          layerId = label_id  # Set a unique ID for the label
        )
      
      # Reset selected cities
      selected_cities$city1 = NULL
      selected_cities$city2 = NULL
    }
  })
}

shinyApp(ui,server)
