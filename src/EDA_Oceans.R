setwd("C:/Users/bea4e/Desktop/University/Data Processes/Assignment/")

#libraries
library(plyr)

ocean <- read.csv("Dataset_Oceans.csv", header = TRUE)
ocean <- read.csv("https://github.com/Alpargata/dataprocesses/blob/master/data/icoads_noaa.csv", header = TRUE)


# Choosing the important features

# It could be interesting to analyse also present weather, waves and clouds but more than
# a half of their values are NA, so we decided to drop them. Moreover we drop the year since its the 
# same (2010) for every observation. We don't take the column country_code since most of
# the cells are empty.
newCols <- c("month", "day", "latitude", "longitude", "air_temperature", "sea_surface_temp", "sea_level_pressure")
newOcean <- ocean[newCols]



# Features engineering and Pearson correlation

# Omitting all the rows with NA values
newOcean <- na.omit(newOcean, seq_along(sea_surface_temp, air_temperature, sea_level_pressure))

# Correlation matrix to see the relationship between the variables
newOcean.cor = cor(newOcean)

#as expected sea_level_temp and ait_temperature are higly correlated (0.948),
#so we can drop one of the two columns

# we can also notice that there is a negative correlation between temperature and longitude
#We can try to plot plot sea_surface_temp vs latitude and we can see a pattern which, as expected 
#indicates that the temperature is low in the poles and increases the closer we get to the equator
plot(newOcean$latitude, newOcean$sea_surface_temp)

# we aggregate the date to easen the manipulation
newOcean$Date <- with(newOcean, sprintf("%d-%02d-%03d", year, month, day))

#Creating variable Heisphere by binning the longitude
newOcean$Hemisphere <- cut(newOcean$latitude, c(-90,0, 90))
newOcean$Emisphere <- revalue(newOcean$Hemisphere, c("(-90,0]"="South"))
newOcean$Emisphere <- revalue(newOcean$Hemisphere, c("(0,90]"="North"))



#TODO: Graphics

# Plotting air_temperature
newmap <- getMap(resolution = "high")
pal = colorRampPalette(c("blue","white", "yellow", "red"))
newOcean$order = findInterval(newOcean$air_temperature, sort(newOcean$air_temperature))
plot(newmap, xlim = c(-20, 59), ylim = c(35, 71), asp = 1, col = "antiquewhite1")
points(newOcean$longitude, newOcean$latitude, col=pal(nrow(newOcean))[newOcean$order], pch = 16, cex = .6)
