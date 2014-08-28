## Load data into a dataframe
getwd()
setwd("C:/Python/DataScienceCoursera/assignment5")
data <- read.csv("seaflow_21min.csv")

## Get overall counts of categories
summary(data)

## Split data into training and test sets
nrow(data)
set.seed(1234)
samplesize <- floor(nrow(data)*0.5)
testidx <- sample(seq_len(nrow(data)), size=samplesize, replace=FALSE)
testdata <- data[testidx,]
traindata <- data[-testidx,]

meantime_train <- mean(traindata[,"time"])

## Plot pe by chl_small, color by pop
library(ggplot2)
qplot(pe, chl_small, data=traindata, colour=pop)

## Train a decision tree
library(rpart)
fol <- formula(pop ~ fsc_small + fsc_perp + fsc_big + pe + chl_small + chl_big)
model <- rpart(fol, method="class", data=traindata)
print(model)

## Evaluate decision tree on test data
tree_pred <- predict(object=model, newdata=testdata, type="class") 
tree_pred[1:5] == testdata[1:5,"pop"]
numcorrect <- sum(tree_pred == testdata[,"pop"])
accuracy <- numcorrect / nrow(testdata)

## Random Forest
library(randomForest)
model <- randomForest(fol, data=traindata)
forest_pred <- predict(object=model, newdata=testdata, type="class") 
forest_pred[1:5] == testdata[1:5,"pop"]
numcorrect <- sum(forest_pred == testdata[,"pop"])

accuracy <- numcorrect / nrow(testdata)
importance(model)

## SVM 
library(e1071)
model <- svm(fol, data=traindata)
svm_pred <- predict(object=model, newdata=testdata, type="class") 
numcorrect <- sum(svm_pred == testdata[,"pop"])
accuracy <- numcorrect / nrow(testdata)

## Confusion Matrix
table(pred=tree_pred, true=testdata[,"pop"])
table(pred=forest_pred, true=testdata[,"pop"])
table(pred=svm_pred, true=testdata[,"pop"])


## Plot data to find data integrity issues
qplot(pe, data=data, geom="histogram")
qplot(fsc_big,data=data, geom="histogram")

qplot(time, chl_big, data=data, colour=pop)

clean_data <- data[data$file_id!=208,]
qplot(time, chl_big, data=clean_data)

## Redo SVM with clean data
set.seed(1234)
samplesize <- floor(nrow(clean_data)*0.5)
testidx_clean <- sample(seq_len(nrow(clean_data)), size=samplesize, replace=FALSE)
testdata_clean <- data[testidx_clean,]
traindata_clean <- data[-testidx_clean,]

model <- svm(fol, data=traindata_clean)
svm_pred_clean <- predict(object=model, newdata=testdata_clean, type="class") 
numcorrect <- sum(svm_pred_clean == testdata_clean[,"pop"])
accuracy <- numcorrect / nrow(testdata_clean)
