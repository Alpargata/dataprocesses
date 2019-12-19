# https://datahub.io/anuveyatsu/co2-ppm source web page
library(ggplot2) #for plotting the results in a clear manner

  library(dplyr)   # for manipulation on the dataset  
library(corrplot)# to find correlation between variable 
# Reading the data from file
co2data<-read.csv(  "../data/co2.csv", header=TRUE, na.strings = TRUE )
#Creating a column for Year to preserve Date
co2data$Year = substr(co2data$Date, start = 0, stop = 4)
co2data$Year = factor(co2data$Year)
co2data$Date =  as.Date(co2data$Date)
co2data <- subset( co2data, select = -Decimal.Date ) #removing redondant information about date

scatter.smooth(x = co2data$Date, y = co2data$Average) # as we cab see the outliers set at -99.99 and since there are only 7 observation we can remove them as they don't incide on the dataset 

outlier_values <- boxplot.stats(co2data$Average)$out

co2data <- co2data %>% 
  rename(
    Days = Number.of.Days  #rename the variable to increase readability 
  )%>% 
  filter(Average != '-99.99') 

#variables correlation and feature engineering 
co2data.cor = cor(x = co2data$Average , y = co2data$Trend) # To deternine if 2 coloumns describe the same event
co2data.cor = cor(x = co2data$Average , y = co2data$Interpolated)

plot(co2data$Year, y = co2data$Trend)
#question n 2: What was (in terms of climate change) the 'worst year' for our planet? (more polluted year, higher temperature...)
#By worst year here we mean that we are looking for the highest CO2 level in the data 
#pre-testing assumption: we expect that the woorst year will be towards the end as it is constatly increasing 
#grouping by year
co2data_year <-  co2data %>% 
                  group_by(Year) %>%
                  summarise(Trend = median(Trend))

summary(co2data_year)
trend<- plot(co2data_year$Year, y = co2data_year$Trend)

co2data_year$Year = as.Date(co2data_year$Year, format("%Y"))

#detecting the worst year by using dplyr package functions
worst_year <-co2data_year %>% 
  filter(Trend == max(Trend))  %>% 
  select(Year)


# Plotting 
yearly_plot <- ggplot(data = co2data_year, aes(x = Year, y = Trend) )+
  geom_line(color = "#00AFBB", size = 1)+
  ylab("CO2 Level (Parts/million)")+
  ggtitle("CO2 mean by Year") +
  theme(plot.title = element_text(hjust = 0.5))

# as we can clearly see the year with the highest levels of CO2 is the last recorded year whick is 2018
#this trend is clear in all previous years where the highest levels of C02 are beaten the following year and so on, meaning that it is only getting worse each year

