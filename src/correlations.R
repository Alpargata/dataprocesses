library(ggplot2)
library(dplyr)
library(car)
library(FactoMineR)
library(GGally)
data<-read.csv(
  "https://raw.githubusercontent.com/Alpargata/dataprocesses/master/data/MergedDataset.csv",
  header=TRUE)
summary(data)
head(data)
str(data)

  data$Interpolated.Co2.amount-data$Average.Co2.amount
ggcorr(data)
# Ok so here we can visualize that the correlation: There is a hughe correlaton between trend,  we have seen in prior plot