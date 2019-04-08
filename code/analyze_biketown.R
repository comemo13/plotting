# analyze biketown data
# start by sourcing code we previously created

source("code/fetch_biketown.R")
get_data(start = "06/2018", end = "08/2018")

# using the source option, as opposed to copy annd paste, is good for version control
# now I can debug in the single origin of the R script, and by sourcing it in I only have 
# the one, accurate script. 