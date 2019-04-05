# intro to dplyr
library(dplyr)

# load gapminder dataset
gapminder <-  read.csv("gapminder_data.csv",
                       stringsAsFactors = F)

#gapminder$continent <- as.factor(gapminder$continent)
#gapminder$continent <- as.character(gapminder$continent)

# get mean of gpd of Africa using Base R
mean(gapminder[gapminder$continent == "Africa", "gdpPercap"])

# easier to do this in dplyr
# remember to use the pipe %>%
# functions we will learn today from dplyr:
# select(), filter(), group_by(), summarize(), mutate()

# what attributes are in gapminder:
str(gapminder)
colnames(gapminder)

# want to subset on three attributes
subset_1 <- gapminder %>%
  select(country, continent, lifeExp) # using the %>% shortcuts having to put gapminder[gapminder$country]
str(subset_1)
head(subset_1)

# to exclude certain attributes
subset_2 <- gapminder %>%
  select(-lifeExp,-pop)

# select some attributes by rename a few for clarity
subset_3 <- gapminder %>%
  select(country, population = pop, lifeExp, 
         gdp = gdpPercap)
str(subset_3)
head(subset_3)

# using filter
africa <- gapminder %>% 
  filter(continent == "Africa") %>% 
  select(country, population = pop, lifeExp)
table(africa$country) #lists all the countries because of order of operations

#need to get rid of the other countries because they 
# will show when graphing
# issue is with when you called in the data it's a factor
# need to bring in the values as a character, not a factor
#gapminder <-  read.csv("gapminder_data.csv", stringsAsFactors = F)

# selet year, population, country for Europe
europe <- gapminder %>% 
  filter(continent == "Europe") %>% 
  select(year, population = pop, country)
# assign table as object and view to look better
europe_table <- table(europe$country)
View(europe_table) #capital V
