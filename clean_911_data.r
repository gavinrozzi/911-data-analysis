library(tidyverse)
library(lubridate)

calldata <- read_csv("April2019.csv")

calldata['agency']=2

calldata$sent <- dmy_hms(calldata$sent)
calldata$received <- dmy_hms(calldata$received)


write.csv(calldata,"calldata_cleaned.csv", row.names = TRUE)