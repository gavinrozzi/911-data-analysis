#setwd("~/911 Data/Original")

library(tidyverse)
library(leaflet)
library(leaflet.extras)
library(sqldf)
library(lubridate)

# Read in the data files
march_calls <- read_csv("March2019.csv")
april_calls <- read_csv("April2019.csv")
may_calls <- read_csv("May2019.csv")

# Combine into one dataframe
combined_calls <- bind_rows(march_calls, april_calls, may_calls)

# Parse the dates and times of the sent and received columns
combined_calls$sent <- mdy_hms(combined_calls$sent)
combined_calls$received <- mdy_hms(combined_calls$received)

# Subset only the overdose calls
sql_query <- "SELECT * FROM combined_calls WHERE description = 'OVERDOSE'"

overdoses <- sqldf(sql_query)

# Create a map of all overdoses and separate heatmap
overdose_heatmap <- leaflet(data = overdoses) %>% addTiles() %>%
  addHeatmap(lng=~lon, lat=~lat,
            blur = 20, max = 0.05, radius = 15 )

overdose_map <- leaflet(data = overdoses) %>% addTiles() %>%
  addMarkers(~lon, ~lat, popup = ~as.character(description), label = ~as.character(description))

# Create a heatmap of all calls for service
calls_heatmap <- leaflet(data = combined_calls) %>% addTiles() %>%
  addHeatmap(lng=~lon, lat=~lat,
             blur = 20, max = 0.05, radius = 15 )

# Compare overdoses vs all calls for service
percent_overdoses = (nrow(overdoses) / nrow(combined_calls)) * 100 