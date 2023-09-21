# Read data
cases <- read.csv("covid19Spain.txt", header=F)
dates <- seq.Date(from=as.Date("2020-01-01"), by="day", length.out=length(cases$V1))
cases <- data.frame(Date=dates, incid=cases$V1)

cases$incid <- cases$incid*100000 ### Approximated global incidence per 100,000 individuals in Spain

# Mutate to weekly cases
library(tidyverse)
library(lubridate)
cases_full_date <- cases %>%
  mutate(., 
         days = days(Date),
         week = week(Date),
         months = month(Date),
         years = year(Date))

cases_week <- cases_full_date %>% 
  group_by(years, week) %>%     
  summarise(incid=sum(incid))

head(cases_week)
cases_week$date <- as.Date(paste(cases_week$years, cases_week$week, 1, sep="-"), "%Y-%U-%u")
cases_week$date[cases_week$years==2020 & cases_week$week==53] <- "2020-12-31"
cases_week$date[cases_week$years==2021 & cases_week$week==53] <- "2021-12-31"
cases_week$date[cases_week$years==2022 & cases_week$week==53] <- "2022-12-31"

train <- cases_week[1:108, c(4,3)]
test <- cases_week[109:161, c(4,3) ] #53 semanas en test