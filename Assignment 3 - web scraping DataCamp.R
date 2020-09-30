rm(list=ls())

# load packages
library(tidyverse)
library(rvest)


datacamp_r <- read_html("https://www.datacamp.com/courses/tech:r")


# Scraping titles of all R courses by selecting "h4" within html nodes
datacamp_r <-datacamp_r %>% 
  html_nodes("h4") %>%
  html_text()

##  Rewrite link https://learn.datacamp.com/courses/tech:python
# Repeat scraping process to scrape all Python courses


datacamp_python <-read_html ("https://www.datacamp.com/courses/tech:python")

datacamp_python <-datacamp_python %>% 
  html_nodes("h4") %>%
  html_text()

# Use cbind to bind columns

datacamp_r <- cbind (datacamp_r)
datacamp_python <- cbind(datacamp_python)

# Then assign title to the dataframe

Language <- ("R")
datacamp_r <- cbind(datacamp_r,Language)

Language2 <- ("Python")
datacamp_python <- cbind(datacamp_python,Language2)

# Naming the colums

colnames(datacamp_r) <- c ("Tech", "Language")
colnames(datacamp_python) <- c ("Tech", "Language")

# Combinging the two dataframes into a large dataframe listing each course with its program

largedf <- rbind(datacamp_r,datacamp_python)

