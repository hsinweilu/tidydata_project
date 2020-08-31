# Project for Coursera's "Getting and Cleaning Data"

# load libraries
library(tidyverse)
library(data.table)

run_analysis <- function() {
	# returns a tidy tibble with 4 columns
	#	1 'subject' : subject number
	#	2 'activity': activity name
	#	3 'variable': feature names that contain mean() or std()
	#	4 'average' : average value 

	# 1. combine test and train datasets
	alldata <- read_data()

	# 2. Extracts only the measurements on the mean 
	#    and standard deviation for each measurement.
	# i.e. select columns that contains "mean()" or "std()"
	alldata <- alldata %>%
		select("group", 
		       "subject", 
		       "activity", 
		       contains(c("mean()","std()"))
		       )
	# melt the data
	data_melt <- melt(alldata, id=c("group", "subject", "activity"))

	# 5. creates a tidy data set with the average 
	#    of each variable for each activity done by each subject.
	data_avg <- data_melt %>% 
	    	group_by(subject, activity, variable) %>%
	    	summarize(average = mean(value))

	# save data in the current folder
	write.table(data_avg, "data_avg.txt", row.names=F)
    	
    	return(data_avg)
}

read_data <- function() {
	###
	# read data from files
	# returns a data.table in which
	#	column 1 (name='group'): group name ('test' or 'train')
	#	column 2 (name='subject'): subject#
	#	column 3 (name='activity'): activity name
	# 	column 4-564 (name=feature name):  measurements from feature 1-561 such as tBodyAcc-mean()-X
	###

	# load feature names, activity names
	feature_names <- fread('./UCI HAR Dataset/features.txt')
	activity_names <- fread('./UCI HAR Dataset/activity_labels.txt')

	# load dataset
	# dataset for "test" group
	subject_test <- fread('./UCI HAR Dataset/test/subject_test.txt')
	x_test <- fread('./UCI HAR Dataset/test/X_test.txt')
	y_test <- fread('./UCI HAR Dataset/test/y_test.txt')

	# dataset for the "train" group
	subject_train <- fread('./UCI HAR Dataset/train/subject_train.txt')
	x_train <- fread('./UCI HAR Dataset/train/X_train.txt')
	y_train <- fread('./UCI HAR Dataset/train/y_train.txt')

	# rename all the x_test, x_train columns to feature_names
	names(x_test) <- feature_names$V2
	names(x_train) <- feature_names$V2

	# 1. Merges the training and the test sets to create one data set.
	# data.table for the group "test"
	test <- data.table(
	    'group' = 'test',
	    'subject' = subject_test$V1,
	    'activity' = y_test$V1
	)
	# combine the features for each measurement
	test <- cbind(test, x_test)

	# data.table for the group "train"
	train <- data.table(
	    'group' = 'train',
	    'subject' = subject_train$V1,
	    'activity' = y_train$V1
	)
	# combine the features for each measurement
	train <- cbind(train, x_train)

	# combine the test and train data into a single dataset
	alldata <- rbind(test, train)

	# Replace number with name in the 'activity' column
	num2name <- function(x) activity_names$V2[x]
	alldata[, activity := num2name(activity)]

	return(alldata)
}

# run analysis and save data
run_analysis()
