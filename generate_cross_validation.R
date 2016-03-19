#!/usr/bin/Rscript
# R script to generate cross-validation training and test set for BernoulliMix
#
# (c) Prem Raj Adhikari
#     www.premraj.me
#     August, 2015

# Check for the presence of libararies, otherwise try to install it. 
# We need caret package for creating folds in cross-validation 

for (package in c('caret')) {
  if (!require(package, character.only=T, quietly=T)) {
  	 install.packages(x,dep=TRUE)
     if(!require(package)){
      stop(paste0("could not install the package: ",package))
       return(NULL)
    }
  }
}
# or simply
# library(caret)

# Delete workspace::  only variables not functions
rm(list = setdiff(ls(), lsf.str()))

# Clear screen 
cat("\014")  

# Load the simulated data
sim_data <- as.matrix(read.table("artificial_data.data",
sep=" ", header=FALSE, row.names=NULL))

# Add noise to data::

# first set the random seed for reproducibility
set.seed(42)

# Randomly sample numbers for rows to flip 
crows <- sample(1:nrow(sim_data),15000,replace=T)

# Randomly sample numbers for columns to flip 
ccols <- sample(1:ncol(sim_data),15000,replace=T)

# Flip the bits in those rows and columns							
sim_data[cbind(crows,ccols)] <- !(sim_data[cbind(crows,ccols)])


# Divide the data for cross validation 
noFolds <- 10 # Number of Folds

# Create folds using caret package; useful for stratified sampling
folds <- createFolds(factor(sim_data[,1]), k=noFolds, list=FALSE)


for(i in 1:noFolds)
{
	# in i^th fold everything except i is training set
   	train <- sim_data[!(folds == i), , drop=FALSE]
   	
   	# in i^th fold i is the test set
   	test <- sim_data[(folds == i), , drop=FALSE] 
	
	# Write the test and train data as required by BernoulliMix Program Package
	write.table(train, file = paste("train",i,".data",sep=""), 
	na = "NA",sep = " ",eol = "\n", dec = ".", row.names = FALSE,
	col.names = FALSE, qmethod = c("escape", "double"),fileEncoding = "") 
	
	write.table(test, file = paste("test",i,".data",sep=""),
	sep = " ",eol = "\n", na = "NA", dec = ".", row.names = FALSE,
	col.names = FALSE, qmethod = c("escape", "double"),fileEncoding = "") 

}



