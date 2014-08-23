---
title: 'Project: Getting and Cleaning Data'
author: "ctakamiya"
date: "20 de agosto de 2014"
 
---

#Introduction

This project is based on data that was made available by the course: Getting and 
Cleaning Data, Data Science Specialization. The original source is "Human 
Activity Recognition Using Smartphones Dataset".

In this repository is available the original code book for convenience purposes. 
This file was renamed from **_features\_info.txt_** to 
**_original\_features\_info.txt_**.

The script developed for this project was designed to avoid manual handling 
on original data set. The name of file is "run_analysis.R" and it is 
divided in 6 main parts:

* Downloading the data set and unzip it.
* Loading the data to R.
* Extracting only index of measurements on the mean and standard deviation
* Merging training and test data.
* Putting descriptive names on features of data set.
* Creating a new second tidy data set.

#Description 
## Part 1 - Downloading the data and unzip it.

This part of script is responsible for to download the data set and decompress 
it into current directory. 

After running this part of script, a new directory named UCI HAR Dataset will be
created.

Before downloading of the data set, the script verifies if folder 
"UCI HAR Dataset" exists at current directory. If it doesn't exist, the download
of data set will be proceeded,  otherwise this step will be skipped. 


## Part 2 - Loading the data to R.
Data of training and test are loaded in the second part of script. The following 
data are loaded: subject, training, test, activity and activity labels.
In this part of script these data frame are created: 

* subject_train
* subject_test
* X_train 
* X_test
* y_train
* y_test

## Part 3 - Extracting only index of measurements on the mean and standard deviation

The content of features.txt file is reused in this script. All features name is 
loaded from features.txt into featuresName data frame. 

However, only index of features related with mean and standard deviation of 
measurements are chosen. 

This activity is facilitated by the function "grep". It searches for matches to 
words "mean" and "std" within each featuresName$V2.

The result of this search is stored in the vector idx.

## Part 4 - Merging training and test data 

In this part of script all data in X_train, X_test, y_train, y_test, 
subject_train and subject_test are merged. It is very important in this step don't 
change the orders of merging. First all training data and then test data.

Note the use of idx vector to create subset of the training and test data only
with measures on means and standard deviations.

## Part 5 - Putting descriptive names on features of data set. 
So far the names of features had no meaning. For example, all column names in 
X_train are V1, V2, and so on.
In this part of script, all data is put together in dataClean data frame and all
columns receive the correct names from featuresName. Note that the correct name 
is selected in featuresName because of use the idx vector and the activity 
values are replaced by the corresponding labels.

## Part 6 - Creating a new second tidy data set  

This is the last part of script responsible for create new data set with the 
average of each variable for each activity and each subject. To accomplish this 
task, the fuction tapply is used. 

The new data set is compound by subject,activity, name of  the measurements, 
its average value and unit

For example, the first row in new data set:

1 "LAYING" "tBodyAcc-mean()-X" 0.22159824394 "g"

The meaning is: the subject is 1, his/her activity is "LAYING", the measurements
is "tBodyAcc-mean()-X" and the value "0.22159824394" is the average of all value 
in this measurement, in activity "LAYING" of subject "1". The unit is "g"

The generated new data set can be loaded with the following command:

dataSet <- read.csv("tidy\_data\_set.txt", sep=" ")



