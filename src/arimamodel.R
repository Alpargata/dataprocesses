library("tseries")
library("ggplot2")
library("forecast")
library("fpp")
library("fpp2")
library("gridExtra")
library("car")
library("astsa")
library("xlsx")

data<-read.csv(
  #"https://raw.githubusercontent.com/Alpargata/dataprocesses/master/data/MergedDataset.csv",
  file="../data/MergedDataset.csv",
  header=TRUE)
summary(data)
head(data)
str(data)

ts1 <-ts(data,frequency=12) # We transform our data to a time series
ts1.train<-window(ts1, start=1, end=35-0.0001) # We take 35 years to train
ts1.test<-window(ts1, start=35) # The remaining years for the test

ArimaIcemodel <- Arima(ts1.train[,2],order=c(1,1,3),seasonal=list(order=c(1,1,2), period=12))
fc=forecast(ArimaIcemodel,h=84)
plot(fc)
accuracy(fc,ts1.test[,2])
# RMSE's  0.3024918 0.5678541

# Go for the risky predictions for the next 6 years!
ArimaIceforecast <- Arima(ts1[,2],order=c(1,1,3),seasonal=list(order=c(1,1,2), period=12))
fc1=forecast(ArimaIceforecast,h=84)
plot(fc1, xlab="Years trascurred since 1978" ,ylab="Ice extention in 10^6 km squared") #We can see that the trend for the next years is to decrease constantly
# The ice surface on the north pole!

ArimaCO2model <- Arima(ts1.train[,6],order=c(1,2,10),seasonal=list(order=c(0,2,1), period=12))
fc2=forecast(ArimaCO2model,h=84)
plot(fc2)
accuracy(fc2,ts1.test[,6])

# Go for the risky predictions for the next 6 years!
ArimaCO2forecast <- Arima(ts1[,6],order=c(1,1,3),seasonal=list(order=c(1,1,2), period=12))
fc3=forecast(ArimaCO2forecast,h=84)
plot(fc3, xlab="Years trascurred since 1978" ,ylab="molar concentration of CO2")
#We can, see that there is only 

