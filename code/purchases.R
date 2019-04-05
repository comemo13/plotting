library(dplyr)
library(tidyr)
library(ggplot2)
library(readr)
library(lubridate)

pur <- read_csv("data/Purchases.csv")

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

g + geom_bar(aes(fill=fl))


           