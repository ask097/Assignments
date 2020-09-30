##  Assignment 5 - SSB API

#Finish the code we were working on in our latest session:
  #http://ansatte.uit.no/oystein.myrland/BED2056/H2020/readSSBsAPI.R
#Recode the variable “region” into tidy names, and make a single plot of “roomcap” for all counties, over time, including the “Whole_country”.


## Code from lecture

rm(list=ls())

library(data.table)
library(tidyverse)
library(ggplot2)


# Read the csv data
county_csv <- fread("http://data.ssb.no/api/v0/dataset/95274.csv?lang=no")
head(county_csv)

whole_country_csv <- fread("http://data.ssb.no/api/v0/dataset/95293.csv?lang=no")
head(whole_country_csv)

rm(county_csv, whole_country_csv)

# Or reading json, the whole country
library(rjstat)
url <- "http://data.ssb.no/api/v0/dataset/95276.json?lang=no"
results <- fromJSONstat(url)
table <- results[[1]]
table

###############################################################
rm(list = ls())

#install.packages("PxWebApiData")
library(PxWebApiData)

?ApiData

county <- ApiData("http://data.ssb.no/api/v0/dataset/95274.json?lang=no",
                  getDataByGET = TRUE)

whole_country <- ApiData("http://data.ssb.no/api/v0/dataset/95276.json?lang=no",
                         getDataByGET = TRUE)

# two similar lists, different labels and coding
head(county[[1]])
head(county[[2]])

head(whole_country[[1]])

# Use first list, rowbind both data
dframe <- bind_rows(county[[1]], whole_country[[1]])


# new names, could have used dplyr::rename()
names(dframe)
names(dframe) <- c("region", "date", "variable", "value")
str(dframe)

# Split date
dframe <- dframe %>% separate(date, 
                              into = c("year", "month"), 
                              sep = "M")
head(dframe)

# Make a new proper date variable
library(lubridate)
dframe <- dframe %>%  mutate(date = ymd(paste(year, month, 1)))
str(dframe)

# And how many levels has the variable?
dframe %>% select(variable) %>% unique()

# car::recode()
dframe <- dframe %>%  mutate(variable1 = car::recode(dframe$variable,
' "Utleigde rom"="Rented Rooms";
"Pris per rom (kr)"="Room Price";
"Kapasitetsutnytting av rom (prosent)"="Room capacity";
"Kapasitetsutnytting av senger (prosent)"="Bed capacity";
"Losjiomsetning (1 000 kr)"="Revenue";
"Losjiomsetning per tilgjengeleg rom (kr)"="Revenue pr Room";
"Losjiomsetning, hittil i år (1 000 kr)"="Revenue so far";
"Losjiomsetning per tilgjengeleg rom, hittil i år (kr)"="Revenue Room so far";
"Pris per rom hittil i år (kr)"="Room Price so far";
"Kapasitetsutnytting av rom hittil i år (prosent)"="Room capacity so far";
"Kapasitetsutnytting av senger, hittil i år (prosent)"="Bed capacity so far" '))

dframe %>% select(variable1) %>% unique()
with(dframe, table(variable, variable1))



mosaic::tally(~region, data = dframe)

# we now have the data in long format ready for data wrangling



###############################################################

### Recode the variable “region” into tidy names, and make a single plot of “roomcap” for all counties, over time, including the “Whole_country”.

# View all regions

dframe %>% select(region) %>% unique()

# Recode region 

# car::recode()
dframe <- dframe %>%  mutate(region = car::recode(dframe$region,
                                                  
'"Trøndelag - Trööndelage"="Trøndelag";
"Troms og Finnmark - Romsa ja Finnmárku"="Troms og Finnmark";
"Heile landet"="Entire Country";
 '))
                                                
dframe %>% select(region) %>% unique()

dframe %>% select(variable1) %>% unique()



# Create plot 
dframe %>% 
  filter(variable1=="Room capacity") %>%
  ggplot(aes(x=date, y=value, group=region)) +
  geom_line(aes(color=region)) +
  ylab(expression("Percentage (%)")) +
  xlab("Month") +
  labs(title = "Hotel Room Capacity Utilization ",
       subtitle = "In Norway by county",
       caption = "Measured in a 6 month period") +
  theme_replace()

