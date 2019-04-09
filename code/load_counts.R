# read in excel bike count and tabular weather data

library(readxl)
library(lubridate)
library(dplyr)
library(readr)

input_file <- "data/Hawthorne Tilikum Steel daily bike counts 073118.xlsx"
bridge_names <- c("Hawthorne","Tilikum","Steel")
# ^vector of bridge names

# define a function that loads excel sheets
load_data <- function(bridge_name, input_file){
  bike_counts <- read_excel(input_file, sheet = bridge_name, skip = 1) %>% 
  # ^skip skips the first row
    filter(total>0) %>% 
    select(date, total) %>% 
    mutate(bridge = bridge_name, date = as.Date(date)) #drops useless time
}

# test of function
# h <- load_data("Hawthorne", input_file)
# head(h)

# load data from each excel sheet into a list (readecvel)
# comine all three into one data fram
bike_counts <- lapply(bridge_names, load_data, input_file = input_file) %>% 
  bind_rows()

# factorize bridge names, since here it makes sense to Joe
bike_counts <- bike_counts  %>%  mutate(bridge = factor(bridge))

# read in weather data from CSV
weather <- read_csv("data/NCDC-CDO-USC00356750.csv")
