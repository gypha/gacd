## Get the working directory.
getwd()
## Download the dataset in the working directory.
fileUrl<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = "./data/dataset.zip")
## Unzip the dataset.
unzip("./data/dataset.zip")
##Load the feature info and extracting measurements on mean and standard deviation.
features_txt<-read.table("UCI HAR Dataset/features.txt")
features_ms<-grep(".*mean.*|.*std.*", features_txt[,2])
features_data<-features_txt[features_ms,2]
features_data<-gsub("mean","Mean", features_data)
features_data<-gsub("-std","Std",features_data)
features_data<-gsub("[()]","",features_data)
## Load the activity info.
activity_labels<-read.table("UCI HAR Dataset/activity_labels.txt")
##Load the training and test datasets.
subject_train<-read.table("UCI HAR Dataset/train/subject_train.txt")
X_train<-read.table("UCI HAR Dataset/train/X_train.txt")
y_train<-read.table("UCI HAR Dataset/train/y_train.txt")
subject_test<-read.table("UCI HAR Dataset/test/subject_test.txt")
X_test<-read.table("UCI HAR Dataset/test/X_test.txt")
y_test<-read.table("UCI HAR Dataset/test/y_test.txt")
## Subsetting training and test datasets so as to keep only those columns that 
## reflect mean or standard deviation.
x_train<-X_train[features_ms]
x_test<-X_test[features_ms]
##Merging the two datasets together.
train<-cbind(subject_train,x_train,y_train)
test<-cbind(subject_test,x_test,y_test)
data<-rbind(train,test)
##Labeling the dataset with variable names.
colnames(data)<-c("subject",features_data,"activity")
##Factoring the columns named subject and activity.
data$activity<-factor(data$activity, levels=activity_labels[,1], labels = activity_labels[,2])
data$subject<-as.factor(data$subject)
##Creating a dataset  with the average of each variable for each activity and 
##each subject.
library(reshape2)
data1<-melt(data, id = c("subject", "activity"))
meandata <- dcast(data1, subject + activity ~ variable, mean)
write.table(meandata, "tidy.txt", row.names = FALSE, quote = FALSE)

