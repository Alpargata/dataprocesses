#libraries
library(plyr)
library(tidyr)
library(ggplot2)
library(rworldmap)
library(rworldxtra)

ocean <- read.csv('../data/icoads_noaa.csv', header = TRUE)


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
newOcean$Date <- with(newOcean, sprintf("%d-%02d", month, day))

#Creating variable Hemisphere by binning the latitude
newOcean$Hemisphere <- cut(newOcean$latitude, c(-90,0, 90))
newOcean$Hemisphere <- revalue(newOcean$Hemisphere, c("(-90,0]"="South"))
newOcean$Hemisphere <- revalue(newOcean$Hemisphere, c("(0,90]"="North"))



#Graphs

# # Plotting air_temperature
# layout(matrix(1:2,ncol=2), width = c(2,1),height = c(1,1))
# 
# newmap <- getMap(resolution = "high")
# pal = colorRampPalette(c("blue","lightblue", "yellow", "red"))
# newOcean$order = findInterval(newOcean$air_temperature, sort(newOcean$air_temperature))
# plot(newmap, xlim = c(-20, 59), ylim = c(35, 71), asp = 1, col = "antiquewhite1")
# points(newOcean$longitude, newOcean$latitude, col=pal(nrow(newOcean))[newOcean$order], pch = 16, cex = .6)
# 
# colfunc <- colorRampPalette(c("red","yellow", "lightblue", "blue"))
# legend_image <- as.raster(matrix(colfunc(20), ncol=1))
# plot(c(0,2),c(0,1),type = 'n', axes = F,xlab = '', ylab = '', main = 'Air temperature in °C')
# text(x=0.8, y = seq(0,0.5,l=4), labels = seq(from = -20, to = 40, by = 20))
# rasterImage(legend_image, 0, 0, 0.5,0.5)


# Plotting sea_level_pressure
layout(matrix(1:2,ncol=2), width = c(2,1),height = c(1,1))

newmap <- getMap(resolution = "high")
pal = colorRampPalette(c("blue","lightblue", "yellow", "red"))
newOcean$order = findInterval(newOcean$sea_level_pressure, sort(newOcean$sea_level_pressure))
plot(newmap, xlim = c(-20, 59), ylim = c(35, 71), asp = 1, col = "antiquewhite1")
points(newOcean$longitude, newOcean$latitude, col=pal(nrow(newOcean))[newOcean$order], pch = 16, cex = .6)

colfunc <- colorRampPalette(c("red","yellow", "lightblue", "blue"))
legend_image <- as.raster(matrix(colfunc(20), ncol=1))
plot(c(0,2),c(0,1),type = 'n', axes = F,xlab = '', ylab = '', main = 'Pressure in hPa')
text(x=0.8, y = seq(0,1,l=2), labels = seq(955.5,1046.6,l=2))
rasterImage(legend_image, 0, 0, 0.5,0.5)

#Avarage temperature by months for the different hemispheres
ocean_south <- newOcean %>% subset(Hemisphere == "South")
ocean_south <- aggregate(ocean_south,
                         by = list(ocean_south$month),
                         FUN = mean)
cols <- c("month", "air_temperature", "sea_surface_temp", "sea_level_pressure")
ocean_south <- ocean_south[cols]

ocean_north <- newOcean %>% subset(Hemisphere == "North")
ocean_north <- aggregate(ocean_north,
                         by = list(ocean_north$month),
                         FUN = mean)
ocean_north <- ocean_north[cols]

ggplot(data=ocean_north, aes(x=month, y=air_temperature,2)) +
  scale_x_discrete(limits=c("1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"))+
  theme(axis.text.x = element_text(size=10, angle=45))+
  ggtitle("Sea level pressure by month in the Northern Emisphere")+
  geom_bar(stat="identity", fill="steelblue")+
  theme_minimal()

ggplot(data=ocean_south, aes(x=month, y=air_temperature,2)) +
  scale_x_discrete(limits=c("1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"))+
  theme(axis.text.x = element_text(size=10, angle=45))+
  ggtitle("Sea level pressure by month in the Southern Emisphere")+
  geom_bar(stat="identity", fill="steelblue")+
  theme_minimal()
