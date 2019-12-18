# Script for New Brunswick PD dispatch logs

#setwd("~/911 Data/Original")

library(tidyverse)
library(leaflet)
library(leaflet.extras)
library(sqldf)
library(lubridate)

# Read in the data files
nb_calls <- read_csv("geocode2.csv")

# Combine into one dataframe
combined_calls <- bind_rows(march_calls, april_calls, may_calls)

# Parse the dates and times of the sent and received columns
combined_calls$sent <- mdy_hms(combined_calls$sent)
combined_calls$received <- mdy_hms(combined_calls$received)

# Subset only the overdose calls
sql_query <- "SELECT * FROM nb_calls WHERE description = 'MOTOR VEHICLE STOP'"

mv_stops <- sqldf(sql_query)

# Create a map of all overdoses and separate heatmap
mv_stop_heatmap <- leaflet(data = mv_stops) %>% addTiles() %>%
  addHeatmap(lng=~lon, lat=~lat,
             blur = 20, max = 0.05, radius = 15 )

mvstop_map <- leaflet(data = mv_stops) %>% addTiles() %>%
  addMarkers(~lon.x, ~lat.x, popup = ~as.character(description), label = ~as.character(description))

# Create a heatmap of all calls for service
calls_heatmap <- leaflet(data = combined_calls) %>% addTiles() %>%
  addHeatmap(lng=~lon, lat=~lat,
             blur = 20, max = 0.05, radius = 15 )