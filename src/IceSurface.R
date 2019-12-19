library(ggplot2)
library(dplyr)
library(car)
library(FactoMineR)

data<-read.csv(
  #"https://raw.githubusercontent.com/Alpargata/dataprocesses/master/data/seaice.csv",
  file="../data/seaice.csv",
  header=TRUE)
summary(data)
head(data)
# Data Preprocess

df <- subset( data, select = -Source.Data ) #We remove the link provided, since its
#not useful for our purpose at least in first place
df$Date=as.Date(paste(sep="-",df$Year,df$Month,df$Day)) # we aggregate the date to easen the
#manipulation
ag<-aggregate(df['Extent'], by=df['Date'], sum)
names(ag)[names(ag)=="Extent"]<-"Global Extent"
rs<-aggregate(x = df["Extent"], by=df["Date"], 
              FUN = function(a){
                y<-a[1]-a[2];
              })
names(rs)[names(rs)=="Extent"]<-"North-South Difference"

df <- merge(df,ag,by="Date")
df <- merge(df,rs,by="Date")

north = df[df$hemisphere == "north",]
south = df[df$hemisphere == "south",]
# Statistical exploration in data

lm1 = lm(data=df, Extent~ . )
summary(lm1)
anova(lm1)
# In this model we can see the correlations: There is strong evidence of year, month and hemisphere
# Having a considerable impact on the Extention of ice on Earth, but are not related with Missing and day.
# Further plotting analysis may be required. Model is not able to explain Y's with X's
# Since R^2 is extremely low, so this is not related to linear model.

#Data Exploring

#Question 1: How was the ice surface's evolution along all the time?

ggplot(data=df,aes(x = Date, y = Extent, color=hemisphere))+
  geom_point()

# As we can see, there are 2 oscilating cycles in the North and South hemisphere.

ggplot(data=north,aes(x = Date, y = Extent, color=hemisphere))+
  geom_point()+
  geom_smooth(method='lm', formula= y~x)

ggplot(data=south,aes(x = Date, y = Extent, color=hemisphere))+
  geom_point()+
  geom_smooth(method='lm', formula= y~x)

# The evolution for the global extension of ice can be seen in here:
ggplot(data=df,aes(x = Date, y = df$`Global Extent`))+
  geom_point()+
  geom_smooth(method='lm', formula= y~x)

#Question 2: Is there a cycle of ice regarding the days of the month?
# Maybe because some moon influence or similar?
ggplot(df,aes(x =factor(Day), y = `Global Extent`))+
  geom_boxplot()

# We can see that there is no sensible variation fir the first days (1-113)
# However, there is a higher sway in the last four days of the month for 
# the last 30 years, and a slight decrease during the 15 days. Interesting

#Question 3: Is there a cycle of ice regarding months of the year?
# Maybe related to seasonal weather?
ggplot(df,aes(x =factor(Month), y = `Global Extent`))+
  geom_boxplot()
#Question 4: Is there a different amount of extention of ice between the North
#Hemisphere and the South Hemisphere?
ggplot(df,aes(x =Date, y =`North-South Difference` ))+
  geom_point()

# do not run the syntax

#Question 5: Annual average of ice?

anAvg<-aggregate(df['Global Extent'], by=df['Year'], sum)
anAvg$`Global Average`<-anAvg$`Global Extent`/table(df$Year)

ggplot(anAvg,aes(x =Year, y =`Global Average` ))+
  geom_point() + 
  geom_smooth(method='lm', formula= y~x)


Navg<-aggregate(north$Extent,by=north['Year'],sum)
northYearAverage<-Navg$x/table(north$Year)
Savg<-aggregate(south$Extent,by=south['Year'],sum)
southYearAverage<-Savg$x/table(south$Year)

# Plots for N and S anual rates are trivial.
