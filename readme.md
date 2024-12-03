# Apply OSRM to Norway

This project uses the `orsm` package in R and computes distances and times between Norway cities.\

## Installation

> Install `osrm` [(Website)]("https://project-osrm.org).

## How to compute distances?

The package only needs origins and destinations in `sf` format. 

- The function `osmRoute()` takes two `POINT` geometries and compute the route between both and outputs a `sf` file containing the road, the length and the time of travel (in minutes). 
- The function `ormTable()` takes a `sf` containing locations and outputs a matrix of bilateral distances or times between all locations (hence the diagonal is 0).
## Output

The output is either in matrix format, but also in shapefile.

This ShinyApp [here](https://dz683z-mateo.shinyapps.io/osrm_norway) shows the result!
