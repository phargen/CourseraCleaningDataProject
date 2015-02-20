library(plyr)

# Read activity labels and features for later use in providing
# descriptive activity names and descriptive variable (column) names
activities <- read.table(file="activity_labels.txt",
                         col.names=c("ActivityNum","Activity"), 
                         colClasses=c("integer", "character"))
features <- read.table(file="features.txt",
                       col.names=c("FeatureNum","Feature"), 
                       colClasses=c("integer", "character"))

##### Number 4 #####
# load subject and activity identification columns
subject_test <- read.table(file="test/subject_test.txt",
                           col.names="SubjectNum", colClasses = "integer")
subject_train <- read.table(file="train/subject_train.txt",
                           col.names="SubjectNum", colClasses = "integer")
activity_test <- read.table(file="test/y_test.txt",
                           col.names="ActivityNum", colClasses = "integer")
activity_train <- read.table(file="train/y_train.txt",
                            col.names="ActivityNum", colClasses = "integer")

##### Number 2 & 4 #####
# determine which feature columns contain mean and std and prepare to read just those columns
colToKeep <- grepl("mean|std",features[[2]], ignore.case=TRUE)
#colToKeepNames <- grep("mean|std",features[[2]], ignore.case=TRUE, value = TRUE) 
# not needed because need to name columns even if not read
classes <- sapply(colToKeep, FUN = function(x) { if(x) "numeric" else "NULL" })

# read feature data from cases files
cases_test <- read.table(file="test/X_test.txt",
                         col.names=features[[2]], colClasses = classes)
cases_train <- read.table(file="train/X_train.txt",
                            col.names=features[[2]], colClasses = classes)

##### Number 1 #####
# combine all the above data frames into one large data frame
# first cbind the test and train data together separately
all_test <- cbind(activity_test, subject_test, cases_test)
all_train <- cbind(activity_train, subject_train, cases_train)
# then rbind the test and train data together
all_combined <- rbind(all_test, all_train)

##### Number 3 #####
# change activity number to human readable activity names (factors) and rename column
all_combined$ActivityNum = as.factor(all_combined$ActivityNum)
all_combined$ActivityNum = sapply(all_combined$ActivityNum, FUN = function(x) { activities[x, 2] })
names(all_combined)[names(all_combined)=="ActivityNum"] <- "Activity"

##### Number 4 #####
newHeaders <- gsub("[. ]", "", names(all_combined)) #remove spaces and '.' from column names
newHeaders <- gsub("tBodyAcc", "Acceleration", newHeaders) #perform other name substitutions
newHeaders <- gsub("tGravityAcc", "GravityAcceleration", newHeaders)
newHeaders <- gsub("tBody", "", newHeaders)
newHeaders <- gsub("fBodyBodyAcc", "fftAcceleration", newHeaders)
newHeaders <- gsub("fBodyBody", "fft", newHeaders)
newHeaders <- gsub("fBodyAcc", "fftAcceleration", newHeaders)
newHeaders <- gsub("fBody", "fft", newHeaders)
newHeaders <- gsub("fBody", "", newHeaders)
newHeaders <- gsub("mean", "Mean", newHeaders)
newHeaders <- gsub("std", "StandardDeviation", newHeaders)
newHeaders <- gsub("gravity", "Gravity", newHeaders)
names(all_combined) <- make.names(newHeaders, unique=TRUE) #remove duplicates if exist

##### Number 5 #####
all_combined <- arrange(all_combined, Activity, SubjectNum)
averageOfEachFeaturePerActivityAndSubject <- ddply(all_combined, .(Activity, SubjectNum), colwise(mean))

write.table(averageOfEachFeaturePerActivityAndSubject,
            file="getdata-011_projTidy.txt", row.names=FALSE)