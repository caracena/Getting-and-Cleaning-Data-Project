library(reshape2)
library(dplyr)
library(plyr)

# read data from files
datatrain <- read.table("../UCI HAR Dataset/train/X_train.txt")
datatest <- read.table("../UCI HAR Dataset/test/X_test.txt")
labeltrain <- read.table("../UCI HAR Dataset/train/y_train.txt")
labeltest <- read.table("../UCI HAR Dataset/test/y_test.txt")
subjecttrain <- read.table("../UCI HAR Dataset/train/subject_train.txt")
subjecttest <- read.table("../UCI HAR Dataset/test/subject_test.txt")
features <- read.table("../UCI HAR Dataset/features.txt")
activity_labels <- read.table("../UCI HAR Dataset/activity_labels.txt")

# merge train and test
data <- rbind(datatrain,datatest)
label <- rbind(labeltrain,labeltest)
subject <- rbind(subjecttrain,subjecttest)

# give name to variables as features file names
colnames(data) <- features$V2
colnames(label) <- c("label")
colnames(subject) <- c("subject")
colnames(activity_labels) <- c("label","label_text")

# extract just mean and std variables
meanstdInd <- grep("mean\\(\\)|std\\(\\)",names(data),value=T)
subdata <- data[,meanstdInd]

# merge labels, subjects and data
subdata <- cbind(subdata,label,subject)

# give descriptive name to activities labels
subdata <- merge(subdata,activity_labels,by="label")

# Step 5
base <- melt(subdata, id = c("label_text","subject"), measure.vars=meanstdInd)
base <- dcast(base, label_text + subject ~ variable, mean)
write.table(base, file="tidy.txt", row.name = FALSE, sep = "\t")