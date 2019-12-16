library(ggplot2)
library(dplyr)

# Reading the data from file
# https://datahub.io/anuveyatsu/co2-ppm source web page

co2data<-read.csv(
  "../data/co2.csv",
  header=TRUE, na.strings = TRUE , as.is = TRUE)
summary(co2data)
head(co2data)
# Data Preprocessing 
# Data Cleaning 
co2data$Date = substr(co2data$Date, start = 0, stop = 4)
co2data$Date = factor(co2data$Date)
co2data <- subset( co2data, select = -Decimal.Date ) #Removing the Decimal.Date since we already have a Date coloum and it is redoundant 
#rename coloumns for a better interpretation
outlier_values <- boxplot.stats(co2data$Trend)$out  # detecting outliers values 
#remove the outliers as there are only 7 values with -99.99 (that represents Missing months are denoted by -99.99)
co2data <- co2data %>% 
  rename(
    Days = Number.of.Days 
  )%>% 
  filter(Average != '-99.99') 

#question n 2: What was (in terms of climate change) the 'worst year' for our planet? (more polluted year, higher temperature...)
#By worst year here we mean that we are looking for the highest CO2 level in the data 
#pre-testing assumption: we expect that the woorst year will be towards the end as it is constatly increasing 
plot(co2data$Date, y = co2data$Trend)

#grouping by year
co2data<-  co2data %>% 
    group_by(Date) %>%
  summarise(Trend = median(Trend))
summary(co2data)

#Now we display the results and see which year has the highest mean of CO2 levels

plot(co2data$Date, y = co2data$Trend)

worst_year <-co2data %>% 
            filter(Trend == max(Trend))  %>% 
            select(Date)
            

# as we can clearly see the year with the highest levels of CO2 is the last recorded year whick is 2018
#this trend is clear in all previous years where the highest levels of C02 are beaten the following year and so on, meaning that it is only getting worse each year
