library(ggplot2)
library(dplyr)
library(car)
library(FactoMineR)
library(RiverLoad)
# First we will preprocess the CO2 dataset
co2data<-read.csv(
  # "https://raw.githubusercontent.com/Alpargata/dataprocesses/master/data/co2.csv",
  file = "../data/co2.csv",
  header=TRUE, na.strings = TRUE , as.is = TRUE)
summary(co2data)
head(co2data)

# We need to clean our data by removing the missing values labeled with -99.99 and our desired dates
co2data <- co2data %>%
  filter(Average != '-99.99') %>% # missing months were tagged with a -99.99 so we need to remove them
  filter(Date >= bottomDate & Date <= topDate) #removing all data out of our borderlines

# Data Preprocessing and Cleaning
co2data <- select(co2data,1,5) 
#Removing the Decimal.Date since we already have a Date coloum and it is redundant. Number of days are of no apparent use

# Since the earliest date from our dataset its 1978, we will start our dataset at Nov 1978 

bottomDate <- as.Date("1978-11-01") #This is the oldest date in common for both our dataset
topDate  <-as.Date("2018-09-30")

#column renaming:
co2data <- co2data %>% 
  rename(
    "Trend for Co2 amount" = Trend # mole fraction determined from daily averages
  )
co2data$Date <- as.Date(co2data$Date)

# Secondly we will preprocess all the seaice data
seaiceData<-read.csv(
  #"https://raw.githubusercontent.com/Alpargata/dataprocesses/master/data/seaice.csv",
  file="../data/seaice.csv",
  header=TRUE)
summary(data)
head(data)

# We have to do this later to consecutively remove the ice data for that month
seaiceData <- seaiceData %>%
  filter(Date >= bottomDate & Date <= topDate) #removing all data out of our borderlines

seaiceData <- subset( seaiceData, select = -Source.Data ) #We remove the link provided, since its
#not useful for our purpose at least in first place
seaiceData$Date=as.Date(paste(sep="-",seaiceData$Year,seaiceData$Month,seaiceData$Day)) # we aggregate the date to easen the
#manipulation

north = seaiceData[seaiceData$hemisphere == "north",]
south = seaiceData[seaiceData$hemisphere == "south",]

# Now we proceed to make the data mergeable
north <- north %>% 
  rename(
    "datetime"= Date , # mole fraction determined from daily averages
    "flow" = Extent
  ) 
north <- monthly.year.mean(north) # We use this function to get a summary of our monthly ice extent. We have proven in
north <- north %>% 
  rename(
    "Date"= datetime , # mole fraction determined from daily averages
    "NorthIceAverageExtent" = flow
  ) 
south <- south %>% 
  rename(
    "datetime"= Date , # mole fraction determined from daily averages
    "flow" = Extent
  ) 
south <- monthly.year.mean(south) # We use this function to get a summary of our monthly ice extent. We have proven in
south <- south %>% 
  rename(
    "Date"= datetime , # mole fraction determined from daily averages
    "SouthIceAverageExtent" = flow
  ) 
totalMonthlyIce <- merge(north,south,by="Date")
totalMonthlyIce$Date<- as.Date(totalMonthlyIce$Date)

# one plot from "IceSurface.R" that ice surface uses to remain constant along an entire month, so only the mean will be provided
# Statistical exploration in data

totalMonthlyIce$GlobalIceExtent<-totalMonthlyIce$NorthIceAverageExtent+totalMonthlyIce$SouthIceAverageExtent
totalMonthlyIce["N-SDiffIceExtent"]<-totalMonthlyIce$NorthIceAverageExtent-totalMonthlyIce$SouthIceAverageExtent

finalDS <- merge(totalMonthlyIce,co2data,by="Date", all.x = FALSE) # We merge both so missing value co2 rows are excluded

cd<- getwd()
write.csv(finalDS,file = "../data/MergedDataset.csv", row.names = FALSE)




