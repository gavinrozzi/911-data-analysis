library(tidyverse)
library(lubridate)

calldata <- read_csv("data.csv")

# Set Agency ID 1 = Toms River Fire Dist. 2 = Ocean County Sheriff
calldata['agency']=2

calldata$sent <- mdy_hms(calldata$sent)
calldata$received <- mdy_hms(calldata$received)


write.csv(calldata,"Month_cleaned.csv", row.names = TRUE)