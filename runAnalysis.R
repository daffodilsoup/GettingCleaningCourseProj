# Create a script, run_analysis.R

setwd("C:/Users/melissah/Desktop/Coursera/UCI HAR Dataset")

# Read in activity labels and features
activity    <- read.table("./activity_labels.txt",     header=FALSE) #loads activity_labels.txt
features    <- read.table("./features.txt",            header=FALSE) #loads features.txt

# Read in train data
x_train     <- read.table("./train/X_train.txt",       header=FALSE) #loads x_train.txt
y_train     <- read.table("./train/y_train.txt",       header=FALSE) #loads y_train.txt
sub_train   <- read.table("./train/subject_train.txt", header=FALSE) #loads subject_train.txt

# Read in test data
x_test      <- read.table("./test/X_test.txt",         header=FALSE) #loads x_test.txt
y_test      <- read.table("./test/y_test.txt",         header=FALSE) #loads y_test.txt
sub_test    <- read.table("./test/subject_test.txt",   header=FALSE) #loads subject_test.txt

# Merge training and test sets to create a single dataset.
data        <- rbind(x_train, x_test)
subjects    <- rbind(sub_train, sub_test)
activity    <- rbind(y_test, y_train)

names(data)     <- features[ ,2]
names(subjects) <- "subjectID"
names(activity) <- "activityID"

final_data   <- cbind(data, subjects, activity)
column_names <- names(final_data)

# Extract measurements on the mean and std dev of each measurement
# This section of code pulls out only the columns that are relevant: the subject,
# activity, mean, and standard deviation, and updates the column names.
extract_measures <- grepl("subjectID|activityID|mean & !meanFreq|std", column_names)
extracted_data   <- final_data[ ,extract_measures]
column_names     <- names(extracted_data)

# Use descriptive activity names to name the activities in the dataset
# this section of code adds a new column, "activity desc", and sets it to the appropriate
# activity name based on the activityID in that row.
extracted_data$activity_desc <- character(nrow(extracted_data))

extracted_data[extracted_data$activityID==1,]$activity_desc <- "walking"
extracted_data[extracted_data$activityID==2,]$activity_desc <- "walking_upstairs"
extracted_data[extracted_data$activityID==3,]$activity_desc <- "walking_downstairs"
extracted_data[extracted_data$activityID==4,]$activity_desc <- "sitting"
extracted_data[extracted_data$activityID==5,]$activity_desc <- "standing"
extracted_data[extracted_data$activityID==6,]$activity_desc <- "laying"

# Labels data with descriptive variable names
# Remove some of the weird punctuation and codes from variable names.

# Remove parentheses
names(extracted_data) <- gsub('//(|//)', "", names(extracted_data), perl=TRUE)

# Make R-style names
names(extracted_data) <- make.names(names(extracted_data))

# Do some general column name cleanup
names(extracted_data) <- gsub('Acc',"Acceleration",names(extracted_data))
names(extracted_data) <- gsub('GyroJerk',"AngularAcceleration",names(extracted_data))
names(extracted_data) <- gsub('Gyro',"AngularSpeed",names(extracted_data))
names(extracted_data) <- gsub('Mag',"Magnitude",names(extracted_data))
names(extracted_data) <- gsub('^t',"TimeDomain.",names(extracted_data))
names(extracted_data) <- gsub('^f',"FrequencyDomain.",names(extracted_data))
names(extracted_data) <- gsub('\\.mean',".Mean",names(extracted_data))
names(extracted_data) <- gsub('\\.std',".StandardDeviation",names(extracted_data))
names(extracted_data) <- gsub('Freq\\.',"Frequency.",names(extracted_data))
names(extracted_data) <- gsub('Freq$',"Frequency",names(extracted_data))

# Create a second, independent tidy dataset with the avg of each variable for each activity and each subject

library(plyr)
ind_dataset <- aggregate(. ~subjectID + activity_desc, extracted_data, mean)
ind_dataset <- ind_dataset[order(ind_dataset$subjectID, ind_dataset$activity_desc),]
write.table(ind_dataset, file='tidy_data.txt', row.name=FALSE)
