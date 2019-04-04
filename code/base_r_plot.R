# plotting biketown trip data with base R


install.packages("tidyverse")
library(tidyverse)
library(lubridate)


biketown <- read.csv("data/biketown-2018-trips.csv")
str(biketown)

summary(biketown)

# creating a new column
biketown$hour <- 
  hms(biketown$StartTime) %>% #reads as 'then' 
  hour()

table(biketown$hour)

freq_by_hour <- table(biketown$hour)
barplot(freq_by_hour)

?hist
hist(biketown$hour)

#created a histogram with different hourly bins
hist(biketown$hour, breaks=seq(0,24,3))

#focus on AM peak
am_peak <- subset(biketown, hour >= 7 & hour <10)
hist(am_peak$hour, breaks=seq(7,10,1)) #didn't work well

barplot(table(am_peak$hour)) #table creates a freq table to group data

#time to commit
