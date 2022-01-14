##Lou Shane Javier
##BS in Statistics III
##CMSC 197
##2nd Mini Project


getwd()
setwd("C:/Users/Acer/Desktop")


if(!file.exists("./specdata")){
  dir.create("./specdata")}
setwd("C:Users/Acer/Desktop/specdata")
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./specdata/Dataset.zip")

unzip(zipfile="./specdata/Dataset.zip",exdir="./specdata")
path_rf <- file.path("./specdata" , "UCI HAR Dataset")
files<-list.files(path_rf, recursive=TRUE)
files


ActivityTest  <- read.table(file.path(path_rf, "test" , "Y_test.txt" ),header = FALSE)
ActivityTrain <- read.table(file.path(path_rf, "train", "Y_train.txt"),header = FALSE)
SubjectTrain <- read.table(file.path(path_rf, "train", "subject_train.txt"),header = FALSE)
SubjectTest  <- read.table(file.path(path_rf, "test" , "subject_test.txt"),header = FALSE)
FeaturesTest  <- read.table(file.path(path_rf, "test" , "X_test.txt" ),header = FALSE)
FeaturesTrain <- read.table(file.path(path_rf, "train", "X_train.txt"),header = FALSE)


str(ActivityTest)
str(ActivityTrain)
str(SubjectTrain)
str(SubjectTest)
str(FeaturesTest)
str(FeaturesTrain)


Subject <- rbind(SubjectTrain, SubjectTest)
Activity<- rbind(ActivityTrain, ActivityTest)
Features<- rbind(FeaturesTrain, FeaturesTest)

names(Subject)<-c("subject")
names(Activity)<- c("activity")
FeaturesNames <- read.table(file.path(path_rf, "features.txt"),head=FALSE)
names(Features)<- FeaturesNames$V2

Combine <- cbind(Subject, Activity)
Data <- cbind(Features, Combine)


subdataFeaturesNames<-FeaturesNames$V2[grep("mean\\(\\)|std\\(\\)", FeaturesNames$V2)]
selectedNames<-c(as.character(subdataFeaturesNames), "subject", "activity" )
Data<-subset(Data,select=selectedNames)
str(Data)


activityLabels <- read.table(file.path(path_rf, "activity_labels.txt"),header = FALSE)
extractedData$Activity <- as.character(extractedData$Activity)
for (i in 1:6){
  extractedData$Activity[extractedData$Activity == i] <- as.character(activityLabels[i,2])
}
head(Data$activity,30)



names(Data)<-gsub("^t", "time", names(Data))
names(Data)<-gsub("^f", "frequency", names(Data))
names(Data)<-gsub("Acc", "Accelerometer", names(Data))
names(Data)<-gsub("Gyro", "Gyroscope", names(Data))
names(Data)<-gsub("Mag", "Magnitude", names(Data))
names(Data)<-gsub("BodyBody", "Body", names(Data))
names(Data)

install.packages("plyr")
library(plyr);
Data2<-aggregate(. ~subject + activity, Data, mean)
Data2<-Data2[order(Data2$subject,Data2$activity),]
write.table(Data2, file = "tidydata.txt",row.name=FALSE)
