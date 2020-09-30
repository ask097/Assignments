## Assignment 4 - web scraping timeplan

## Create a data frame by scraping our calendar in BED-2056
#http://timeplan.uit.no/emne_timeplan.php?sem=20h&module%5B%5D=BED-2056-1&View=list
#This is the link to the “Vis” list. If you would like to scrape another “Vis”, that is ok. In the final data frame, each date should be one row, and make sure you format the dates correctly.


rm(list=ls())

# load packages
library(tidyverse)
library(rvest)


calendar <- read_html("http://timeplan.uit.no/emne_timeplan.php?sem=20h&module%5B%5D=BED-2056-1&View=list")

# Scrape each date with a lecture

calendar <- calendar %>% 
  html_nodes("td") %>% 
  html_text()

# Bind into a dataframe

lectures <- cbind(calendar)


# Removing each row not containing a date

lectures <- lectures[-c(2:6,8:12,14:18,20:24,26:30,32:36,38:42,44:48,50:54, 56:60, 62:66, 68:72, 74:78, 80:84), ]  

# Creating dateframe

lectures <- data.frame(lectures)


