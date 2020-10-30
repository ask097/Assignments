library(readr)

# Assignment 7 - US Births 

# Importing Datasets and reducing size of dataset 
# By filtering by Day of week, Month, Gender and Weight

## 2017
births2017 <- 
  read_fwf("Nat2017PublicUS.c20180516.r20180808.txt",
           fwf_positions(start = c(13,475,504,23),
                         end = c(14,475,507,23),
                         col_names = c("Birth Month","Sex of Infant","Birth Weight","Birthday of Week")
           )
  )


## 2018

births2018 <- 
  read_fwf("Nat2018PublicUS.c20190509.r20190717.txt",
           fwf_positions(start = c(13,475,504,23),
                         end = c(14,475,507,23),
                         col_names = c("Birth Month","Sex of Infant","Birth Weight","Birthday of Week")
           )
  )



## 2019

births2019 <- 
  read_fwf("Nat2019PublicUS.c20200506.r20200915.txt",
           fwf_positions(start = c(13,475,504,23),
                         end = c(14,475,507,23),
                         col_names = c("Birth Month","Sex of Infant","Birth Weight","Birthday of Week")
           )
  )

# Creating a csv-file 

write.csv(births2017,"Birth2017", row.names = FALSE)

write.csv(births2018, "Births2018", row.names = FALSE)

write.csv(births2019, "Births2019", row.names = FALSE)

# Reading csv-file

Births2017<- read.csv("Birth2017")
Births2018<- read.csv("Births2018")
Births2019<- read.csv("Births2019")

library(dplyr)
library(tidyverse)
library(ggplot2)



Births2017 <- Births2017 %>% mutate(Year=2017)
Births2018 <- Births2018 %>% mutate(Year=2018)
Births2019 <- Births2019 %>% mutate(Year=2019)

# Adding all the births to a combined dateset

All_Births <- bind_rows(Births2017, Births2018, Births2019)

# Changing values to numeric

All_Births$Birth.Weight <- as.numeric(All_Births$Birth.Weight)
All_Births$Birth.Month <- as.numeric(All_Births$Birth.Month)
All_Births$Birthday.of.Week <- as.numeric(All_Births$Birthday.of.Week)
str(All_Births)


# 1 The proportion of boys to girls?

All_Births1 <- All_Births %>%
 group_by(Year,Sex.of.Infant) %>%
  mutate(count=row_number()) %>%
  filter(count==max(count)) 

#Plot

ggplot(All_Births1, aes(x = Sex.of.Infant, y = count, fill = Sex.of.Infant)) +
  geom_bar(stat = "identity") +
  facet_wrap(~Year) +
  ylab(expression("Number of Births")) + 
  xlab(expression("Year"))
  labs(title = "Proportion of Boys to Girls Each")

  

#2 The average birth weight in grams by gender?

Avg <- All_Births %>%
  group_by(Year,Sex.of.Infant) %>%
  summarise(avgWeight = mean(Birth.Weight))


# Plot
ggplot(Avg, aes(x = Year, y = avgWeight, color= Sex.of.Infant)) + 
  geom_line() + 
  ylab(expression("Weight")) +
  xlab("Year") +
  labs(title = "Average Birthweight by gender")



#3 The proportion of boys to girls by day of birth.

All_Births2 <- All_Births %>%
  group_by(Year,Birthday.of.Week,Sex.of.Infant) %>%
  mutate(count=row_number()) %>%
  filter(count==max(count)) 
# Plot

ggplot(All_Births2, aes(x = Birthday.of.Week, y = count, fill = Sex.of.Infant, color = Sex.of.Infant)) +
  geom_line(stat = "identity") + 
  ylab(expression("Number of Births")) +
  labs(title = "Proportion of Boys to Girls By Day of Week") +
  facet_wrap(~Year)


