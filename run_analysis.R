library(reshape2)

urlFile <- paste("https://d396qusza40orc.cloudfront.net/",
                "getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",sep="")
nameFile <- "getdata-projectfiles-UCI HAR Dataset.zip" 



###############################################################################
# Part 1 -Getting the data and unzip it                                       #
###############################################################################
#
# If Dataset don't exist download the file and unzip it
#
if (!file.exists("./UCI HAR Dataset")) {
        tempFile <- tempfile()
        download.file(url=urlFile, tempFile, method="curl", cacheOK=FALSE)
        downloadDate <- date()      
        
        # In zip file there are 
        # 2 directory: test and train
        # Each directory has similar files
        
        # load subjects tests and trains
        fname <- unzip(tempFile, list=TRUE)$Name
        unzip(tempFile, files=fname, overwrite=TRUE)      
}

###############################################################################
# Part 2 - Loading the data to R                                              #
###############################################################################
#
#
# loading test data
subject_test <- read.csv("./UCI HAR Dataset/test/subject_test.txt", 
                         header=FALSE)

X_test <- read.csv("./UCI HAR Dataset/test/X_test.txt", 
        sep="", header = FALSE)

y_test <- read.csv("./UCI HAR Dataset/test/y_test.txt", 
                   sep="", header = FALSE)

#--------------------------------------------------------------------------
# loading train data
subject_train <- read.csv("./UCI HAR Dataset/train/subject_train.txt",
                          header=FALSE)
X_train <- read.csv("./UCI HAR Dataset/train/X_train.txt", 
                   sep="", header = FALSE)
y_train <- read.csv("./UCI HAR Dataset/train/y_train.txt", 
                   sep="", header = FALSE)

#--------------------------------------------------------------------------
# Loading Activity Labels
activity_labels <- read.csv("./UCI HAR Dataset/activity_labels.txt", 
                            sep="", header = FALSE)
labelsActivity <- factor(activity_labels$V2)


###############################################################################
# Part 3 - Extractiong only index of measurements on the mean and standard    #
# deviation                                                                   #
###############################################################################
#
#--------------------------------------------------------------------------
# loading Features name and extracting only index of measurements on
# Mean and Standard Deviation
featuresName <- read.csv("./UCI HAR Dataset/features.txt", header=FALSE, 
                         sep=" ")
measuresMean <- c( grep("mean", featuresName$V2, perl=TRUE, 
                        value = FALSE, ignore.case = TRUE)  )
measuresStd <- c( grep("std", featuresName$V2, perl=TRUE, 
                       value = FALSE, ignore.case = TRUE)  )
idx <- sort(c(measuresMean, measuresStd))




###############################################################################
# Part 4 - Merging training and test data                                     #
###############################################################################
#
# In this step is very important to keep the same order of combination. In this
# script we are putting train data first.
X_data <- rbind(X_train[idx], X_test[idx])
y_data <- rbind(y_train, y_test)
subject_data <- rbind(subject_train, subject_test)



###############################################################################
# Part 5 - Putting descriptive names on features of data set.                 #
###############################################################################
#
# Result Data frame
dataClean <- cbind(subject_data, labelsActivity[y_data$V1], X_data)

# Changing column names
featuresLevels <- levels(featuresName$V2)
names(dataClean) <- c("subject", "activity", 
                      featuresLevels[featuresName$V2[idx]])



###############################################################################
# Part 6 - Creating a new second tidy data set                                #
###############################################################################
#
# New tidy Data set with the average of each variable for each activity and
# each subject
temp1 <- melt(dataClean, id=c("subject", "activity"), 
                   measure.var=featuresLevels[featuresName$V2[idx]])
varFactors <- list(as.factor(temp1$subject), 
                   as.factor(temp1$activity), 
                   as.factor(temp1$variable))
temp2 <- tapply(temp1$value, varFactors, mean)

DataClean2 <- melt(temp2)
names(DataClean2) <- c("subject", "activity", "measurement_name", "avg_value_measurement" )

# Writting data to tidy_data_set.xt
write.table(DataClean2, file="tidy_data_set.txt", row.names=FALSE)
