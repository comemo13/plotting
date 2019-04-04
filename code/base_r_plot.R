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

# getting month data from a factor
biketown$month <- 
  mdy(biketown$StartDate) %>%
  month(label=T, abbr=T)

str(biketown$month)

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

#looking into seasonal patterns
freq_by_month <- table(biketown$month)
barplot(freq_by_month)
#months show up in alphabetical because they are stored as a factor

#re-running this again after the mdy wrangling above
freq_by_month <- table(biketown$month)
barplot(freq_by_month)

#looking into station info
freq_by_station <- table(biketown$StartHub)
table(freq_by_station)
barplot(freq_by_station)

#getting top 25 stations
#sorts the table then wants 1-25
Top25 <- sort(freq_by_station, decreasing = T)[1:25]
barplot(Top25)
dotchart(Top25)

#time to commit