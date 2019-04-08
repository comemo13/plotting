library(dplyr)
library(tidyr)
library(ggplot2)
library(readr)

bikenet <- read_csv("data/bikenet-change.csv")
#using a tidyr read function which tries to tidy the data on read

head(bikenet)
summary(bikenet)
summary(factor(bikenet$facility2013))

# need to tidy the table to see that change in facilities over time
# need to covert to a long table
#gather facility columns into single year variable
colnames(bikenet)
bikenet_tall <- bikenet %>% 
  gather(key = "year", value = "facility", #key is what the new column is called
         facility2008:facility2013, #this works because the columns are contiguous
         na.rm= T) %>% #removes NA values
  mutate(year = stringr::str_sub(year, start = -4)) #gets last 4 of string

# collapse/unit the street and suffix
bikenet_tall <- bikenet_tall %>% 
  unite(col = "street", c("fname", "ftype"), sep = " ")
  #can also set this up to keep the original field as is

# the inverse to separate
bikenet_tall <- bikenet_tall %>% 
  separate(street, c("name", "suffix")) #breaks it into two
  #can change the separator type, can change which separator to choose

bikenet_tall %>% filter(bikeid == 139730)

fac_lengths <- bikenet_tall %>% 
  filter(facility %in% c("BKE-LANE","BKE-BLVD","BKE-BUFF",
                         "BKE-TRAK","PTH-REMU")) %>% #filters types i want
  group_by(year, facility) %>% 
  summarize(meters = sum(length_m)) %>% 
  mutate(miles = meters/1609)

# ggplot start with data, get coordinate plane, and how to represent
# this is the global, change this to change everything else
p <- ggplot(fac_lengths, aes(year, miles,  #x=year y=miles
                             group=facility,
                             color=facility))


# separates representation from the template, need to use geom to visualize
p + geom_line()
p + geom_point()
p + geom_line() + scale_y_log10()
p + geom_line() + labs(title = "Change in Facilities",
                       subtitle = "2008 - 2013",
                       caption = "suorce: Portland Metro") +
  xlab("year") + ylab("Total miles") 
  
p2 <- ggplot(fac_lengths, aes(x=year, y=miles,
                             group=facility))
p2 +geom_line(size = 1, color = "blue") + facet_wrap( ~ facility) + scale_y_log10()
# facet breaks it out into different graphs