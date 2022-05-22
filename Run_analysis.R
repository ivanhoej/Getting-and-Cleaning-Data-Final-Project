##  1 Download the file and store in the data folder
##  2 - Unzip the file
##  3 - Unzipped Files are in the Folder UCI HAR Dataset.  Show the list of files
# [1]  "activity_labels.txt"                          
# [2]  "features.txt"                                
# [3]  "features_info.txt"                            
# [4]  "README.txt"                                  
# [5]  "test/Inertial Signals/body_acc_x_test.txt"    
# [6]  "test/Inertial Signals/body_acc_y_test.txt"   
# [7]  "test/Inertial Signals/body_acc_z_test.txt"    
# [8]  "test/Inertial Signals/body_gyro_x_test.txt"  
# [9]  "test/Inertial Signals/body_gyro_y_test.txt"   
# [10] "test/Inertial Signals/body_gyro_z_test.txt"  
# [11] "test/Inertial Signals/total_acc_x_test.txt"   
# [12] "test/Inertial Signals/total_acc_y_test.txt"  
# [13] "test/Inertial Signals/total_acc_z_test.txt"   
# [14] "test/subject_test.txt"                       
# [15] "test/X_test.txt"                              
# [16] "test/y_test.txt"                             
# [17] "train/Inertial Signals/body_acc_x_train.txt"  
# [18] "train/Inertial Signals/body_acc_y_train.txt" 
# [19] "train/Inertial Signals/body_acc_z_train.txt"  
# [20] "train/Inertial Signals/body_gyro_x_train.txt"
# [21] "train/Inertial Signals/body_gyro_y_train.txt" 
# [22] "train/Inertial Signals/body_gyro_z_train.txt"
# [23] "train/Inertial Signals/total_acc_x_train.txt" 
# [24] "train/Inertial Signals/total_acc_y_train.txt"
# [25] "train/Inertial Signals/total_acc_z_train.txt" 
# [26] "train/subject_train.txt"                     
# [27] "train/X_train.txt"                            
# [28] "train/y_train.txt"  

#See the README.txt file for the detailed information on the dataset.  The files that will be used to load data are listed as follows:
#For the purposes of this project, the files in the Inertial Signals folders are not used.
#Here are the files that will be used:
#     test/subject_test.txt
#     test/X_test.txt
#     test/y_test.txt
#     train/subject_train.txt
#     train/X_train.txt
#     train/y_train.txt

# Based on the above files we can organize the data so that:

#   Values of Varible Activity consist of data from "Y_train.txt" and "Y_test.txt"
#   Values of Varible Subject consist of data from "subject_train.txt" and subject_test.txt"
#   Values of Varibles Features consist of data from "X_train.txt" and "X_test.txt"
#   Names of Varibles Features come from "features.txt"
#   Levels of Varible Activity come from "activity_labels.txt"
#   Activity, Subject and Features will be descriptive variable names for data in the data frame.

#4 - Read data from the files into the Variables:
features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","functions"))
activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")

#5 Look at and test the properties of the above variables (Optional to run these commands)
#   str(features)
#   str(activities)
#   str(subject_test)
#   str(X_test)
#   str (y_test)
#   str(subject_train)
#   str(x_train)
#   str(y_train)

#6 Merging the Training and Test sets to create one data set
# Concatenate the tables by rows

X <- rbind(x_train, x_test)
Y <- rbind(y_train, y_test)
Subject <- rbind(subject_train, subject_test)
Merged_Data <- cbind(Subject, Y, X)
TidyData <- Merged_Data %>% select(subject, code, contains("mean"), contains("std"))
TidyData$code <- activities[TidyData$code, 2]

#7 Set names to variables

names(TidyData)[2] = "activity"
names(TidyData)<-gsub("Acc", "Accelerometer", names(TidyData))
names(TidyData)<-gsub("Gyro", "Gyroscope", names(TidyData))
names(TidyData)<-gsub("BodyBody", "Body", names(TidyData))
names(TidyData)<-gsub("Mag", "Magnitude", names(TidyData))
names(TidyData)<-gsub("^t", "Time", names(TidyData))
names(TidyData)<-gsub("^f", "Frequency", names(TidyData))
names(TidyData)<-gsub("tBody", "TimeBody", names(TidyData))
names(TidyData)<-gsub("-mean()", "Mean", names(TidyData), ignore.case = TRUE)
names(TidyData)<-gsub("-std()", "STD", names(TidyData), ignore.case = TRUE)
names(TidyData)<-gsub("-freq()", "Frequency", names(TidyData), ignore.case = TRUE)
names(TidyData)<-gsub("angle", "Angle", names(TidyData))
names(TidyData)<-gsub("gravity", "Gravity", names(TidyData))

#8 Merge columns to get the data frame (FinalData) for all the required data

#9 - Extract the mean and standard deviation measurements
# Create a subset name of Features with measurements on the mean() and standard deviation - std()

#10 Subset the Data Frame (FinalData) by selected names of features (Subject and Activity)

FinalData <- TidyData %>%
  group_by(subject, activity) %>%
  summarise_all(funs(mean))
write.table(FinalData, "FinalData.txt", row.name=FALSE)

#11 - Check the structure of the data frame for FinalData
str(FinalData)


