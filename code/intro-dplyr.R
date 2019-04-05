# intro to dplyr
library(dplyr)

# load gapminder dataset
gapminder <-  read.csv("data/gapminder_data.csv",
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

#working through the dplyr cheat sheet
tbl_df(europe)
glimpse(europe)
View(europe)

# working with group_by() and summarize ()
str(gapminder %>%  group_by(continent))
# group_by alters the dataframe to treat it as a list or as
# separate mini data frames within your data frame
# it subsets it without making different objects

# summarize mean gdp per continent
gdp_continent <- gapminder %>% 
  group_by(continent) %>% 
  summarize(mean_gdp = mean(gdpPercap),
  mean_lifeExp = mean(lifeExp))
  # summarize creates a new object and for each 
  #continent have a column with the mean gdp per cap
View(gdp_continent)

# plot it
library(ggplot2)
summary_plot <- gdp_continent %>%
  ggplot(aes(x = mean_gdp, y=mean_lifeExp))+
  geom_point(stat = "identity") +
  theme_bw()
summary_plot  

# exercise - calc mean pop for all continents
pop_continent <- gapminder %>% 
  group_by(continent) %>% 
  summarize(mean_pop = mean(pop))
View(pop_continent)

# exercise - calc mean pop for all continents for most recent year
pop_cont_curr <- gapminder %>% 
  group_by(continent) %>% 
  filter(year == max(year)) %>% 
  summarize(mean_pop = mean(pop))
View(pop_cont_curr)

# count() and n()
# count is like frequency
gapminder %>% 
  filter(year == 2002) %>% 
  count(continent, sort = T) #give number of countries in each continent for that year

gapminder %>% 
  group_by(continent) %>% 
  summarize(se = sd(lifeExp)/sqrt(n()))
  # useful for when you dont know what the n value is, it looks
  # it up for you

# mutate() is my friend
# when you're going to create a brand new column to add to the dataframe
xy <- data.frame(x= rnorm(100), 
                 y= rnorm(100))
head(xy)
xyz <-  xy %>% 
  mutate(z=x*y)
head(xyz)

# add col that gives full gdp for the country and summarize by continent
gdp_per_cont <- gapminder %>% 
  mutate(country_gdp=gdpPercap*pop) %>% 
  group_by(continent) %>% 
  summarize(total_gdp = sum(country_gdp))
View(gdp_per_cont)
