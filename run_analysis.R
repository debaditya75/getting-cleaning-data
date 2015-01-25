# This is a R script called run_analysis.R that does the following
# Merges the training and the test sets to create one data set.
# Extracts only the measurements on the mean and standard deviation for each measurement. 
# Uses descriptive activity names to name the activities in the data set
# Appropriately labels the data set with descriptive variable names. 
# From the data set in step 4, creates a second, independent tidy data set with the 
# average of each variable for each activity and each subject.

# The program assumes the data has been downloaded in a folder titled "UCI HAR Dataset"
# Inside this folder both the test and the training set files are available.

# load the packages required by the program
#the data.table is used 
library("data.table")
# for the merge function
library("dplyr")

# 
# Load and process test_x & test_y data.
test_x <- read.table("./UCI HAR Dataset/test/X_test.txt")
test_y <- read.table("./UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")

# Load the feature names
features <- read.table("./UCI HAR Dataset/features.txt")[,2]

# Load the activity names
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")

# Extract the measurement names on the mean and standard deviation
extract_features <- grepl("mean|std", features)

# Now assign the features as the column names
names(test_x) = features

# Extract only the measurements on the mean and standard deviation for each measurement.
test_x = test_x[,extract_features]

# Load activity labels
test_y <- merge(test_y,activity_labels,by.x="V1",by.y="V1")

names(test_y) = c("Activity_ID", "Activity_Label")

names(subject_test) = "subject"

# Merge column data to the training set
test_data <- cbind(as.data.table(subject_test), test_y, test_x)

# Load and process train_x & train_y data.

train_x <- read.table("./UCI HAR Dataset/train/X_train.txt")
train_y <- read.table("./UCI HAR Dataset/train/y_train.txt")

subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
names(train_x) = features

# Extract only the measurements on the mean and standard deviation for each measurement.
train_x = train_x[,extract_features]

# Load activity data
train_y <- merge(train_y,activity_labels,by.x="V1",by.y="V1")
names(train_y) = c("Activity_ID", "Activity_Label")
names(subject_train) = "subject"

# Merge column data to the training set
train_data <- cbind(as.data.table(subject_train), train_y, train_x)

# Merging test and train data
data = rbind(test_data, train_data)

id_labels   = c("subject", "Activity_ID", "Activity_Label")
tidy_data   = suppressWarnings(aggregate(data, by=list(Activity_Labels= data$Activity_Label, subjects=data$subject),FUN=mean))
tidy_data1 <- tidy_data[,!(names(tidy_data) %in% id_labels)]
write.table(tidy_data1, file = "./tidy_data.txt")
