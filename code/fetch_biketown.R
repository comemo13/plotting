# functions to fetch public biketown trip data
# see: https://www.biketownpdx.com/system-data

# error catching, if package is not installed then install it
# pacman allows for checking for an installing missing packages
if(!require("pacman")) {install.packages("pacman")};library(pacman)
pacman::p_load("lubridate")
pacman::p_load("dplyr")
pacman::p_load("stringr")
pacman::p_load("readr")

# function to grab data from website
get_data <- function(start="7/2016", end=NULL, #adding defaults
                     base_url="https://s3.amazonaws.com/biketown-tripdata-public/",
                     outdir="data/biketown/"){
  # ^takes start and end in mm/yyyy and tries to download files
  
  # If no end date given, set to now
  end <- ifelse(is.null(end),format(now(),"%m/%Y"),end)
  
  # make url function that's only available within get_data
  make_url <- function(date, base_url){
    url <- paste0(base_url, format(date,"%Y_%m"), ".csv") 
    # ^pulls the file based on the format on the website
    return(url)
  }
  
  # parse date range
  start_date <- lubridate::myd(start, truncated = 2)
  # ^truncated takes the day out of the date
  end_date  <- myd(end, truncated = 2)
  date_range <- seq(start_date, end_date, by="months")
  
  # apply functions are a concise way to build FOR LOOPS
  # lapply(a, b) just applies function b to sequence a and returns a list of hte modified sequence
  urls <- lapply(date_range, make_url, base_url=base_url)
  
  # for loops can be easier for early development of code
  for (u in urls) {
    download.file(u, destfile = paste0(outdir, 
                                       str_sub(u,-11)))
    # ^for every url from the urls list, it will download
  }
  
}
# ^the first section of the function in the () are the parameters of the function
# ^second section in {} tells the function what to do

### manual run ###
# params
# start = "11/2018"
# 
# get_data(start)
# ^this works so I will commit

# You can write a function inline. In this example we get rid of the FOR LOOP
# because they aren't very effective, we replace it with another APPLY statement
get_data2 <- function(start="7/2016", end=NULL, 
                     base_url="https://s3.amazonaws.com/biketown-tripdata-public/",
                     outdir="data/biketown/"){

  end <- ifelse(is.null(end),format(now(),"%m/%Y"),end)
  
  make_url <- function(date, base_url){
    url <- paste0(base_url, format(date,"%Y_%m"), ".csv") 
    return(url)
  }
  
  start_date <- lubridate::myd(start, truncated = 2)

  end_date  <- myd(end, truncated = 2)
  date_range <- seq(start_date, end_date, by="months")
  
  urls <- lapply(date_range, make_url, base_url=base_url)
  
  # for (u in urls) {
  #   download.file(u, destfile = paste0(outdir, 
  #                                      str_sub(u,-11)))
  # }

  # instead of assigning the function as a named function, we can make it inline
    result <- lapply(urls, function(u) {
    download.file(u, destfile = paste0(outdir, str_sub(u,-11)))
  })
}

start = "11/2018"

get_data2(start)

# Next part is to try to get rid of the intermediate steps into one singluar piped version
get_data3  <- function(start="7/2016", end=NULL, 
                       base_url="https://s3.amazonaws.com/biketown-tripdata-public/",
                       outdir="data/biketown/"){
  
  end <- ifelse(is.null(end),format(now(),"%m/%Y"),end)
  
  make_url <- function(date, base_url){
    url <- paste0(base_url, format(date,"%Y_%m"), ".csv") 
    return(url)
  }
  
  start_date <- lubridate::myd(start, truncated = 2)
  end_date  <- myd(end, truncated = 2)
  date_range <- seq(start_date, end_date, by="months")
  
  lapply(date_range, make_url, base_url=base_url) %>% 
    lapply(function(u) {
    download.file(u, destfile = paste0(outdir, str_sub(u,-11)))
  })
}
# pipe can only replace the first argument in a function. In the previous one, the 2nd lapply
# referenced "urls" as the first arguement, now we are replacing that with the 1st lapply
start = "11/2018"

get_data3(start)
