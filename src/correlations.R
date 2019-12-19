library(ggplot2)
library(dplyr)
library(car)
library(FactoMineR)
library(GGally)
library(plotly)
data<-read.csv(
  "https://raw.githubusercontent.com/Alpargata/dataprocesses/master/data/MergedDataset.csv",
  header=TRUE)
summary(data)
head(data)
str(data)

plot(data$Average.Co2.amount-data$Trend.for.Co2.amount)

ggcorr(data)
# Ok so here we can visualize that the correlation: There is no strong correlation between the Co2 trend and 
# Ice surface, but that does not mean the correlation does not exist!
# For this purpose, lets dive on the relations:

ggplot(data,aes(x = data$GlobalIceExtent, y = data$Trend.for.Co2.amount)) +
  geom_point() + 
  geom_smooth(method='lm', formula= y~x)

 
# ok, so in this plot we have shown a really nosiy linear model, so we can say that overall, the trend to the 
# global ice amount is to decrease its extension as co2 grows... Lets see if there are some other dependencies between
# north and south poles

ggplot(data,aes(x = data$NorthIceAverageExtent, y = data$Trend.for.Co2.amount)) +
  geom_point() + 
  geom_smooth(method='lm', formula= y~x)

ggplot(data,aes(x = data$SouthIceAverageExtent, y = data$Trend.for.Co2.amount)) +
  geom_point() + 
  geom_smooth(method='lm', formula= y~x)

fit <- lm(NorthIceAverageExtent ~ Trend.for.Co2.amount ,data = data)

scatterplot <- data %>%
  ggplot(aes(x = Trend.for.Co2.amount, y = NorthIceAverageExtent, color = Date)) + 
  ggtitle("Correlation between North Hemisphere Ice surface and CO2 concentration")+
  theme(plot.title = element_text(hjust = 0.5))+
  geom_point() + 
  labs(x = "Co2 Amounts (mole fraction)", 
       y = "Ice extent (10^6 km)") +
  theme_classic() +
  theme(legend.position = "none")


  ggplot(data,aes(x = Trend.for.Co2.amount, y = NorthIceAverageExtent, color = Date)) + 
  ggtitle("Correlation between North Hemisphere Ice surface and CO2 concentration")+
  theme(plot.title = element_text(hjust = 0.5))+
  geom_point() + 
  labs(x = "Co2 Amounts (mole fraction)", 
       y = "Ice extent (10^6 km)") +
  theme(legend.position = "none")

ggplotly(scatterplot) %>% 
  add_lines(x = ~data$Trend.for.Co2.amount, y = fitted(fit))

# ok so here we can say that there is very low dependency for the co2 and the south hemisphere ice extension
# but on the other hand, co2 is severely destroying north hemisphere ice extention significatively. This is