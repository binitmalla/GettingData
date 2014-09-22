setwd("./coursera/Getting and Cleaning Data/Course Project")
library(data.table)

#Load Activity labels
activity_labels <- read.table("./activity_labels.txt")[,2]

#Load features
features <-  read.table("features.txt", strip.white=TRUE, stringsAsFactors=FALSE)
head(features)

#Load test data:
y_test <- read.table("./test/y_test.txt", col.names="label")
subject_test <- read.table("./test/subject_test.txt", col.names="subject")
x_test <- read.table("./test/X_test.txt")

#Add column names
names(x_test)=features[,2]

#Add a second column with description
y_test[,2]=activity_labels[y_test[,1]]
names(y_test)=c("ID","Activity")
names(subject_test)="Subject"

#Bind data
test_merged_data<-cbind(subject_test,y_test,x_test)

#Load train data:
y_train <- read.table("./train/y_train.txt", col.names="label")
subject_train <- read.table("./train/subject_train.txt", col.names="subject")
x_train <- read.table("./train/X_train.txt")

#Add column names
names(x_train)=features[,2]

#Add a second column with description
y_train[,2]=activity_labels[y_train[,1]]
names(y_train)=c("ID","Activity")
names(subject_train)="Subject"


#Bind data
train_merged_data<-cbind(subject_train,y_train,x_train)

#Combined test and train data
merged_data<-rbind(test_merged_data,train_merged_data)

head(merged_data)
colnames(merged_data)

#Extract mean and std for each observation

selectcolumns <- features[grep("mean\\(\\)|std\\(\\)", features$V2), ]

#Step4 - clean column names
clean_colnames <- tolower(gsub("[^[:alpha:]]", "", colnames(merged_data)))
head(clean_colnames)
colnames(merged_data)<-clean_colnames
head(merged_data)

#Step5
tidy_data<-merged_data[,c(1:3,3+selectcolumns$V1)]
tidy_data<-aggregate(tidy_data,by=list(tidy_data$subject,label=tidy_data$activity),mean)
tidy_data<-tidy_data[,c(1:2,6:ncol(tidy_data))]


write.table(format(tidy_data, scientific=T), "tidy.txt",row.names=F, col.names=F, quote=2)