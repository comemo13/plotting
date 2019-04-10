library(dplyr)
library(tidyr)
library(ggplot2)
library(readr)
library(lubridate)
library(plyr)

pur <- read.csv("data/Purchases.csv", stringsAsFactors = F)

head(pur)
summary(pur)
colnames(pur)

# total purchase amounts by TOD
TOD_amount <- pur %>%
  mutate(purchase_l = ymd_hms(`Purchase Date Local`)) %>% 
  group_by(hour = hour(purchase_l)) %>% 
  summarize(amount = sum(Amount))

g <- ggplot(TOD_amount, aes(hour, amount))
g + geom_bar(stat = "identity") + 
  scale_fill_gradient(low="green", high = "red")

# adding in District based on MeterCode
pur_df1 <- pur %>% 
  mutate(district_letter = substr(`Terminal - Terminal ID`,1,1))

plyr::count(pur_df1,"district_letter")

dist_name <- pur_df1$district_letter %>% 
  ifelse(dist_name %in% c("H","F"),"Downtown","Other")
