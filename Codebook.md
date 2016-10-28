The script attached does the following as was asked in the assignment

0. Preparation steps:

*** Creates accelerometers_data directory to store script files and output table.
*** Loads libraries to be used in the script: plyer, data.table and dplyr

1. Merges the training and the test sets to create one data set.
*** Downloads the files and unzips the ones that will be used in the script
*** Creates tables from test and train files
*** Downloads feautres files which contains that variable names
*** Joins y test and train data to x data tables
*** Add subject who performed the activity
*** Join x_test and x_train tables into a table called merged

2. Extracts only the measurements on the mean and standard deviation for each measurement.
***Using grep functionality, script identifies measurements for mean and for standard deviation (std) and then creates two tables. One called mean_measurements with all mean measurements and one called std_measurements for all standard deviation measurements.

3. Uses descriptive activity names to name the activities in the data set
*** View table called activities to undestand the activity names
*** Replace activities from their id to their name

4. Appropriately labels the data set with descriptive variable names.
*** Using gsub functionality, script replaces different words in the variable names
	---If it begins with t, replace with time
	---If it begins with f, replace with frequency
	---If it contains ACC, replace with Accelerometer
	---If it contains GYRO, replace with Gyroscope
	---If it contains MAG, replace with Magnitude

5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
*** Convert merged table to a data.table called datatable_merged
*** Create tidy_data table using lapply and applying mean by subject and activity
*** Write the table to disk using name tidy_data.txt