# merges the training and the test sets to create on data set

Xtrain <- read.table("train/X_train.txt")
ytrain <- read.table("train/y_train.txt")
sub_train <- read.table("train/subject_train.txt")

Xtest <- read.table("test/X_test.txt")
ytest <- read.table("test/y_test.txt")
sub_test <- read.table("test/subject_test.txt")

dim(Xtrain)
dim(Xtest)


Xmerge <- rbind(Xtrain, Xtest)
ymerge <- rbind(ytrain, ytest)
submerge <- rbind(sub_train, sub_test)
dim(Xmerge)
dim(ymerge)
dim(submerge)

# extracts only the measurements on the mean and standard deviation for each measurement
feature <- read.table("features.txt")
index <- grep(".mean().|.std().", feature$V2)
extract <- Xmerge[, index]
index

# uses descriptive activity names to name the activities in the data set
actlabel <- read.table("activity_labels.txt")
extract <- cbind(extract, Active=actlabel[ymerge[, 1], 2])
extract

# appropriately lavels the data set with descriptive variable names.
colnames(extract) <- feature[index, 2]
colnames(extract)[80] <- c("Activity") 
extract <- cbind(extract, Subject=ymerge[, 1])

# from the data set in step4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

library(data.table)
extract <- data.table(extract)
TidyData <- extract[, lapply(.SD, mean), by = .(Subject, Activity)]
write.table(TidyData, file="Tidy.txt", row.names=FALSE)
TidyData
