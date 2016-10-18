##Here are the data for the project:
##https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
print("downloading data ....")
download.file(url, destfile = "./coursera_getting_cleaning_data/Dataset.zip")
print('unzipping data ...')
unzip("./coursera_getting_cleaning_data/Dataset.zip", exdir = "./coursera_getting_cleaning_data")

## rename folder
file.rename('./coursera_getting_cleaning_data/UCI HAR Dataset/', "coursera_getting_cleaning_data/UCI")

##You should create one R script called run_analysis.R that does the following.

## 1. Merges the training and the test sets to create one data set.
# read train and test
###Load required packages
library(dplyr)
library(data.table)
library(tidyr)
train1 <- tbl_df(read.table("./coursera_getting_cleaning_data/UCI/train/X_train.txt"))
test1 <- tbl_df(read.table("./coursera_getting_cleaning_data/UCI/test/X_test.txt"))

train2 <- tbl_df(read.table("./coursera_getting_cleaning_data/UCI/train/Y_train.txt"))
test2 <- tbl_df(read.table("./coursera_getting_cleaning_data/UCI/test/Y_test.txt"))

train3 <- tbl_df(read.table("./coursera_getting_cleaning_data/UCI/train/subject_train.txt"))
test3 <- tbl_df(read.table("./coursera_getting_cleaning_data/UCI/test/subject_test.txt"))

# merge
merged_file1 <- rbind(train1, test1)

merged_file2 <- rbind(train2, test2)
setnames(merged_file2, "V1", "activityNum")

merged_file3 <- rbind(train3, test3)
setnames(merged_file3, "V1", "subject")

# read features from features.txt and change column names
features <- tbl_df(read.table("./coursera_getting_cleaning_data/UCI/features.txt"))
setnames(features, names(features), c("featureNum", "featureName"))
colnames(merged_file1) <- features$featureName


mf <- cbind(merged_file1, merged_file2)
mf <- cbind(merged_file3, mf)

# check dimensions of mf
dim(mf)

## 2. Extracts only the measurements on the mean and standard deviation for each measurement.

# check the column names
names(mf)

# check which features have mean and std. will use grep for this
# documentation can be found out at ?grep and regular expression
# subset command is used. tried to use select but was not working
mean_grep_features <- grep('mean|std', names(mf), value = FALSE)
# for part 3, we need to have additional columns
mean_grep_features <- union(c("subject","activityNum"),mean_grep_features)
new_mf <- subset(mf,select=mean_grep_features)

## 3. Uses descriptive activity names to name the activities in the data set
activity<- tbl_df(read.table("./coursera_getting_cleaning_data/UCI/activity_labels.txt"))
setnames(activity, names(activity), c("activityNum","activityName"))

new_mf <- merge(activity, new_mf , by="activityNum", all.x=TRUE)
new_mf$activityName <- as.character(new_mf$activityName)

## 4. Appropriately labels the data set with descriptive variable names.
names(new_mf)<-gsub("std()", "SD", names(new_mf))
names(new_mf)<-gsub("mean()", "MEAN", names(new_mf))
names(new_mf)<-gsub("^t", "time", names(new_mf))
names(new_mf)<-gsub("^f", "frequency", names(new_mf))
names(new_mf)<-gsub("Acc", "Accelerometer", names(new_mf))
names(new_mf)<-gsub("Gyro", "Gyroscope", names(new_mf))
names(new_mf)<-gsub("Mag", "Magnitude", names(new_mf))
names(new_mf)<-gsub("BodyBody", "Body", names(new_mf))

## 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
write.table(new_mf1, "TidyData.csv")

library(knitr)
knit2html("codebook.Rmd")