library(ggplot2)
library(dplyr)
library(caret)

#Load co2_data, select colums and format Date
co2_data<-read.csv("../data/co2.csv",header=TRUE, na.strings = TRUE , as.is = TRUE)
co2_data <- co2_data %>% select(-Decimal.Date) %>% select(-Number.of.Days)
co2_data$Date<-as.Date(co2_data$Date, format = "%Y-%m-%d")
print(paste0('number of missing values in the co2 dataset: ',sum(is.na(co2_data))))

#Load ice_data and select columns
ice_data<-read.csv("../data/seaice.csv",header=TRUE)
ice_data<-ice_data %>% select(-Source.Data) %>% select (-Missing) %>% select (-Day)
#Grouping by year and month, sort and format date
ice_data<-ice_data %>% group_by(Year, Month) %>% summarise(Extent=mean(Extent)) %>% arrange(Year, Month)
ice_data$Date<-as.Date(paste0(ice_data$Year, "-", ice_data$Month,'-01'), format = "%Y-%m-%d")
print(paste0('number of missing values in the ice dataset: ',sum(is.na(co2_data))))

#Join both datasets by Date field
joined_df<-inner_join(ice_data, co2_data, by='Date')

# Initial approach: how well our model fits in a linear regression

linear_model<-lm(Extent ~ Trend + Year + Month, data = joined_df)
summary(linear_model)
linear_model_categorical<-lm(Extent ~ Trend + Year + as.factor(Month), data = joined_df)
summary(linear_model_categorical)


# Second approach: machine learning techniques (knn and random forest)

modeling_df<-joined_df %>% select(-Date) %>% select(-Average) %>% select(-Interpolated)
trainIndex <- createDataPartition(modeling_df$Extent,
                                  p = .8,       # Proportion of data used for training
                                  list = FALSE, # Return the values as a vector (as opposed to a list)
                                  times = 1     # Only create one set of training indices
)
# Subset your data into training and testing set
training_set <- modeling_df[ trainIndex, ] # Select rows with generated indices
test_set <- modeling_df[ -trainIndex, ]    # Remove rows with generated indices

# Grid for the hyperparameter tunning
rf_grid <- expand.grid(mtry=c(3,6,9,12,15))
knn_grid <- expand.grid(k=c(3,4,5,6,7))
knn_model<- train(Extent ~ Trend + Year + Month, data = training_set, 
                  method = "knn", trControl=trainControl(method = "cv", number=3), tuneGrid=knn_grid)
rf_model<- train(Extent ~ Trend + Year + as.factor(Month), data = training_set, 
                 method = "cforest", trControl=trainControl(method = "cv", number=3), tuneGrid=rf_grid)

# Graph of predicted and real values of Random Forest
predictions <- predict(rf_model, test_set)
test_set_with_pred <- test_set
test_set_with_pred$predictions <- predictions

agg_per_month_test <- aggregate(test_set[, 3], list(test_set$Month), mean)
agg_per_month_pr <- aggregate(test_set_with_pred[, 5], list(test_set_with_pred$Month), mean)

ggplot(  ) +
  ggtitle("Graph of predicted and real values of Random Forest") +
  geom_point( aes(x = as.factor(test_set$Month), y = test_set$Extent, color = 'red', alpha = 0.5) ) + 
  geom_point( aes(x = as.factor(test_set$Month) , y = predictions, color = 'blue',  alpha = 0.5)) + 
  geom_line( aes(x = agg_per_month_test$Group.1, y = agg_per_month_test$Extent), col= "blue") +
  geom_line( aes(x = agg_per_month_pr$Group.1, y = agg_per_month_pr$predictions), col= "red") +
  labs(x = "Month", y = "Extent", color = "", alpha = 'Transperency') +
  scale_color_manual(labels = c( "Predicted", "Real"), values = c("blue", "red"))


# Compute statistics on the target variable
summary(modeling_df$Extent)
sd(modeling_df$Extent)

# Compute the prediction error RMSE
print(paste0('RMSE of prediction with knn model in training dataset: ', RMSE(predict(knn_model, training_set), training_set$Extent)))
print(paste0('RMSE of prediction with knn model in test dataset: ', RMSE(predict(knn_model, test_set), test_set$Extent)))

# Compute the prediction error RMSE
print(paste0('RMSE of prediction with random forest model in training dataset: ', RMSE(predict(rf_model, training_set), training_set$Extent)))
print(paste0('RMSE of prediction with random forest model in test dataset: ', RMSE(predict(rf_model, test_set), test_set$Extent)))

