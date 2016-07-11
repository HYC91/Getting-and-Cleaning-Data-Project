rm(list=ls())

library(data.table)
library(plyr)

## Download and save the file in the data folder
if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Dataset.zip",method="libcurl")

## Unzip the file
unzip(zipfile="./data/Dataset.zip",exdir="./data")

## Unzipped files are saved in the folder 'UCI HAR Dataset'. Get the list of the files
DataFile  <- file.path("./data" , "UCI HAR Dataset")
files<-list.files(DataFile, recursive=TRUE)
files

## Read Supporting Metadata

# The supporting metadata include feature names and activity labels. 
# They are loaded into the following variables.
featureNames <- read.table(file.path(DataFile, "features.txt"))
activityLabels <- read.table(file.path(DataFile, "activity_labels.txt"), header = FALSE)
featureNames
activityLabels

## Format training and test data sets
# Both training and test data sets are separated into subject, activity and features. 
# They are present in three different files.

# Read training data
dataActivityTrain <- read.table(file.path(DataFile, "train", "Y_train.txt"),header = FALSE)
dataSubjectTrain <- read.table(file.path(DataFile, "train", "subject_train.txt"),header = FALSE)
dataFeaturesTrain <- read.table(file.path(DataFile, "train", "X_train.txt"),header = FALSE)

# Read test data
dataActivityTest  <- read.table(file.path(DataFile, "test" , "Y_test.txt" ),header = FALSE)
dataSubjectTest  <- read.table(file.path(DataFile, "test" , "subject_test.txt"),header = FALSE)
dataFeaturesTest  <- read.table(file.path(DataFile, "test" , "X_test.txt" ),header = FALSE)

## Step 1. Merge the training and the test sets to create one data set

# Combine the data tables by rows into 'subject', 'activity', and 'features'
Subject <- rbind(dataSubjectTrain, dataSubjectTest)
Activity<- rbind(dataActivityTrain, dataActivityTest)
Features<- rbind(dataFeaturesTrain, dataFeaturesTest)

# Name the columns in 'Features' from the metadata into a variable
colnames(Features) <- t(featureNames[2])

# Merge the data in Features, Activity, and Subject into 'completeData'
colnames(Activity)<- "Activity"
colnames(Subject)<- "Subject"
completeData <- cbind(Features, Activity, Subject)

## Step 2. Extract only the measurements on the mean and standard deviation for each measurement

# Extract the column indices that have either mean or std in them.
columnsWithMeanStd <- grep(".*Mean.*|.*Std.*", names(completeData), ignore.case=TRUE)
columnsWithMeanStd

# Add activity and subject columns to the list and check the dimension of 'completeData"
requiredColumns <- c(columnsWithMeanStd, 562, 563)
dim(completeData)

# Create 'Data' with selected columns in 'requiredColumns' and check the dimension of 'requiredColumns'.
Data <- completeData[,requiredColumns]
dim(Data)

## Step 3. Use descriptive activity names to name the activities in the data set

# The 'activity' field in 'Data' is of numeric type. Need to change it to character type in order to accept activity names.
# The activity names are from metadata 'activityLabels.'
Data$Activity <- as.character(Data$Activity)
for (i in 1:6){
  Data$Activity[Data$Activity == i] <- as.character(activityLabels[i,2])
}

# Factor the 'activity' variable when the activity names are updated.
Data$Activity <- as.factor(Data$Activity)

## Step 4. Appropriately label the data set with descriptive variable names

# List the names of the variables in 'Data'
names(Data)

# Names in 'Data' show that the following acronyms can be replaced:

#- prefix t can be replaced by  time
#- prefix f can be replaced by frequency
#- Acc can be replaced by Accelerometer
#- Gyro can be replaced by Gyroscope
#- Mag can be replaced by Magnitude
#- BodyBody can be replaced by Body

names(Data)<-gsub("^t", "time", names(Data))
names(Data)<-gsub("^f", "frequency", names(Data))
names(Data)<-gsub("Acc", "Accelerometer", names(Data))
names(Data)<-gsub("Gyro", "Gyroscope", names(Data))
names(Data)<-gsub("Mag", "Magnitude", names(Data))
names(Data)<-gsub("BodyBody", "Body", names(Data))
names(Data)<-gsub("tBody", "TimeBody", names(Data))
names(Data)<-gsub("-mean()", "Mean", names(Data), ignore.case = TRUE)
names(Data)<-gsub("-std()", "STD", names(Data), ignore.case = TRUE)
names(Data)<-gsub("-freq()", "Frequency", names(Data), ignore.case = TRUE)
names(Data)<-gsub("angle", "Angle", names(Data))
names(Data)<-gsub("gravity", "Gravity", names(Data))

# Show edited variable names in 'Data'
names(Data)

## Step 5. From the data set in Step 4, create a second, independent tidy data set with the average of each variable #for each activity and each subject.

# Set 'subject' as a factor variable
Data$Subject <- as.factor(Data$Subject)
Data <- data.table(Data)

# Create 'tidyData' as a data set with average for each activity and subject. 
# Order the entries in tidyData and write it into data file 'Tidy.txt' that contains the processed data.
tidyData <- aggregate(. ~Subject + Activity, Data, mean)
tidyData <- tidyData[order(tidyData$Subject,tidyData$Activity),]
write.table(tidyData, file = "Tidy.txt", row.names = FALSE)


